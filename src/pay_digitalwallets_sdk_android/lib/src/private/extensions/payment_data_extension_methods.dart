// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk_android/src/private/data/data_keys.dart';
import 'package:pay_digitalwallets_sdk_android/src/private/extensions/address_extension_methods.dart';
import 'package:pay_digitalwallets_sdk_android/src/private/extensions/card_type_extension_methods.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/payment_data.dart';

extension PaymentDataExtensions on PaymentData {
  /// @nodoc
  static PaymentData fromMap(Map<dynamic, dynamic> map) {
    return PaymentData(
      token: map[DataKeys.pdTokenKey],
      lastFour: map[DataKeys.pdLastFourKey],
      cardType: CardTypeExtensions.from(map[DataKeys.pdCardTypeKey]),
      oloCardDescription: map[DataKeys.pdOloCardDescriptionKey],
      cardDetails: map[DataKeys.pdCardDetailsKey],
      email: map[DataKeys.pdEmailKey],
      phoneNumber: map[DataKeys.pdPhoneNumberKey],
      fullName: map[DataKeys.pdFullNameKey],
      fullPhoneticName: "",
      billingAddress:
          AddressExtensions.fromMap(map[DataKeys.pdBillingAddressKey]),
    );
  }
}
