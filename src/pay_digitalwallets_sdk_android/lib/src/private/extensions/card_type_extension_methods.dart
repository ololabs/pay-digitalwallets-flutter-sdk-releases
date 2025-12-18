// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/card_type.dart';
import 'package:pay_digitalwallets_sdk_android/src/private/data/data_keys.dart';

extension CardTypeExtensions on CardType {
  /// @nodoc
  static CardType from(String? stringValue) {
    switch (stringValue?.toLowerCase()) {
      case DataKeys.visaFieldValue:
        return CardType.visa;
      case DataKeys.amexFieldValue:
        return CardType.americanExpress;
      case DataKeys.discoverFieldValue:
        return CardType.discover;
      case DataKeys.masterCardFieldValue:
        return CardType.masterCard;
      case DataKeys.jcbFieldValue:
        return CardType.jcb;
      case DataKeys.interacFieldValue:
        return CardType.interac;
      default:
        return CardType.unsupported;
    }
  }
}
