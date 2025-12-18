// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  ErrorCodes.swift
//  Pods
//
//  Created by Richard Dowdy on 11/19/25.
//

import Foundation

public class ErrorCodes {
    // Method Call Rejection Codes
    public static let InvalidParameter = "InvalidParameter"
    public static let MissingParameter = "MissingParameter"
    public static let UnexpectedError = "UnexpectedError"
    public static let UnexpectedParameterType = "UnexpectedParameterType"
    public static let ApplePayUnsupported = "ApplePayUnsupported"
    public static let SdkNotConfigured = "SdkNotConfigured"
    public static let EmptyMerchantId = "EmptyMerchantId"
    public static let EmptyCompanyLabel = "EmptyCompanyName"
    public static let InvalidCountryCode = "InvalidCountryCode"
    public static let InvalidCurrencyCode = "InvalidCurrencyCode"
    public static let LineItemTotalMismatch = "LineItemTotalMismatch"
    public static let DigitalWalletNotReady = "DigitalWalletNotReady"
    public static let NoAllowedPaymentNetworks = "NoAllowedCardNetworks"
    public static let GeneralError = "GeneralError"
}
