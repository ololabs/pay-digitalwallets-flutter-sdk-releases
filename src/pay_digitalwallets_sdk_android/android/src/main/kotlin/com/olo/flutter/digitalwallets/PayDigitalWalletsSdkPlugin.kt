// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets

import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.VisibleForTesting
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import com.olo.flutter.digitalwallets.controls.GooglePayButtonFactory
import com.olo.flutter.digitalwallets.data.DataKeys
import com.olo.flutter.digitalwallets.data.ErrorCodes
import com.olo.flutter.digitalwallets.extensions.getArgOrErrorResult
import com.olo.flutter.digitalwallets.extensions.getStringArgOrErrorResult
import com.olo.flutter.digitalwallets.extensions.oloError
import com.olo.flutter.digitalwallets.extensions.safeRelease
import com.olo.flutter.digitalwallets.extensions.toMap
import com.olo.flutter.digitalwallets.googlepay.FlutterResultCallback
import com.olo.flutter.digitalwallets.googlepay.GooglePayFragment
import com.olo.flutter.digitalwallets.utils.MethodFinishedCallback
import com.olo.flutter.digitalwallets.utils.OloLog
import com.olo.flutter.digitalwallets.utils.backgroundOperation
import com.olo.flutter.digitalwallets.utils.uiOperation
import com.olo.pay.digitalwalletssdk.callbacks.ReadyCallback
import com.olo.pay.digitalwalletssdk.data.CardType
import com.olo.pay.digitalwalletssdk.data.CheckoutStatus
import com.olo.pay.digitalwalletssdk.data.Configuration
import com.olo.pay.digitalwalletssdk.data.ErrorType
import com.olo.pay.digitalwalletssdk.data.LineItem
import com.olo.pay.digitalwalletssdk.data.LineItemStatus
import com.olo.pay.digitalwalletssdk.data.LineItemType
import com.olo.pay.digitalwalletssdk.data.SdkEnvironment
import com.olo.pay.digitalwalletssdk.data.Result
import com.olo.pay.digitalwalletssdk.exceptions.GooglePayException
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result as MethodChannelResult
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Semaphore
import kotlinx.coroutines.sync.withPermit
import org.json.JSONObject
import java.lang.Exception
import java.math.BigDecimal
import kotlin.math.log10

class PayDigitalWalletsSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activityBinding: ActivityPluginBinding? = null
    private var _hasEmittedDigitalWalletReadyEvent = false

    private var _googlePayLock = Semaphore(1)
    private var _googlePayReadyLock = Semaphore(1)
    private var _googlePayConfiguredLock = Semaphore(1)

    @VisibleForTesting
    internal var _currencyMultiplier = DefaultCurrencyMultiplier

    @VisibleForTesting
    internal var testActivity: FragmentActivity? = null

    private val activity: FragmentActivity?
        get() {
            // For testing purposes, allow direct setting of activity
            if (testActivity != null) {
                return testActivity
            }

            if (activityBinding == null) {
                OloLog.w("Attempting to use activity before being setup by Flutter. Activity binding is null.")
                return null
            }

            val activity = activityBinding?.activity as? FragmentActivity

            val warningMessage = if (activity == null) {
                val message = StringBuilder("Unsupported activity detected: ")
                message.append("Activity instance should inherit from FlutterFragmentActivity or FragmentActivity\n")
                message.append("Some aspects of the Olo Digital Wallets SDK will not be available\n")
                message.append("See https://tinyurl.com/zdwjwuj8 for specifics\n\n")
                message.append("Activity hierarchy: ${getObjectHierarchy(activityBinding!!.activity)}")
                message.toString()
            } else if (activity as? FlutterFragmentActivity == null) {
                val message = StringBuilder("FragmentActivity detected instead of FlutterFragmentActivity\n")
                message.append("In most cases, FlutterFragmentActivity should be used instead of FragmentActivity\n")
                message.append("See https://tinyurl.com/zdwjwuj8 for specifics\n\n")
                message.append("Activity hierarchy: ${getObjectHierarchy(activity)}")
                message.toString()
            } else {
                null
            }

            warningMessage?.let { warning ->
                OloLog.w(warning)
            }

            return activity
        }

    private val fragmentManager: FragmentManager?
        get() = activity?.supportFragmentManager

    @VisibleForTesting
    internal lateinit var appContext: Context
    @VisibleForTesting
    internal var onMethodCallFinished: MethodFinishedCallback? = null

    //WARNING: DO NOT ACCESS OR MODIFY THESE DIRECTLY... USE THREAD-SAFE GETTERS/SETTERS
    @VisibleForTesting
    internal var _googlePayConfig: Configuration? = null
    @VisibleForTesting
    internal var _googlePayReady = false

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        OloLog.d("[PayDigitalWalletsSdkPlugin] onAttachedToEngine called - registering channel: ${DataKeys.DigitalWalletMethodChannelKey}")
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, DataKeys.DigitalWalletMethodChannelKey)
        channel.setMethodCallHandler(this)
        appContext = flutterPluginBinding.applicationContext
        OloLog.d("[PayDigitalWalletsSdkPlugin] Method channel handler set")

        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory(
                DataKeys.DigitalWalletButtonViewKey,
                GooglePayButtonFactory(flutterPluginBinding.binaryMessenger)
            )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannelResult) {
        OloLog.d("[PayDigitalWalletsSdkPlugin] onMethodCall called with method: ${call.method}")
        when (call.method) {
            DataKeys.ConfigureMethodKey -> {
                OloLog.d("[PayDigitalWalletsSdkPlugin] Handling configure method")
                configure(call, result)
            }
            DataKeys.GetPaymentDataMethodKey -> {
                OloLog.d("[PayDigitalWalletsSdkPlugin] Handling getPaymentData method")
                getPaymentData(call, result)
            }
            else -> {
                OloLog.w("[PayDigitalWalletsSdkPlugin] Method not implemented: ${call.method}")
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        verifyActivity()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityBinding = binding
        verifyActivity()
    }

    override fun onDetachedFromActivity() {
        activityBinding = null
    }

    private fun configure(call: MethodCall, result: MethodChannelResult) = googlePayLockingOperation {
        val baseError = "Unable to configure Google Pay"
        // If the configuration comes back null that means an error was reported, so we need to return
        val newConfiguration: Configuration?

        try {
            newConfiguration = getGooglePayConfiguration(call, result, baseError)
        } catch (e: GooglePayException) {
            val message = "${baseError}: Invalid value for parameter '${DataKeys.GPayGatewayParametersJsonKey}'"
            result.oloError(e.errorType.toString(), message)
            onMethodCallFinished?.invoke()
            return@googlePayLockingOperation
        }

        if (newConfiguration == null) {
            onMethodCallFinished?.invoke()
            return@googlePayLockingOperation
        }

        val appMetadata = appContext.packageManager.getApplicationInfo(
            appContext.packageName,
            PackageManager.GET_META_DATA
        ).metaData

        if (!appMetadata.containsKey("com.google.android.gms.wallet.api.enabled")) {
            result.oloError(
                ErrorCodes.InvalidGooglePaySetup,
                "${baseError}: AndroidManifest missing com.google.android.gms.wallet.api.enabled entry"
            )
            onMethodCallFinished?.invoke()
            return@googlePayLockingOperation
        }

        // Moved here for testing purposes - We cannot test anything beyond this point due to testing limitations
        if (!verifyActivity()) {
            val message = StringBuilder("${baseError}: App must use FlutterFragmentActivity or FragmentActivity\n")
            message.append("See https://tinyurl.com/zdwjwuj8 for specifics\n\n")
            result.oloError(ErrorCodes.InvalidGooglePaySetup, message.toString())
            onMethodCallFinished?.invoke()
            return@googlePayLockingOperation
        }

        val fragment = getGooglePayFragment()
        if (fragment == null) {
            val message = "${baseError}: Unexpected error occurred"
            result.oloError(ErrorCodes.UnexpectedError, message)
            onMethodCallFinished?.invoke()
            return@googlePayLockingOperation
        }

        updateGooglePayConfig(newConfiguration)
        fragment.readyCallback = ReadyCallback { isReady -> onGooglePayReady(isReady) }
        try {
            fragment.setConfiguration(newConfiguration)
        } catch (e: GooglePayException) {
            updateGooglePayConfig(fragment.configuration)

            val message = "${baseError}: Invalid value for parameter '${DataKeys.GPayGatewayParametersJsonKey}'"
            result.oloError(e.errorType.toString(), message)
            onMethodCallFinished?.invoke()
            return@googlePayLockingOperation
        }

        result.success(null)
        onMethodCallFinished?.invoke()
    }

    private fun getPaymentData(call: MethodCall, result: MethodChannelResult) = uiOperation {
        // Unable to use googlePayLockingOperation because this call waits for a callback method... we need to unlock
        // the semaphore manually
        val baseError = "Unable to get payment data"

        val decimalPlaces = log10(_currencyMultiplier.toDouble()).toInt()
        val amount: BigDecimal

        val checkoutStatus: CheckoutStatus
        val totalPriceLabel: String
        val lineItems: List<LineItem>?
        val validateLineItems: Boolean

        try {
            val amountString = call.getStringArgOrErrorResult(
                DataKeys.GPayAmountKey,
                baseError,
                false,
                result
            )

            amount = try {
                BigDecimal(amountString)
            } catch (e: NumberFormatException) {
                result.oloError(
                    ErrorCodes.UnexpectedParameterType,
                    "${baseError}: Value for '${DataKeys.GPayAmountKey}' is not a valid number"
                )
                throw e
            }

            if (amount < BigDecimal.ZERO){
                result.oloError(
                    ErrorCodes.InvalidParameter,
                    "${baseError}: Value for '${DataKeys.GPayAmountKey}' cannot be negative"
                )
                throw Exception()
            }

            val checkoutStatusString = call.getStringArgOrErrorResult(
                DataKeys.GPayCheckoutStatusKey,
                baseError,
                false,
                result
            )

            checkoutStatus = try {
                CheckoutStatus.from(checkoutStatusString)!!
            } catch (e: Exception) {
                result.oloError(
                    ErrorCodes.InvalidParameter,
                    "${baseError}: '$checkoutStatusString' is not a valid value for '${DataKeys.GPayCheckoutStatusKey}'"
                )
                throw e
            }

            totalPriceLabel = call.getStringArgOrErrorResult(
                DataKeys.GPayTotalPriceLabelKey,
                "",
                baseError,
                true,
                result
            )

            val flutterLineItems = call.getArgOrErrorResult<ArrayList<HashMap<String, Any?>>?>(
                DataKeys.GPayLineItemsKey,
                null,
                baseError,
                result
            )

            lineItems = flutterLineItems?.map { item ->
                val lineItemAmountString = item.getStringArgOrErrorResult(
                    DataKeys.LineItemAmountKey,
                    baseError,
                    false,
                    result
                )

                val lineItemAmount = try {
                    BigDecimal(lineItemAmountString).movePointRight(decimalPlaces).toLong()
                } catch (e: NumberFormatException) {
                    result.oloError(
                        ErrorCodes.InvalidParameter,
                        "${baseError}: Value for '${DataKeys.LineItemAmountKey}' is not a valid number"
                    )
                    throw e
                }

                val lineItemStatusString = item.getStringArgOrErrorResult(
                    DataKeys.LineItemStatusKey,
                    LineItemStatus.Final.name,
                    baseError,
                    false,
                    result
                )

                val lineItemStatus = try {
                    LineItemStatus.from(lineItemStatusString)!!
                } catch (e: Exception) {
                    result.oloError(
                        ErrorCodes.UnexpectedParameterType,
                        "${baseError}: '$lineItemStatusString' is not a valid value for '${DataKeys.LineItemStatusKey}'"
                    )
                    throw e
                }

                val lineItemTypeString = item.getStringArgOrErrorResult(
                    DataKeys.LineItemTypeKey,
                    baseError,
                    false,
                    result
                )

                val lineItemType = try {
                    LineItemType.from(lineItemTypeString)!!
                } catch (e: Exception) {
                    result.oloError(
                        ErrorCodes.UnexpectedParameterType,
                        "${baseError}: '$lineItemTypeString' is not a valid value for '${DataKeys.LineItemTypeKey}'"
                    )
                    throw e
                }

                val lineItemLabel = item.getStringArgOrErrorResult(
                    DataKeys.LineItemLabelKey,
                    baseError,
                    false,
                    result
                )

                LineItem(lineItemLabel, lineItemAmount, lineItemType, lineItemStatus)
            }

            validateLineItems = call.getArgOrErrorResult<Boolean>(
                DataKeys.GPayValidateLineItems,
                baseError,
                result
            )
        } catch (e: Exception) {
            onMethodCallFinished?.invoke()
            return@uiOperation
        }

        // Moved here for testing purposes - We cannot test anything beyond this point due to testing limitations
        if (!isGooglePayConfigured()) {
            result.oloError(
                ErrorCodes.SdkNotConfigured,
                "${baseError}: Google Pay has not been configured"
            )
            onMethodCallFinished?.invoke()
            return@uiOperation
        }

        if (!isGooglePayReady()) {
            result.oloError(
                ErrorCodes.DigitalWalletNotReady,
                "${baseError}: Google Pay isn't ready yet"
            )
            onMethodCallFinished?.invoke()
            return@uiOperation
        }

        _googlePayLock.acquire()

        val fragment = getGooglePayFragment()
        if (fragment == null) {
            result.oloError(
                ErrorCodes.UnexpectedError,
                "${baseError}: An unexpected error occurred"
            )
            _googlePayLock.safeRelease()
            return@uiOperation
        }

        if (!fragment.isReady) {
            val reason = if (fragment.configuration == null) {
                "Google Pay not configured"
            } else {
                "Google Pay isn't ready yet"
            }

            result.oloError(
                ErrorCodes.DigitalWalletNotReady,
                "${baseError}: $reason"
            )
            _googlePayLock.safeRelease()
            return@uiOperation
        }

        fragment.resultCallback = FlutterResultCallback { result, promise -> onGooglePayResult(result, promise) }

        try {
            fragment.present(
                amount.movePointRight(decimalPlaces).toLong(),
                checkoutStatus,
                totalPriceLabel,
                lineItems,
                validateLineItems,
                result
            )
        } catch (e: GooglePayException) {
            val message: String = if(e.errorType == ErrorType.LineItemTotalMismatch){
                "${baseError}: The sum total of the line items does not match the total amount"
            } else {
               "${baseError}: ${e.message}"
            }
            result.oloError(
                e.errorType.toString(),
                message
            )
            _googlePayLock.safeRelease()
            return@uiOperation
        } catch (e: Exception) {
            result.oloError(
                ErrorCodes.UnexpectedError,
                "${baseError}: An unexpected error occurred - ${e.message}"
            )
            _googlePayLock.safeRelease()
            return@uiOperation
        }
    }

    @VisibleForTesting
    internal fun getGooglePayConfiguration(
        call: MethodCall,
        result: MethodChannelResult,
        baseError: String
    ): Configuration? {
        try {
            val productionEnv = call.getArgOrErrorResult(
                DataKeys.GPayProductionEnvironmentKey,
                DefaultGooglePayProductionEnvironment,
                baseError,
                result
            )

            val gatewayParametersJson = call.getStringArgOrErrorResult(
                DataKeys.GPayGatewayParametersJsonKey,
                baseError,
                false,
                result
            )

            try {
                JSONObject(gatewayParametersJson) // Attempting to parse the JSON to ensure it's valid
            } catch (e: kotlin.Exception) {
                throw GooglePayException(e, ErrorType.Developer)
            }

            val countryCode = call.getStringArgOrErrorResult(
                DataKeys.GPayCountryCodeKey,
                baseError,
                false,
                result
            )

            if (countryCode.length != VALID_COUNTRY_CODE_LENGTH) {
                val message =
                    "${baseError}: Value for '${DataKeys.GPayCountryCodeKey}' must be $VALID_COUNTRY_CODE_LENGTH characters long"
                result.oloError(
                    ErrorCodes.InvalidCountryCode,
                    message
                )

                return null
            }

            val currencyCodeString = call.getStringArgOrErrorResult(
                DataKeys.GPayCurrencyCodeKey,
                baseError,
                false,
                result
            )

            if (currencyCodeString.length != VALID_CURRENCY_CODE_LENGTH) {
                val message =
                    "${baseError}: Value for '${DataKeys.GPayCurrencyCodeKey}' must be $VALID_CURRENCY_CODE_LENGTH characters long"
                result.oloError(
                    ErrorCodes.InvalidCurrencyCode,
                    message
                )

                return null
            }

            val companyName = call.getStringArgOrErrorResult(
                DataKeys.GPayCompanyNameKey,
                baseError,
                false,
                result
            )

            if (companyName.isBlank()) {
                val message = "${baseError}: '${DataKeys.GPayCompanyNameKey}' cannot be empty"
                result.oloError(
                    ErrorCodes.EmptyCompanyName,
                    message
                )

                return null
            }

            val existingPaymentMethodRequired = call.getArgOrErrorResult(
                DataKeys.GPayExistingPaymentMethodRequiredKey,
                DefaultExistingPaymentMethodRequired,
                baseError,
                result
            )

            val emailRequired = call.getArgOrErrorResult(
                DataKeys.GPayEmailRequiredKey,
                DefaultEmailRequired,
                baseError,
                result
            )

            val phoneNumberRequired = call.getArgOrErrorResult(
                DataKeys.GPayPhoneNumberRequiredKey,
                DefaultPhoneNumberRequired,
                baseError,
                result
            )

            val fullBillingAddressRequired = call.getArgOrErrorResult(
                DataKeys.GPayFullBillingAddressRequiredKey,
                DefaultFullBillingAddressRequired,
                baseError,
                result
            )

            val fullNameRequired = call.getArgOrErrorResult(
                DataKeys.GPayFullNameRequiredKey,
                DefaultFullNameRequired,
                baseError,
                result
            )

            _currencyMultiplier = call.getArgOrErrorResult(
                DataKeys.GPayCurrencyMultiplierKey,
                DefaultCurrencyMultiplier,
                baseError,
                result
            )

            val allowedCardNetworkStrings = call.getArgOrErrorResult<ArrayList<String>>(
                DataKeys.GPayAllowedCardNetworksKey,
                baseError,
                result
            )

            val allowedCardNetworks = mutableListOf<CardType>()
            for (network in allowedCardNetworkStrings) {
                when (network) {
                    DataKeys.CardTypeAmericanExpress -> allowedCardNetworks.add(CardType.AmericanExpress)
                    DataKeys.CardTypeDiscover -> allowedCardNetworks.add(CardType.Discover)
                    DataKeys.CardTypeJcb -> allowedCardNetworks.add(CardType.JCB)
                    DataKeys.CardTypeMasterCard -> allowedCardNetworks.add(CardType.MasterCard)
                    DataKeys.CardTypeVisa -> allowedCardNetworks.add(CardType.Visa)
                    DataKeys.CardTypeInterac -> allowedCardNetworks.add(CardType.Interac)
                    else -> {
                        continue
                    }
                }
            }

            if (allowedCardNetworks.isEmpty()) {
                val message =
                    "${baseError}: '${DataKeys.GPayAllowedCardNetworksKey}' must contain at least one valid card network for Google Pay"
                result.oloError(
                    ErrorCodes.NoAllowedCardNetworks,
                    message
                )

                return null
            }

            return Configuration(
                environment = if (productionEnv) SdkEnvironment.Production else SdkEnvironment.Test,
                gatewayParametersJson = gatewayParametersJson,
                companyName = companyName,
                companyCountryCode = countryCode,
                currencyCode = currencyCodeString,
                existingPaymentMethodRequired = existingPaymentMethodRequired,
                emailRequired = emailRequired,
                phoneNumberRequired = phoneNumberRequired,
                fullNameRequired = fullNameRequired,
                fullBillingAddressRequired = fullBillingAddressRequired,
                allowedCardNetworks = allowedCardNetworks
            )
        } catch (e: GooglePayException) {
            throw GooglePayException(e, e.errorType)
        } catch (_: Exception) {
            return null
        }
    }

    private suspend fun updateGooglePayConfig(config: Configuration?) {
        val previousState = isGooglePayReady()

        _googlePayConfiguredLock.withPermit {
            _googlePayConfig = config
        }

        emitDigitalWalletReadyEvent(previousState)
    }


    private suspend fun isGooglePayConfigured(): Boolean {
        _googlePayConfiguredLock.withPermit {
            return _googlePayConfig != null
        }
    }

    private suspend fun isGooglePayReady() : Boolean {
        _googlePayReadyLock.withPermit {
            return isGooglePayConfigured() && _googlePayReady
        }
    }

    private fun setGooglePayReady(ready: Boolean) = backgroundOperation {
        OloLog.d("[PayDigitalWalletsSdkPlugin] setGooglePayReady called with ready: $ready")
        val previousState = isGooglePayReady()

        _googlePayReadyLock.withPermit {
            _googlePayReady = ready
        }

        OloLog.d("[PayDigitalWalletsSdkPlugin] setGooglePayReady - calling emitDigitalWalletReadyEvent with previousState: $previousState")
        emitDigitalWalletReadyEvent(previousState)
    }

    private fun getGooglePayFragment(): GooglePayFragment? {
        val fragMgr = fragmentManager ?: return null
        var fragment = fragMgr.findFragmentByTag(GooglePayFragment.Tag) as GooglePayFragment?

        if (fragment == null) {
            fragment = GooglePayFragment()
            fragMgr.beginTransaction().add(fragment, GooglePayFragment.Tag).commit()
        }

        return fragment
    }

    private fun onGooglePayReady(isReady: Boolean) {
        setGooglePayReady(isReady)
    }

    private fun onGooglePayResult(googlePayResult: Result, promise: MethodChannelResult) {
        _googlePayLock.safeRelease()

        when (googlePayResult) {
            is Result.Completed -> {
                promise.success(googlePayResult.paymentData.toMap())
            }
            is Result.Canceled -> {
                promise.success(null)
            }
            is Result.Failed -> {
                promise.success(googlePayResult.error.toMap())
            }
        }
    }

    private fun emitDigitalWalletReadyEvent(previousState: Boolean) = uiOperation {
        val newState = isGooglePayReady()

        if (_hasEmittedDigitalWalletReadyEvent && newState == previousState) {
            return@uiOperation
        }

        _hasEmittedDigitalWalletReadyEvent = true
        val args = mapOf(DataKeys.DigitalWalletReadyParameterKey to newState)

        if (this::channel.isInitialized) {
            channel.invokeMethod(DataKeys.DigitalWalletReadyEventHandlerKey, args)
        }
    }

    private fun googlePayLockingOperation(operation: suspend() -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            _googlePayLock.withPermit {
                operation()
            }
        }
    }

    private fun verifyActivity(): Boolean {
        return activity != null
    }

    fun getObjectHierarchy(obj: Any): String {
        val hierarchy = mutableListOf<String>()
        var currentClass: Class<*>? = obj::class.java

        while (currentClass != null) {
            hierarchy.add(currentClass.name)
            currentClass = currentClass.superclass
        }

        return hierarchy.joinToString("\n -> ")
    }

    companion object {
        // Default Google Pay Initialization Options
        const val DefaultGooglePayProductionEnvironment = true
        const val DefaultExistingPaymentMethodRequired = false
        const val DefaultEmailRequired = false
        const val DefaultPhoneNumberRequired = false
        const val DefaultFullNameRequired = false
        const val DefaultFullBillingAddressRequired = false
        const val DefaultCurrencyMultiplier = 100

        const val VALID_COUNTRY_CODE_LENGTH = 2
        const val VALID_CURRENCY_CODE_LENGTH = 3
    }
}