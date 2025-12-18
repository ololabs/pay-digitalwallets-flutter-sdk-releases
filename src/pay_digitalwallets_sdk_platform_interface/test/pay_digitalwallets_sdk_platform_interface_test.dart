// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_data_classes.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_platform_interface.dart';

class PayDigitalWalletsSdkMock extends PayDigitalWalletsSdkPlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<void> configure({required Configuration configuration}) async {}

  @override
  Future<PaymentData?> getPaymentData(PaymentParameters paymentParams) async {
    return null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('instance when not set', () {
    test('throws UnimplementedError', () {
      // This test runs before any setUp sets an instance
      // Note: This test must run first to properly test uninitialized state
      expect(
        () => PayDigitalWalletsSdkPlatform.instance,
        throwsA(
          isA<UnimplementedError>().having(
            (e) => e.message,
            'message',
            contains('has not been implemented for this platform'),
          ),
        ),
      );
    });
  });

  group('PayDigitalWalletsSdkPlatformInterface', () {
    late PayDigitalWalletsSdkPlatform payDigitalWalletsSdkPlatform;

    setUp(() {
      payDigitalWalletsSdkPlatform = PayDigitalWalletsSdkMock();
      PayDigitalWalletsSdkPlatform.instance = payDigitalWalletsSdkPlatform;
    });

    tearDown(() {
      // Reset instance to null for clean state
      PayDigitalWalletsSdkPlatform.instance = PayDigitalWalletsSdkMock();
    });

    group('instance:', () {
      test('can be set', () {
        final mockPlatform = PayDigitalWalletsSdkMock();
        PayDigitalWalletsSdkPlatform.instance = mockPlatform;
        expect(PayDigitalWalletsSdkPlatform.instance, mockPlatform);
      });
    });
  });

  group('configure', () {
    test('can be called', () async {
      final payDigitalWalletsSdkPlatform = PayDigitalWalletsSdkMock();
      await payDigitalWalletsSdkPlatform.configure(
        configuration: Configuration(
          companyLabel: "Test Company",
        ),
      );
    });
  });

  group('abstract methods', () {
    test('configure throws UnimplementedError on base class', () {
      final platform = _UnimplementedPlatform();
      expect(
        () => platform.configure(
            configuration: Configuration(companyLabel: 'Test')),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('getPaymentData throws UnimplementedError on base class', () {
      final platform = _UnimplementedPlatform();
      expect(
        () => platform.getPaymentData(PaymentParameters(amount: 10.0)),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}

class _UnimplementedPlatform extends PayDigitalWalletsSdkPlatform {
  // This class doesn't override the abstract methods,
  // so they will throw UnimplementedError
}
