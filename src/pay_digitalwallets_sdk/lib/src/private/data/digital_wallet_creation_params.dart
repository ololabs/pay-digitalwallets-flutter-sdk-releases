// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:collection/collection.dart';
import 'package:pay_digitalwallets_sdk/src/private/data/data_keys.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/apple_pay_button_configuration.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/google_pay_button_configuration.dart';

class DigitalWalletCreationParams {
  final ApplePayButtonConfiguration applePayConfig;
  final GooglePayButtonConfiguration googlePayConfig;
  final bool enabled;

  const DigitalWalletCreationParams({
    required this.applePayConfig,
    required this.googlePayConfig,
    required this.enabled,
  });

  bool isEqualTo(DigitalWalletCreationParams? other) {
    return const DeepCollectionEquality().equals(toMap(), other?.toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> dataMap = {DataKeys.enabledParameterKey: enabled};

    dataMap.addAll(applePayConfig.toMap());
    dataMap.addAll(googlePayConfig.toMap());

    return dataMap;
  }
}
