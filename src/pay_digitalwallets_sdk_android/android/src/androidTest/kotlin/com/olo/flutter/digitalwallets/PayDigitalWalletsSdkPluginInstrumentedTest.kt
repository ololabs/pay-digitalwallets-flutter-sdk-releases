// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets

import android.app.Application
import android.util.Log
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentTransaction
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import com.olo.flutter.digitalwallets.data.DataKeys
import com.olo.flutter.digitalwallets.data.ErrorCodes
import com.olo.flutter.digitalwallets.googlepay.GooglePayFragment
import com.olo.flutter.digitalwallets.utils.MethodFinishedCallback
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import junit.framework.TestCase.assertNull
import kotlinx.coroutines.runBlocking
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito

@RunWith(AndroidJUnit4::class)
class PayDigitalWalletsSdkPluginInstrumentedTest {
    private val testApplication: Application
        get() = InstrumentationRegistry.getInstrumentation().targetContext.applicationContext as Application

    private val configureBaseError = "Unable to configure Google Pay"
    private var _plugin: PayDigitalWalletsSdkPlugin? = null

    private val plugin: PayDigitalWalletsSdkPlugin
        get() = _plugin!!

    @Before
    fun setup() {
        _plugin = PayDigitalWalletsSdkPlugin()
        plugin.appContext = testApplication

        // Set up mock activity with fragment manager
        // We return null for the fragment to simulate that it doesn't exist yet
        // The plugin will handle creating it when needed
        val mockActivity = Mockito.mock(FragmentActivity::class.java)
        val mockFragmentManager = Mockito.mock(FragmentManager::class.java)
        val mockFragmentTransaction = Mockito.mock(FragmentTransaction::class.java)

        Mockito.`when`(mockActivity.supportFragmentManager).thenReturn(mockFragmentManager)
        Mockito.`when`(mockFragmentManager.findFragmentByTag(GooglePayFragment.Tag)).thenReturn(null)
        Mockito.`when`(mockFragmentManager.beginTransaction()).thenReturn(mockFragmentTransaction)
        Mockito.`when`(mockFragmentTransaction.add(Mockito.any(), Mockito.anyString())).thenReturn(mockFragmentTransaction)
        Mockito.`when`(mockFragmentTransaction.commit()).thenReturn(0)

        plugin.testActivity = mockActivity
    }

    @After
    fun teardown() {
        _plugin = null
    }

    // MARK: - configure Tests

    @Test
    fun configure_withAllParameters_returnsSuccess() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayProductionEnvironmentKey to false,
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayExistingPaymentMethodRequiredKey to false,
            DataKeys.GPayEmailRequiredKey to true,
            DataKeys.GPayPhoneNumberRequiredKey to true,
            DataKeys.GPayFullBillingAddressRequiredKey to true,
            DataKeys.GPayFullNameRequiredKey to true,
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa", "mastercard")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withRequiredParametersOnly_returnsSuccess() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    // MARK: - Missing Parameter Tests

    @Test
    fun configure_withMissingGatewayParametersJson_returnsMissingParameter() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.MissingParameter,
                "$configureBaseError: Missing parameter 'googlePayGatewayParametersJson'",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withMissingCountryCode_returnsMissingParameter() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.MissingParameter,
                "$configureBaseError: Missing parameter 'countryCode'",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withMissingCurrencyCode_returnsMissingParameter() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.MissingParameter,
                "$configureBaseError: Missing parameter 'currencyCode'",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withMissingCompanyName_returnsMissingParameter() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.MissingParameter,
                "$configureBaseError: Missing parameter 'companyLabel'",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withMissingAllowedCardNetworks_returnsMissingParameter() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company"
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.MissingParameter,
                "$configureBaseError: Missing parameter 'allowedCardNetworks'",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    // MARK: - Empty/Invalid Parameter Tests

    @Test
    fun configure_withEmptyGatewayParametersJson_returnsInvalidParameter() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to "",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.InvalidParameter,
                "$configureBaseError: Value for 'googlePayGatewayParametersJson' cannot be empty",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withEmptyCountryCode_returnsInvalidParameter() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.InvalidParameter,
                "$configureBaseError: Value for 'countryCode' cannot be empty",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withEmptyCurrencyCode_returnsInvalidParameter() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.InvalidParameter,
                "$configureBaseError: Value for 'currencyCode' cannot be empty",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withEmptyCompanyName_returnsInvalidParameter() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.InvalidParameter,
                "$configureBaseError: Value for 'companyLabel' cannot be empty",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withEmptyAllowedCardNetworks_returnsNoAllowedCardNetworks() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf<String>()
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.NoAllowedCardNetworks,
                "$configureBaseError: 'allowedCardNetworks' must contain at least one valid card network for Google Pay",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withOnlyInvalidCardNetworks_returnsNoAllowedCardNetworks() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("invalid", "unknown")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.NoAllowedCardNetworks,
                "$configureBaseError: 'allowedCardNetworks' must contain at least one valid card network for Google Pay",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    // MARK: - getPaymentData Tests

