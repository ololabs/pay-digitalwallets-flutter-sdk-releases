// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_digitalwallets_sdk_ios/src/private/extensions/address_extension_methods.dart';
import 'package:pay_digitalwallets_sdk_ios/src/private/data/data_keys.dart';

void main() {
  group('AddressExtensionMethods', () {
    group('fromMap', () {
      test('should create Address from complete map', () {
        final map = {
          DataKeys.address1Key: '123 Main St',
          DataKeys.localityKey: 'New York',
          DataKeys.administrativeAreaKey: 'NY',
          DataKeys.postalCodeKey: '10001',
          DataKeys.countryCodeKey: 'US',
        };

        final address = AddressExtensions.fromMap(map);

        expect(address.address1, '123 Main St');
        expect(address.address2, '');
        expect(address.address3, '');
        expect(address.locality, 'New York');
        expect(address.administrativeArea, 'NY');
        expect(address.postalCode, '10001');
        expect(address.countryCode, 'US');
        expect(address.sortingCode, '');
      });

      test('should ignore extra fields in the map', () {
        final map = {
          DataKeys.address1Key: '456 Elm St',
          DataKeys.localityKey: 'Los Angeles',
          DataKeys.administrativeAreaKey: 'CA',
          DataKeys.postalCodeKey: '90001',
          DataKeys.countryCodeKey: 'US',
          'address2': 'should be ignored',
          'sortingCode': 'should be ignored',
          'extraField': 'should be ignored',
        };

        final address = AddressExtensions.fromMap(map);

        expect(address.address1, '456 Elm St');
        expect(address.address2, '');
        expect(address.address3, '');
        expect(address.locality, 'Los Angeles');
        expect(address.administrativeArea, 'CA');
        expect(address.postalCode, '90001');
        expect(address.countryCode, 'US');
        expect(address.sortingCode, '');
      });

      test('should error when required fields are missing', () {
        final map = {
          DataKeys.address1Key: '789 Oak St',
          // Missing locality
          DataKeys.administrativeAreaKey: 'TX',
          DataKeys.postalCodeKey: '73301',
          DataKeys.countryCodeKey: 'US',
        };

        expect(
          () => AddressExtensions.fromMap(map),
          throwsA(isA<Error>()),
        );
      });
    });
  });
}
