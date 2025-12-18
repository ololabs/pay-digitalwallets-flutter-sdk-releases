// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_data_classes.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_data_types.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of pay_digitalwallets_sdk must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `PayDigitalWalletsSdk`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [PayDigitalWalletsSdkPlatform] methods.
abstract class PayDigitalWalletsSdkPlatform extends PlatformInterface {
  /// Constructs a PayDigitalWalletsSdkPlatform.
  PayDigitalWalletsSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static PayDigitalWalletsSdkPlatform? _instance;

  /// The default instance of [PayDigitalWalletsSdkPlatform] to use.
  ///
  /// Platform-specific implementations will set this when they register themselves.
  static PayDigitalWalletsSdkPlatform get instance {
    if (_instance == null) {
      throw UnimplementedError(
        'PayDigitalWalletsSdk has not been implemented for this platform.',
      );
    }
    return _instance!;
  }

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [PayDigitalWalletsSdkPlatform] when they register themselves.
  static set instance(PayDigitalWalletsSdkPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  DigitalWalletReadyChanged? onDigitalWalletReady;

  Future<void> configure({
    required Configuration configuration,
  }) async {
    throw UnimplementedError(
        'configure() has not been implemented on this platform.');
  }

  Future<PaymentData?> getPaymentData(
    PaymentParameters paymentParams,
  ) async {
    throw UnimplementedError(
        'getPaymentData() has not been implemented on this platform.');
  }
}
