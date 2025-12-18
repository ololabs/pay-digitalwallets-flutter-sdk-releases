// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter/services.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/configuration.dart';

/// A list of all possible error codes that can be used in conjunction with [PlatformException]
///
/// Olo Digital Wallets SDK methods can throw a [PlatformException]. If they do, they will contain
/// a `code` property indicating the cause for the exception. The possible error codes are
/// defined in this class.
class ErrorCodes {
  /// An operation was attempted without first configuring the Digital Wallet SDK
  static const sdkNotConfigured = "SdkNotConfigured";

  /// A parameter is invalid
  ///
  /// This can occur if passing a parameter with an incorrect value (e.g. a
  /// negative payment amount or an empty string)
  static const invalidParameter = "InvalidParameter";

  /// Something really unexpected happened
  ///
  /// This error is not common and would usually indicate a problem with the
  /// state of the Flutter plugin outside of our control
  static const unexpectedError = "UnexpectedError";

  /// An Apple Pay operation was attempted on a device that doesn't support
  /// Apple Pay
  static const applePayUnsupported = "ApplePayUnsupported";

  /// The Application is not properly configured to use Google Pay
  ///
  /// This could be due to the app manifest not enabling Google Pay or because
  /// the app isn't using `FlutterFragmentActivity` or `FragmentActivity`
  static const invalidGooglePaySetup = "InvalidGooglePaySetup";

  /// A digital wallet operation was attempted when the SDK wasn't in a ready state
  static const digitalWalletNotReady = "DigitalWalletNotReady";

  /// An internal Google Pay error occurred
  static const googlePayInternalError = "Internal";

  /// An error occurred because Google Pay was not configured correctly
  static const googlePayDeveloperError = "Developer";

  /// A network error occurred while communicating with Google Pay servers
  static const googlePayNetworkError = "Network";

  /// The SDK could not be configured because the merchant
  /// id specified in [Configuration.applePayConfig] was an empty string
  static const emptyApplePayMerchantId = "EmptyMerchantId";

  /// The SDK could not be configured because the company
  /// name specified in [Configuration] was an empty string
  static const emptyCompanyName = "EmptyCompanyName";

  /// The SDK could not be configured because the country
  /// code specified in [Configuration] was not a two-character
  /// string
  static const invalidCountryCode = "InvalidCountryCode";

  /// The SDK could not be configured because the currency
  /// code specified in [Configuration] was not a three-character
  /// string
  static const invalidCurrencyCode = "InvalidCurrencyCode";

  /// A digital wallet payment data object could not be created because the total of
  /// the provided line items did not match the total amount to be paid
  static const lineItemTotalMismatch = "LineItemTotalMismatch";

  /// No supported card/payment networks were specified in the [Configuration]
  static const noAllowedCardNetworks = "NoAllowedCardNetworks";

  /// A general error occurred
  static const generalError = "GeneralError";
}
