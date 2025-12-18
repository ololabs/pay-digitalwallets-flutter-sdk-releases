// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_digitalwallets_sdk_android/pay_digitalwallets_sdk_android.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_data_classes.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PayDigitalWalletsSdkAndroid', () {
    late PayDigitalWalletsSdkAndroid payDigitalWalletsSdk;
    late List<MethodCall> log;

    setUp(() async {
      payDigitalWalletsSdk = PayDigitalWalletsSdkAndroid();

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
      PayDigitalWalletsSdkAndroid.registerWith();
      expect(PayDigitalWalletsSdkPlatform.instance,
          isA<PayDigitalWalletsSdkAndroid>());
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
              'billingAddress': {
                'address1': '123 Main St',
                'address2': 'Apt 4',
                'address3': '',
                'administrativeArea': 'CA',
                'countryCode': 'US',
                'locality': 'San Francisco',
                'postalCode': '94102',
                'sortingCode': '',
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
              'errorMessage': 'Google Pay is not available',
              'errorCode': 'GooglePayUnavailable',
              'digitalWalletType': 'googlePay',
            };
          }
          return null;
        });

        expect(
          () => payDigitalWalletsSdk.getPaymentData(paymentParams),
          throwsA(isA<PlatformException>().having(
            (e) => e.code,
            'code',
            'GooglePayUnavailable',
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