    @Test
    fun getPaymentData_sdkNotConfigured_returnsSdkNotConfigured() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.SdkNotConfigured,
                "Unable to get payment data: Google Pay has not been configured",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_amountMissing_returnsMissingParameter() = runBlocking {
        configureGooglePay()

        val arguments = mapOf(
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.MissingParameter),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Missing parameter 'amount'"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_amountNotDouble_returnsUnexpectedParameterType() = runBlocking {
        configureGooglePay()

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "abc",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.UnexpectedParameterType),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Value for 'amount' is not a valid number"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_amountNegative_returnsInvalidParameter() = runBlocking {
        configureGooglePay()

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "-10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.InvalidParameter,
                "Unable to get payment data: Value for 'amount' cannot be negative",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_checkoutStatusMissing_returnsMissingParameter() = runBlocking {
        configureGooglePay()

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayValidateLineItems to false
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.MissingParameter),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Missing parameter 'googlePayCheckoutStatus'"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_checkoutStatusInvalid_returnsInvalidParameter() = runBlocking {
        configureGooglePay()

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "invalid",
            DataKeys.GPayValidateLineItems to false
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.InvalidParameter,
                "Unable to get payment data: 'invalid' is not a valid value for 'googlePayCheckoutStatus'",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_checkoutStatusNotString_returnsUnexpectedParameterType() = runBlocking {
        configureGooglePay()

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to 123,
            DataKeys.GPayValidateLineItems to false
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.UnexpectedParameterType),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Value for 'googlePayCheckoutStatus' is not of type String"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_validateLineItemsMissing_returnsMissingParameter() = runBlocking {
        configureGooglePay()

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault"
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.MissingParameter),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Missing parameter 'validateLineItems'"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_validateLineItemsNotBoolean_returnsUnexpectedParameterType() = runBlocking {
        configureGooglePay()

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to "false"
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.UnexpectedParameterType),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Value for 'validateLineItems' is not of type Boolean"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_totalPriceLabelNotString_returnsUnexpectedParameterType() = runBlocking {
        configureGooglePay()

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false,
            DataKeys.GPayTotalPriceLabelKey to 123
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.UnexpectedParameterType),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Value for 'totalPriceLabel' is not of type String"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_lineItemsNotArray_returnsUnexpectedParameterType() = runBlocking {
        configureGooglePay()

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false,
            DataKeys.GPayLineItemsKey to "not an array"
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.UnexpectedParameterType),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Value for 'lineItems' is not of type ArrayList"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    // MARK: - Line Item Validation Tests

    @Test
    fun getPaymentData_lineItemLabelMissing_returnsMissingParameter() = runBlocking {
        configureGooglePay()

        val lineItem = hashMapOf<String, Any?>(
            DataKeys.LineItemAmountKey to "5.00",
            DataKeys.LineItemTypeKey to "subtotal",
            DataKeys.LineItemStatusKey to "final"
        )

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false,
            DataKeys.GPayLineItemsKey to arrayListOf(lineItem)
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.MissingParameter),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Missing parameter 'lineItemLabel'"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_lineItemLabelEmpty_returnsInvalidParameter() = runBlocking {
        configureGooglePay()

        val lineItem = hashMapOf<String, Any?>(
            DataKeys.LineItemLabelKey to "",
            DataKeys.LineItemAmountKey to "5.00",
            DataKeys.LineItemTypeKey to "subtotal",
            DataKeys.LineItemStatusKey to "final"
        )

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false,
            DataKeys.GPayLineItemsKey to arrayListOf(lineItem)
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.InvalidParameter,
                "Unable to get payment data: Value for 'lineItemLabel' cannot be empty",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_lineItemLabelNotString_returnsUnexpectedParameterType() = runBlocking {
        configureGooglePay()

        val lineItem = hashMapOf<String, Any?>(
            DataKeys.LineItemLabelKey to 123,
            DataKeys.LineItemAmountKey to "5.00",
            DataKeys.LineItemTypeKey to "subtotal",
            DataKeys.LineItemStatusKey to "final"
        )

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false,
            DataKeys.GPayLineItemsKey to arrayListOf(lineItem)
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.UnexpectedParameterType),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Value for 'lineItemLabel' is not of type String"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_lineItemAmountMissing_returnsMissingParameter() = runBlocking {
        configureGooglePay()

        val lineItem = hashMapOf<String, Any?>(
            DataKeys.LineItemLabelKey to "Subtotal",
            DataKeys.LineItemTypeKey to "subtotal",
            DataKeys.LineItemStatusKey to "final"
        )

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false,
            DataKeys.GPayLineItemsKey to arrayListOf(lineItem)
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.MissingParameter),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Missing parameter 'lineItemAmount'"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_lineItemAmountNotDouble_returnsInvalidParameter() = runBlocking {
        configureGooglePay()

        val lineItem = hashMapOf<String, Any?>(
            DataKeys.LineItemLabelKey to "Subtotal",
            DataKeys.LineItemAmountKey to "abc",
            DataKeys.LineItemTypeKey to "subtotal",
            DataKeys.LineItemStatusKey to "final"
        )

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false,
            DataKeys.GPayLineItemsKey to arrayListOf(lineItem)
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.InvalidParameter),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Value for 'lineItemAmount' is not a valid number"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_lineItemTypeMissing_returnsMissingParameter() = runBlocking {
        configureGooglePay()

        val lineItem = hashMapOf<String, Any?>(
            DataKeys.LineItemLabelKey to "Subtotal",
            DataKeys.LineItemAmountKey to "5.00",
            DataKeys.LineItemStatusKey to "final"
        )

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false,
            DataKeys.GPayLineItemsKey to arrayListOf(lineItem)
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.MissingParameter),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Missing parameter 'lineItemType'"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_lineItemTypeEmpty_returnsInvalidParameter() = runBlocking {
        configureGooglePay()

        val lineItem = hashMapOf<String, Any?>(
            DataKeys.LineItemLabelKey to "Subtotal",
            DataKeys.LineItemAmountKey to "5.00",
            DataKeys.LineItemTypeKey to "",
            DataKeys.LineItemStatusKey to "final"
        )

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false,
            DataKeys.GPayLineItemsKey to arrayListOf(lineItem)
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.InvalidParameter,
                "Unable to get payment data: Value for 'lineItemType' cannot be empty",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_lineItemTypeNotString_returnsUnexpectedParameterType() = runBlocking {
        configureGooglePay()

        val lineItem = hashMapOf<String, Any?>(
            DataKeys.LineItemLabelKey to "Subtotal",
            DataKeys.LineItemAmountKey to "5.00",
            DataKeys.LineItemTypeKey to 123,
            DataKeys.LineItemStatusKey to "final"
        )

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false,
            DataKeys.GPayLineItemsKey to arrayListOf(lineItem)
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.UnexpectedParameterType),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Value for 'lineItemType' is not of type String"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getPaymentData_lineItemStatusNotString_returnsUnexpectedParameterType() = runBlocking {
        configureGooglePay()

        val lineItem = hashMapOf<String, Any?>(
            DataKeys.LineItemLabelKey to "Subtotal",
            DataKeys.LineItemAmountKey to "5.00",
            DataKeys.LineItemTypeKey to "subtotal",
            DataKeys.LineItemStatusKey to 123
        )

        val arguments = mapOf(
            DataKeys.GPayAmountKey to "10.50",
            DataKeys.GPayCheckoutStatusKey to "finaldefault",
            DataKeys.GPayValidateLineItems to false,
            DataKeys.GPayLineItemsKey to arrayListOf(lineItem)
        )
        val call = MethodCall(DataKeys.GetPaymentDataMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                org.mockito.ArgumentMatchers.eq(ErrorCodes.UnexpectedParameterType),
                org.mockito.ArgumentMatchers.eq("Unable to get payment data: Value for 'lineItemStatus' is not of type String"),
                org.mockito.ArgumentMatchers.isNull()
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    // MARK: - Edge Case Tests

    @Test
    fun configure_withProductionEnvironmentNotBoolean_returnsUnexpectedParameterType() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayProductionEnvironmentKey to "true",
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.UnexpectedParameterType,
                "$configureBaseError: Value for 'googlePayProductionEnvironment' is not of type Boolean",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withCountryCodeNotString_returnsUnexpectedParameterType() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to 12345,
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.UnexpectedParameterType,
                "$configureBaseError: Value for 'countryCode' is not of type String",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withCurrencyCodeNotString_returnsUnexpectedParameterType() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to 123,
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.UnexpectedParameterType,
                "$configureBaseError: Value for 'currencyCode' is not of type String",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withCompanyNameNotString_returnsUnexpectedParameterType() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to 12345,
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.UnexpectedParameterType,
                "$configureBaseError: Value for 'companyLabel' is not of type String",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withAllowedCardNetworksNotArray_returnsUnexpectedParameterType() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to "visa,mastercard"
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.UnexpectedParameterType,
                "$configureBaseError: Value for 'allowedCardNetworks' is not of type ArrayList",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withEmailRequiredNotBoolean_returnsUnexpectedParameterType() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayEmailRequiredKey to "true",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.UnexpectedParameterType,
                "$configureBaseError: Value for 'emailRequired' is not of type Boolean",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withPhoneNumberRequiredNotBoolean_returnsUnexpectedParameterType() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayPhoneNumberRequiredKey to 1,
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.UnexpectedParameterType,
                "$configureBaseError: Value for 'phoneNumberRequired' is not of type Boolean",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withFullNameRequiredNotBoolean_returnsUnexpectedParameterType() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayFullNameRequiredKey to 1.5,
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.UnexpectedParameterType,
                "$configureBaseError: Value for 'fullNameRequired' is not of type Boolean",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun configure_withFullBillingAddressRequiredNotBoolean_returnsUnexpectedParameterType() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayFullBillingAddressRequiredKey to "yes",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                ErrorCodes.UnexpectedParameterType,
                "$configureBaseError: Value for 'fullBillingAddressRequired' is not of type Boolean",
                null
            )
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    // MARK: - Helper Methods

    private fun configureGooglePay() = runBlocking {
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall(DataKeys.ConfigureMethodKey, arguments)

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            expectation.fulfill()
        }

        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }
}
