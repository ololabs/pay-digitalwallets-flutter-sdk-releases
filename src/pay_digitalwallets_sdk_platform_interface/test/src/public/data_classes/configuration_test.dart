// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/apple_pay_configuration.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/card_type.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/configuration.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/google_pay_configuration.dart';

void main() {
  final allParamsMap = Configuration(
    companyLabel: 'Test Company',
    countryCode: 'CA',
    currencyCode: 'CAD',
    emailRequired: true,
    phoneNumberRequired: true,
    fullNameRequired: true,
    fullBillingAddressRequired: true,
    allowedCardNetworks: [CardType.visa, CardType.masterCard],
    applePayConfig: const ApplePayConfiguration(
      merchantId: 'merchant.com.test',
      fullPhoneticNameRequired: true,
    ),
    googlePayConfig: const GooglePayConfiguration(
      gatewayParametersJson: '{"gateway":"test","gatewayMerchantId":"123"}',
      productionEnvironment: false,
      existingPaymentMethodRequired: true,
    ),
  ).toMap();

  final requiredParamsOnlyMap = const Configuration(
    companyLabel: 'Required Only Company',
  ).toMap();

  final applePayConfigMap = const Configuration(
    companyLabel: 'Apple Pay Company',
    applePayConfig: ApplePayConfiguration(
      merchantId: 'merchant.com.apple',
    ),
  ).toMap();

  final googlePayConfigMap = const Configuration(
    companyLabel: 'Google Pay Company',
    googlePayConfig: GooglePayConfiguration(
      gatewayParametersJson: '{"gateway":"google","gatewayMerchantId":"456"}',
    ),
  ).toMap();

  group('Configuration', () {
    group('toMap():', () {
      group('All Params:', () {
        test('Has correct keys', () {
          expect(allParamsMap.containsKey('companyLabel'), true);
          expect(allParamsMap.containsKey('countryCode'), true);
          expect(allParamsMap.containsKey('currencyCode'), true);
          expect(allParamsMap.containsKey('emailRequired'), true);
          expect(allParamsMap.containsKey('phoneNumberRequired'), true);
          expect(allParamsMap.containsKey('fullNameRequired'), true);
          expect(allParamsMap.containsKey('fullBillingAddressRequired'), true);
          expect(allParamsMap.containsKey('allowedCardNetworks'), true);
          expect(allParamsMap.containsKey('merchantId'), true);
          expect(allParamsMap.containsKey('fullPhoneticNameRequired'), true);
          expect(allParamsMap.containsKey('googlePayGatewayParametersJson'),
              true);
          expect(allParamsMap.containsKey('googlePayProductionEnvironment'),
              true);
          expect(
              allParamsMap.containsKey('existingPaymentMethodRequired'), true);
        });

        test('Keys have correct values', () {
          expect(allParamsMap['companyLabel'], 'Test Company');
          expect(allParamsMap['countryCode'], 'CA');
          expect(allParamsMap['currencyCode'], 'CAD');
          expect(allParamsMap['emailRequired'], true);
          expect(allParamsMap['phoneNumberRequired'], true);
          expect(allParamsMap['fullNameRequired'], true);
          expect(allParamsMap['fullBillingAddressRequired'], true);
          expect(allParamsMap['allowedCardNetworks'], ['visa', 'mastercard']);
          expect(allParamsMap['merchantId'], 'merchant.com.test');
          expect(allParamsMap['fullPhoneticNameRequired'], true);
          expect(allParamsMap['googlePayGatewayParametersJson'],
              '{"gateway":"test","gatewayMerchantId":"123"}');
          expect(allParamsMap['googlePayProductionEnvironment'], false);
          expect(allParamsMap['existingPaymentMethodRequired'], true);
        });
      });

      group('Required Params Only:', () {
        test('Has correct keys', () {
          expect(requiredParamsOnlyMap.containsKey('companyLabel'), true);
          expect(requiredParamsOnlyMap.containsKey('countryCode'), true);
          expect(requiredParamsOnlyMap.containsKey('currencyCode'), true);
          expect(requiredParamsOnlyMap.containsKey('emailRequired'), true);
          expect(
              requiredParamsOnlyMap.containsKey('phoneNumberRequired'), true);
          expect(requiredParamsOnlyMap.containsKey('fullNameRequired'), true);
          expect(requiredParamsOnlyMap.containsKey('fullBillingAddressRequired'),
              true);
          expect(
              requiredParamsOnlyMap.containsKey('allowedCardNetworks'), true);
        });

        test('Keys have correct default values', () {
          expect(requiredParamsOnlyMap['companyLabel'], 'Required Only Company');
          expect(requiredParamsOnlyMap['countryCode'], 'US');
          expect(requiredParamsOnlyMap['currencyCode'], 'USD');
          expect(requiredParamsOnlyMap['emailRequired'], false);
          expect(requiredParamsOnlyMap['phoneNumberRequired'], false);
          expect(requiredParamsOnlyMap['fullNameRequired'], false);
          expect(requiredParamsOnlyMap['fullBillingAddressRequired'], false);
          expect(requiredParamsOnlyMap['allowedCardNetworks'],
              ['visa', 'mastercard', 'americanexpress', 'discover']);
        });
      });

      group('With Apple Pay Config:', () {
        test('Has correct keys including Apple Pay keys', () {
          expect(applePayConfigMap.containsKey('companyLabel'), true);
          expect(applePayConfigMap.containsKey('merchantId'), true);
          expect(
              applePayConfigMap.containsKey('fullPhoneticNameRequired'), true);
        });

        test('Keys have correct values', () {
          expect(applePayConfigMap['companyLabel'], 'Apple Pay Company');
          expect(applePayConfigMap['merchantId'], 'merchant.com.apple');
          expect(applePayConfigMap['fullPhoneticNameRequired'], false);
        });
      });

      group('With Google Pay Config:', () {
        test('Has correct keys including Google Pay keys', () {
          expect(googlePayConfigMap.containsKey('companyLabel'), true);
          expect(googlePayConfigMap.containsKey('googlePayGatewayParametersJson'),
              true);
          expect(
              googlePayConfigMap.containsKey('googlePayProductionEnvironment'),
              true);
          expect(
              googlePayConfigMap.containsKey('existingPaymentMethodRequired'),
              true);
        });

        test('Keys have correct values', () {
          expect(googlePayConfigMap['companyLabel'], 'Google Pay Company');
          expect(googlePayConfigMap['googlePayGatewayParametersJson'],
              '{"gateway":"google","gatewayMerchantId":"456"}');
          expect(googlePayConfigMap['googlePayProductionEnvironment'], true);
          expect(googlePayConfigMap['existingPaymentMethodRequired'], false);
        });
      });
    });
  });
}
