// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets.data

class ErrorCodes {
    companion object {
        // Method call rejection code keys
        const val InvalidParameter = "InvalidParameter"
        const val MissingParameter = "MissingParameter"
        const val UnexpectedParameterType = "UnexpectedParameterType"
        const val SdkNotConfigured = "SdkNotConfigured"
        const val InvalidGooglePaySetup = "InvalidGooglePaySetup"
        const val DigitalWalletNotReady = "DigitalWalletNotReady"
        const val NoAllowedCardNetworks = "NoAllowedCardNetworks"
        const val UnexpectedError = "UnexpectedError"
        const val EmptyCompanyName = "EmptyCompanyName"
        const val InvalidCountryCode = "InvalidCountryCode"
        const val InvalidCurrencyCode = "InvalidCurrencyCode"
    }
}