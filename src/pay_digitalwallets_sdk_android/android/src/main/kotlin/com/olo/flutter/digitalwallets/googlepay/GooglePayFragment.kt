// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets.googlepay

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import com.olo.pay.digitalwalletssdk.data.Configuration
import com.olo.pay.digitalwalletssdk.data.SdkEnvironment
import com.olo.pay.digitalwalletssdk.data.Result
import com.olo.pay.digitalwalletssdk.GooglePayLauncher
import com.olo.pay.digitalwalletssdk.callbacks.ReadyCallback
import com.olo.pay.digitalwalletssdk.callbacks.ResultCallback
import com.olo.pay.digitalwalletssdk.data.CheckoutStatus
import com.olo.pay.digitalwalletssdk.data.LineItem
import io.flutter.plugin.common.MethodChannel

class GooglePayFragment : Fragment() {
    private var _isReady = false
    private var _googlePayLauncher: GooglePayLauncher? = null
    private var _promise: MethodChannel.Result? = null

    val configuration: Configuration?
        get() = requireArguments().getParcelable(ConfigurationKey) as Configuration?

    var resultCallback: FlutterResultCallback? = null

    private var _readyCallback: ReadyCallback? = null
    var readyCallback: ReadyCallback?
        get() = _readyCallback
        set(callback) {
            _readyCallback = callback
            if (isReady)
                onGooglePayReady(isReady)
        }

    init {
        arguments = Bundle()
    }

    val isReady: Boolean
        get() = _isReady

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        return FrameLayout(requireActivity()).also {
            it.visibility = View.GONE
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // If google pay config wasn't set by now, create a temporary dummy config
        val config = configuration ?: Configuration(
            environment = SdkEnvironment.Production,
            gatewayParametersJson = "{}",
            companyName = "",
        )

        _googlePayLauncher = GooglePayLauncher(this, config, ::onGooglePayReady, null)
    }

    fun setConfiguration(newConfig: Configuration) {
        requireArguments().putParcelable(ConfigurationKey, newConfig)

        _googlePayLauncher?.let {
            it.config = newConfig
        }
    }

    fun present(
        amount: Long,
        checkoutStatus: CheckoutStatus,
        totalPriceLabel: String?,
        listItems: List<LineItem>?,
        validateLineItems: Boolean,
        promise: MethodChannel.Result,
    ) {
        _promise = promise
        _googlePayLauncher?.resultCallback = ResultCallback { result -> onResult(result) }
        _googlePayLauncher?.present(amount, checkoutStatus, totalPriceLabel, listItems, validateLineItems)
    }

    private fun onResult(result: Result) {
        if (_promise != null)
            resultCallback?.onResult(result, _promise!!)
    }

    private fun onGooglePayReady(isReady: Boolean) {
        _isReady = isReady
        readyCallback?.onReady(_isReady)
    }

    companion object {
        const val Tag = "com.olo.flutter.digitalwallets.googlepay.GooglePayFragment"
        private const val ConfigurationKey = "${Tag}.Configuration"
    }
}

fun interface FlutterResultCallback {
    fun onResult(result: Result, promise: MethodChannel.Result)
}