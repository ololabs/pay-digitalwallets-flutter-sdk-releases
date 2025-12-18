// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/address.dart';
import 'package:pay_digitalwallets_sdk_ios/src/private/data/data_keys.dart';

extension AddressExtensions on Address {
  static Address fromMap(Map<String, dynamic> map) {
    return Address(
      address1: map[DataKeys.address1Key],
      address2: "",
      address3: "",
      locality: map[DataKeys.localityKey],
      administrativeArea: map[DataKeys.administrativeAreaKey],
      postalCode: map[DataKeys.postalCodeKey],
      countryCode: map[DataKeys.countryCodeKey],
      sortingCode: "",
    );
  }
}
