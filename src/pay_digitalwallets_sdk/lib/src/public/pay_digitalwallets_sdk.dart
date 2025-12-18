// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk/pay_digitalwallets_sdk.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_platform_interface.dart';

/// The main entry point into the Flutter Olo Digital Wallets SDK.
///
/// This class is responsible for configuring the SDK (see [configure])
/// and creating [PaymentData] instances via digital wallets
/// (see [getPaymentData]).
///
/// **Important:** Attempting to get payment data prior to configuring
/// the SDK will result in errors.
class PayDigitalWalletsSdk {
  /// @nodoc
  PayDigitalWalletsSdkPlatform get _platform =>
      PayDigitalWalletsSdkPlatform.instance;

  /// Sets a callback to know when the ready state of digital wallets changes.
  ///
  /// Attempting to get payment data via [getPaymentData]
  /// when digital wallets are not in a ready state will result in errors.
  ///
  /// Changes in app state (such as the app going in the background) and certain
  /// method calls (see [configure]) can cause the
  /// readiness of digital wallets to change.
  ///
  /// **Important:** This callback can, and likely will, be called multiple
  /// times. It is recommended to keep this callback active and update your UI
  /// accordingly whenever the app is displaying digital wallet UIs.
  set onDigitalWalletReady(DigitalWalletReadyChanged? onDigitalWalletReady) {
    PayDigitalWalletsSdkPlatform.instance.onDigitalWalletReady =
        onDigitalWalletReady;
  }

  /// Configures the Olo Digital Wallets SDK.
  ///
  /// **Important:** The SDK only needs to be configured once, even if multiple
  /// instances of [PayDigitalWalletsSdk] are created/used, but it can be called
  /// multiple times if the configuration needs to change.
  ///
  /// In order to enable digital wallets, a [configuration] must be provided.
  /// To enable Apple Pay, the config must contain a non-`null`
  /// [Configuration.applePayConfig]. Similarly a non-`null`
  /// [Configuration.googlePayConfig] is required to enable
  /// Google Pay.
  ///
  /// **Important:** The Olo Digital Wallets SDK will be fully configured when this method
  /// completes. However, digital wallets have an asynchronous callback to
  /// indicate when they are ready to be used. See [onDigitalWalletReady] for more
  /// information.
  ///
  /// If an error occurs while configuring the SDK a [PlatformException](https://api.flutter.dev/flutter/services/PlatformException-class.html) will
  /// be thrown. The [PlatformException.code](https://api.flutter.dev/flutter/services/PlatformException/code.html) property on the exception can be
  /// used to determine what went wrong and take appropriate action. The
  /// [PlatformException.message](https://api.flutter.dev/flutter/services/PlatformException/message.html) property can be used to get more information
  /// about what went wrong.
  ///
  /// When a [PlatformException](https://api.flutter.dev/flutter/services/PlatformException-class.html) is thrown, the [PlatformException.code](https://api.flutter.dev/flutter/services/PlatformException/code.html)
  /// property will be one of the following:
  /// - [ErrorCodes.unexpectedError]
  /// - [ErrorCodes.invalidParameter]
  /// - [ErrorCodes.noAllowedCardNetworks]
  /// - [ErrorCodes.emptyCompanyName]
  /// - [ErrorCodes.invalidCountryCode]
  /// - [ErrorCodes.invalidCurrencyCode]
  /// - [ErrorCodes.emptyApplePayMerchantId] _**(iOS Only)**_
  /// - [ErrorCodes.invalidGooglePaySetup] _**(Android Only)**_
  /// - [ErrorCodes.googlePayDeveloperError] _**(Android Only)**_
  Future<void> configure({
    required Configuration configuration,
  }) async {
    await _platform.configure(configuration: configuration);
  }

  /// Get payment data via Apple Pay or Google Pay
  ///
  /// If the digital wallet flow is successful, [PaymentData] will be
  /// returned. If the return value is `null` the user canceled the operation.
  ///
  /// If an error occurs a [PlatformException](https://api.flutter.dev/flutter/services/PlatformException-class.html) will be thrown. The
  /// [PlatformException.code](https://api.flutter.dev/flutter/services/PlatformException/code.html) property on the exception can be used to
  /// determine what went wrong and take appropriate action. The
  /// [PlatformException.message](https://api.flutter.dev/flutter/services/PlatformException/message.html) property can be used to get more information
  /// about what went wrong.
  ///
  /// When a [PlatformException](https://api.flutter.dev/flutter/services/PlatformException-class.html) is thrown, the [PlatformException.code](https://api.flutter.dev/flutter/services/PlatformException/code.html)
  /// property will be one of the following:
  /// - [ErrorCodes.generalError]
  /// - [ErrorCodes.unexpectedError]
  /// - [ErrorCodes.sdkNotConfigured]
  /// - [ErrorCodes.invalidParameter]
  /// - [ErrorCodes.digitalWalletNotReady]
  /// - [ErrorCodes.lineItemTotalMismatch]
  /// - [ErrorCodes.applePayUnsupported] _**(iOS Only)**_
  /// - [ErrorCodes.googlePayInternalError] _**(Android Only)**_
  /// - [ErrorCodes.googlePayDeveloperError] _**(Android Only)**_
  /// - [ErrorCodes.googlePayNetworkError] _**(Android Only)**_
  Future<PaymentData?> getPaymentData(
    PaymentParameters paymentParams,
  ) async {
    return await _platform.getPaymentData(paymentParams);
  }
}
