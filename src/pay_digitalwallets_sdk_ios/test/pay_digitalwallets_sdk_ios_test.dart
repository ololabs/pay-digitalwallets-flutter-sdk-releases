// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_digitalwallets_sdk_ios/pay_digitalwallets_sdk_ios.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_data_classes.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PayDigitalWalletsSdkIOS', () {
    late PayDigitalWalletsSdkIOS payDigitalWalletsSdk;
    late List<MethodCall> log;

    setUp(() async {
      payDigitalWalletsSdk = PayDigitalWalletsSdkIOS();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(payDigitalWalletsSdk.methodChannel,
              (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      PayDigitalWalletsSdkIOS.registerWith();
      expect(PayDigitalWalletsSdkPlatform.instance,
          isA<PayDigitalWalletsSdkIOS>());
    });

    group('getPaymentData():', () {
      test('returns PaymentData on success', () async {
        final paymentParams = PaymentParameters(amount: 10.0);

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(payDigitalWalletsSdk.methodChannel,
                (methodCall) async {
          log.add(methodCall);
          if (methodCall.method == 'getPaymentData') {
            return {
              'token': 'test_token',
              'lastFour': '4242',
              'cardType': 'visa',
              'oloCardDescription': 'Visa',
              'cardDetails': 'Visa •••• 4242',
              'email': 'test@example.com',
              'phoneNumber': '+1234567890',
              'fullName': 'Test User',
              'fullPhoneticName': 'Test User',
              'billingAddress': {
                'street': '123 Main St',
                'state': 'CA',
                'countryCode': 'US',
                'city': 'San Francisco',
                'postalCode': '94102',
              }
            };
          }
          return null;
        });

        final result = await payDigitalWalletsSdk.getPaymentData(paymentParams);

        expect(result, isNotNull);
        expect(result!.token, 'test_token');
        expect(result.lastFour, '4242');
        expect(result.cardType, CardType.visa);
      });

      test('throws PlatformException on error', () async {
        final paymentParams = PaymentParameters(amount: 10.0);

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(payDigitalWalletsSdk.methodChannel,
                (methodCall) async {
          log.add(methodCall);
          if (methodCall.method == 'getPaymentData') {
            return {
              'errorMessage': 'Apple Pay is not supported',
              'errorCode': 'ApplePayUnsupported',
              'digitalWalletType': 'applePay',
            };
          }
          return null;
        });

        expect(
          () => payDigitalWalletsSdk.getPaymentData(paymentParams),
          throwsA(isA<PlatformException>().having(
            (e) => e.code,
            'code',
            'ApplePayUnsupported',
          )),
        );
      });

      test('throws PlatformException when native throws error', () async {
        final paymentParams = PaymentParameters(amount: 10.0);

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(payDigitalWalletsSdk.methodChannel,
                (methodCall) async {
          log.add(methodCall);
          if (methodCall.method == 'getPaymentData') {
            throw PlatformException(
              code: 'InvalidParameter',
              message: 'Amount cannot be negative',
            );
          }
          return null;
        });

        expect(
          () => payDigitalWalletsSdk.getPaymentData(paymentParams),
          throwsA(isA<PlatformException>().having(
            (e) => e.code,
            'code',
            'InvalidParameter',
          )),
        );
      });

      test('calls method channel with correct method name', () async {
        final paymentParams = PaymentParameters(amount: 10.0);

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(payDigitalWalletsSdk.methodChannel,
                (methodCall) async {
          log.add(methodCall);
          return null;
        });

        await payDigitalWalletsSdk.getPaymentData(paymentParams);

        expect(log.length, 1);
        expect(log[0].method, 'getPaymentData');
      });

      test('passes payment parameters to method channel', () async {
        final paymentParams = PaymentParameters(
          amount: 25.50,
          lineItems: [
            LineItem.subtotal(label: 'Subtotal', amount: 20.0),
            LineItem.tax(label: 'Tax', amount: 5.50),
          ],
        );

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(payDigitalWalletsSdk.methodChannel,
                (methodCall) async {
          log.add(methodCall);
          return null;
        });

        await payDigitalWalletsSdk.getPaymentData(paymentParams);

        expect(log.length, 1);
        expect(log[0].arguments, isA<Map>());
        final args = log[0].arguments as Map;
        expect(args['amount'], '25.5');
        expect(args['lineItems'], isA<List>());
      });
    });
  });
}
