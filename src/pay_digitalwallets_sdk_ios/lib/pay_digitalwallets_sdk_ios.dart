// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pay_digitalwallets_sdk_ios/src/private/data/data_keys.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_data_classes.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_platform_interface.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/extensions/method_channel_extensions.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/factories/platform_exception_factory.dart';

/// The iOS implementation of [PayDigitalWalletsSdkPlatform].
class PayDigitalWalletsSdkIOS extends PayDigitalWalletsSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel(DataKeys.digitalWalletMethodChannelKey);

  /// Registers this class as the default instance of [PayDigitalWalletsSdkPlatform]
  static void registerWith() {
    PayDigitalWalletsSdkPlatform.instance = PayDigitalWalletsSdkIOS();
  }

  @override
  Future<void> configure({
    required Configuration configuration,
  }) async {
    methodChannel.setMethodCallHandler(methodChannelHandler);

    try {
      return await methodChannel.invokeOloMethod<void>(
        DataKeys.configureMethodKey,
        configuration.toMap(),
      );
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  @override
  Future<PaymentData?> getPaymentData(
    PaymentParameters paymentParams,
  ) async {
    Map<dynamic, dynamic>? result;

    try {
      result = await methodChannel.invokeOloMapMethod(
        DataKeys.getPaymentDataMethodKey,
        paymentParams.toMap(),
      );
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }

    if (result == null) {
      return null; // User cancelled
    }

    if (result.containsKey(DataKeys.pdTokenKey)) {
      return PaymentData.fromMap(result);
    }

    // An error occurred
    String digitalWalletType = result[DataKeys.digitalWalletTypeKey] ?? 'Unknown';
    String errorMessage =
        "$digitalWalletType: ${result[DataKeys.errorMessageKey] ?? 'Unknown error'}";
    String? errorCode = result[DataKeys.errorCodeKey];

    throw PlatformExceptionFactory.create(
      errorDetails: errorMessage,
      errorCode: errorCode ?? ErrorCodes.unexpectedError,
      userMessage: errorMessage,
      shouldAssert: false,
    );
  }

  Future<dynamic> methodChannelHandler(MethodCall call) async {
    if (call.method == DataKeys.digitalWalletReadyEventHandlerKey) {
      onDigitalWalletReady?.call(
        call.arguments[DataKeys.digitalWalletReadyParameterKey],
      );
    }
  }
}
