// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pay_digitalwallets_sdk/pay_digitalwallets_sdk.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPayDigitalWalletsSdkPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PayDigitalWalletsSdkPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PayDigitalWalletsSdk', () {
    late PayDigitalWalletsSdkPlatform payDigitalWalletsSdkPlatform;

    setUp(() {
      payDigitalWalletsSdkPlatform = MockPayDigitalWalletsSdkPlatform();
      PayDigitalWalletsSdkPlatform.instance = payDigitalWalletsSdkPlatform;
    });

    group('configure():', () {
      test('calls platform configure with Configuration', () async {
        final configuration = const Configuration(companyLabel: 'Test Company');

        when(() => payDigitalWalletsSdkPlatform.configure(
              configuration: configuration,
            )).thenAnswer((_) async {});

        await PayDigitalWalletsSdk().configure(configuration: configuration);

        verify(() => payDigitalWalletsSdkPlatform.configure(
              configuration: configuration,
            )).called(1);
      });
    });

    group('getPaymentData():', () {
      test('calls platform getPaymentData', () async {
        final paymentParams = PaymentParameters(amount: 10.0);
        final paymentData = PaymentData(
          token: 'test_token',
          lastFour: '4242',
          cardType: CardType.visa,
          oloCardDescription: 'Visa',
          cardDetails: 'Visa •••• 4242',
          email: 'test@example.com',
          phoneNumber: '+1234567890',
          fullName: 'Test User',
          fullPhoneticName: 'Test User',
          billingAddress: Address(
            address1: '123 Main St',
            address2: '',
            address3: '',
            locality: 'San Francisco',
            administrativeArea: 'CA',
            postalCode: '94102',
            countryCode: 'US',
            sortingCode: '',
          ),
        );

        when(() => payDigitalWalletsSdkPlatform.getPaymentData(paymentParams))
            .thenAnswer((_) async => paymentData);

        await PayDigitalWalletsSdk().getPaymentData(paymentParams);

        verify(() => payDigitalWalletsSdkPlatform.getPaymentData(paymentParams))
            .called(1);
      });

      test('propagates PlatformException from platform', () async {
        final paymentParams = PaymentParameters(amount: 10.0);

        when(() => payDigitalWalletsSdkPlatform.getPaymentData(paymentParams))
            .thenThrow(PlatformException(
          code: 'ApplePayUnsupported',
          message: 'Apple Pay is not supported',
        ));

        expect(
          () => PayDigitalWalletsSdk().getPaymentData(paymentParams),
          throwsA(isA<PlatformException>().having(
            (e) => e.code,
            'code',
            'ApplePayUnsupported',
          )),
        );
      });
    });
  });
}
