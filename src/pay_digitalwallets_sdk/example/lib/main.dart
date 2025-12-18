// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_digitalwallets_sdk/pay_digitalwallets_sdk.dart';
import 'widgets/price_input.dart';
import 'widgets/currency_selector.dart';
import 'widgets/settings_modal.dart';

void main() => runApp(const DigitalWalletsTestHarness());

class DigitalWalletsTestHarness extends StatelessWidget {
  const DigitalWalletsTestHarness({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PayDigitalWalletsSdk _digitalWalletsSdk = PayDigitalWalletsSdk();
  bool _isConfigured = false;
  bool _digitalWalletsReady = false;
  bool _isReconfiguring = false;
  bool _usePayNowButton = true;
  bool _useLineItems = false;
  String _status = '';

  double _amount = 9.99;
  String _selectedCurrency = 'USD';

  double get _tip => double.parse((_amount * 0.15).toStringAsFixed(2));
  double get _tax => double.parse((_amount * 0.10).toStringAsFixed(2));
  double get _discount => double.parse((_amount * -0.05).toStringAsFixed(2));
  double get _subtotal =>
      double.parse((_amount - _tip - _tax - _discount).toStringAsFixed(2));
  double get _total => _amount;

  String get _priceInputString {
    final cents = (_amount * 100).round();
    return cents.toString();
  }

  String get _currencySymbol => _selectedCurrency == 'USD' ? '\$' : 'C\$';

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

  Future<void> _configureDigitalWallets() async {
    try {
      _digitalWalletsSdk.onDigitalWalletReady = _onDigitalWalletReadyHandler;
      await _digitalWalletsSdk.configure(
          configuration: Configuration(
        companyLabel: "Olo",
        countryCode: _selectedCurrency == 'USD' ? 'US' : 'CA',
        currencyCode: _selectedCurrency,
        emailRequired: true,
        phoneNumberRequired: true,
        fullNameRequired: true,
        fullBillingAddressRequired: true,
        allowedCardNetworks: [
          CardType.visa,
          CardType.masterCard,
          CardType.americanExpress,
          CardType.discover,
        ],
        applePayConfig: ApplePayConfiguration(
          merchantId: "merchant.com.olopaysdktestharness2",
          fullPhoneticNameRequired: true,
        ),
        googlePayConfig: GooglePayConfiguration(
          gatewayParametersJson: '''{
              "gateway": "freedompay",
              "gatewayMerchantId": "Z7Zw2ixhuspV4pxFkO8Zou+NoRo="
              }''',
          productionEnvironment: false,
          existingPaymentMethodRequired: false,
        ),
      ));
      if (mounted) {
        setState(() => _isConfigured = true);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Configuration failed: $error'),
            duration: const Duration(seconds: 30),
          ),
        );
      }
    }
  }

  void _onPriceChanged(String value) {
    setState(() {
      // Convert from string format (e.g., "1123") to double (e.g., 11.23)
      final cents = int.tryParse(value) ?? 0;
      _amount = cents / 100.0;
    });
  }

  void _onIncrementPrice() {
    setState(() {
      _amount += 1.00;
    });
  }

  void _onDecrementPrice() {
    var newAmount = _amount - 1.00;
    if (newAmount < 0.0) {
      newAmount = 0.00;
    }
    setState(() {
      _amount = newAmount;
    });
  }

  Future<void> _onCurrencyChanged(String currency) async {
    setState(() {
      _selectedCurrency = currency;
      _isReconfiguring = true;
    });
    // Reconfigure with new currency
    await _configureDigitalWallets();
    if (mounted) {
      setState(() {
        _isReconfiguring = false;
      });
    }
  }

  Future<void> _getPaymentData() async {
    setState(() {
      _status = 'Processing...';
    });

    PaymentParameters paymentParams = PaymentParameters(
      amount: _amount,
      googlePayCheckoutStatus: _usePayNowButton
          ? GooglePayCheckoutStatus.finalImmediatePurchase
          : GooglePayCheckoutStatus.finalDefault,
      totalPriceLabel: _useLineItems ? "Grand Total" : null,
      lineItems: _useLineItems
          ? [
              LineItem.subtotal(amount: _subtotal),
              LineItem.lineItem(amount: _tip, label: "Tip"),
              LineItem.tax(amount: _tax),
              LineItem.lineItem(amount: _discount, label: "Discount"),
            ]
          : null,
    );

    try {
      PaymentData? paymentData =
          await _digitalWalletsSdk.getPaymentData(paymentParams);

      if (paymentData == null) {
        setState(() {
          _status = 'User Canceled';
        });
      } else {
        setState(() {
          _status = 'Payment Data Received:\n${paymentData.toString()}';
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _status = 'Error: ${e.code}\n\nMessage: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _status = 'Unexpected error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Wallets SDK Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SettingsModal(
                  usePayNowButton: _usePayNowButton,
                  useLineItems: _useLineItems,
                  onUsePayNowButtonChanged: (value) {
                    setState(() {
                      _usePayNowButton = value;
                    });
                  },
                  onUseLineItemsChanged: (value) {
                    setState(() {
                      _useLineItems = value;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isConfigured ? 'Digital Wallets Configured ✓' : 'Configuring...',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16),
            Text(
              _digitalWalletsReady ? 'Digital Wallets Ready ✓' : 'Waiting...',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 32),

            // Price and Currency Input
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CurrencySelector(
                    selectedCurrency: _selectedCurrency,
                    onChanged: _onCurrencyChanged,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PriceInput(
                      price: _priceInputString,
                      onValueChanged: _onPriceChanged,
                      onIncrementClicked: _onIncrementPrice,
                      onDecrementClicked: _onDecrementPrice,
                      currencySymbol: _currencySymbol,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Line Items Display
            if (_useLineItems) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Line Items',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      _buildLineItem('Subtotal', _subtotal),
                      _buildLineItem('Tip', _tip),
                      _buildLineItem('Tax', _tax),
                      _buildLineItem('Discount', _discount),
                      const Divider(),
                      _buildLineItem('Total', _total, isBold: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],

            // Digital Wallet Button
            Center(
              child: DigitalWalletButton(
                onClicked: (_digitalWalletsReady && !_isReconfiguring)
                    ? _getPaymentData
                    : null,
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

            // Output Log
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

  Widget _buildLineItem(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '$_currencySymbol${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
