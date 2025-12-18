```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_digitalwallets_sdk/pay_digitalwallets_sdk.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Step 1: Create the SDK instance
  final PayDigitalWalletsSdk _digitalWalletsSdk = PayDigitalWalletsSdk();

  bool _isConfigured = false;
  bool _digitalWalletsReady = false;
  String _status = '';
  double _amount = 9.99;

  @override
  void initState() {
    super.initState();
    _configureDigitalWallets();
  }

  void _onDigitalWalletReadyHandler(bool isReady) {
    setState(() {
      _digitalWalletsReady = isReady;
    });
  }

  // Step 2: Configure the Digital Wallets SDK
  Future<void> _configureDigitalWallets() async {
    try {
      _digitalWalletsSdk.onDigitalWalletReady = _onDigitalWalletReadyHandler;

      await _digitalWalletsSdk.configure(
        configuration: Configuration(
          companyLabel: "Company Name",
          countryCode: "US",
          currencyCode: "USD",
          applePayConfig: ApplePayConfiguration(
            merchantId: "merchant.com.company.merchant.id",
          ),
          googlePayConfig: GooglePayConfiguration(
            gatewayParametersJson: '''{
              "gateway": "freedompay",
              "gatewayMerchantId": "your-gateway-merchant-id"
            }''',
            productionEnvironment: false,
          ),
        ),
      );

      setState(() {
        _isConfigured = true;
      });
    } on PlatformException catch (e) {
      setState(() {
        _status = 'Configuration failed: ${e.message}';
      });
    }
  }

  // Step 3: Get payment data from the digital wallet
  Future<void> _getPaymentData() async {
    setState(() {
      _status = 'Processing...';
    });

    PaymentParameters paymentParams = PaymentParameters(
      amount: _amount,
    );

    try {
      PaymentData? paymentData =
          await _digitalWalletsSdk.getPaymentData(paymentParams);

      if (paymentData == null) {
        setState(() {
          _status = 'User Canceled';
        });
      } else {
        // Once payment data is generated, it can be used to submit an order to the backend server (Olo customers would use the Olo Ordering API)
        setState(() {
          _status = 'Payment Data Received:\n${paymentData.toString()}';
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _status = 'Error: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Wallets SDK Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isConfigured ? 'Digital Wallets Configured ✓' : 'Configuring...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              _digitalWalletsReady ? 'Digital Wallets Ready ✓' : 'Waiting...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),

            // Amount Display
            Text(
              'Amount: \$${_amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),

            // Step 4: Add the Digital Wallet Button
            Center(
              child: DigitalWalletButton(
                onClicked: _digitalWalletsReady ? _getPaymentData : null,
                constraints: const BoxConstraints(maxWidth: 200, maxHeight: 45),
                applePay: ApplePayButtonConfiguration.only(
                  style: ApplePayButtonStyle.black,
                  type: ApplePayButtonType.plain,
                  cornerRadius: 8.0,
                ),
                googlePay: GooglePayButtonConfiguration.only(
                  type: GooglePayButtonType.plain,
                  theme: GooglePayButtonTheme.dark,
                  cornerRadius: 8.0,
                ),
              ),
            ),

            // Output Display
            if (_status.isNotEmpty) ...[
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Output',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _status = '';
                              });
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _status,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```
