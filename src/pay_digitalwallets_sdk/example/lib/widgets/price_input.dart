// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceInput extends StatefulWidget {
  final String price;
  final ValueChanged<String> onValueChanged;
  final VoidCallback onIncrementClicked;
  final VoidCallback onDecrementClicked;
  final String currencySymbol;

  const PriceInput({
    super.key,
    required this.price,
    required this.onValueChanged,
    required this.onIncrementClicked,
    required this.onDecrementClicked,
    this.currencySymbol = '\$',
  });

  @override
  State<PriceInput> createState() => _PriceInputState();
}

class _PriceInputState extends State<PriceInput> {
  late TextEditingController _controller;
  late _CurrencyInputFormatter _formatter;

  @override
  void initState() {
    super.initState();
    _formatter = _CurrencyInputFormatter(currencySymbol: widget.currencySymbol);
    _controller =
        TextEditingController(text: _formatter.formatPrice(widget.price));
  }

  @override
  void didUpdateWidget(PriceInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update formatter if currency symbol changed
    if (oldWidget.currencySymbol != widget.currencySymbol) {
      _formatter =
          _CurrencyInputFormatter(currencySymbol: widget.currencySymbol);
      // Reformat the current text with the new currency symbol
      final formatted = _formatter.formatPrice(widget.price);
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    // Update controller text if price changed externally (e.g., from increment/decrement buttons)
    if (oldWidget.price != widget.price) {
      final formatted = _formatter.formatPrice(widget.price);
      if (_controller.text != formatted) {
        _controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 20,
              ),
              labelText: 'Total Price',
              labelStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              border: const OutlineInputBorder(),
              suffixIcon: widget.price.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => widget.onValueChanged(''),
                    )
                  : null,
            ),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(7), // Max 7 digits
              _formatter,
            ],
            onChanged: (value) {
              // Remove all non-digit characters before passing to parent
              final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
              widget.onValueChanged(digitsOnly);
            },
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 36,
              child: OutlinedButton(
                onPressed: widget.onIncrementClicked,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Icon(Icons.keyboard_arrow_up),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 36,
              child: OutlinedButton(
                onPressed: widget.onDecrementClicked,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Icon(Icons.keyboard_arrow_down),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A custom TextInputFormatter that formats numbers as currency.
///
/// This formatter takes a string of digits and formats it with:
/// - Currency symbol prefix (e.g., "$ ")
/// - Thousands separators (commas)
/// - Decimal point with exactly 2 decimal places
/// - Last 2 digits are always treated as cents
///
/// Example: "1123" → "$ 11.23"
/// Example: "123456" → "$ 1,234.56"
class _CurrencyInputFormatter extends TextInputFormatter {
  final String currencySymbol;

  _CurrencyInputFormatter({this.currencySymbol = '\$'});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Get only digits from the new value
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Format the text with currency symbol and separators
    final formatted = formatPrice(text);

    // Calculate cursor position at the end
    final cursorPosition = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  String formatPrice(String digits) {
    if (digits.isEmpty) return '';

    // Split into integer and fractional parts
    // Last 2 digits are always cents
    final integerPart =
        digits.length > 2 ? digits.substring(0, digits.length - 2) : '0';

    var fractionPart = digits.length >= 2
        ? digits.substring(digits.length - 2)
        : digits.padLeft(2, '0');

    // Add thousands separators to integer part
    final formattedInteger = _addThousandsSeparators(integerPart);

    // Return formatted price with currency symbol
    return '$currencySymbol $formattedInteger.$fractionPart';
  }

  String _addThousandsSeparators(String number) {
    // Add comma every 3 digits from the right
    final reversed = number.split('').reversed.toList();
    final withSeparators = <String>[];

    for (var i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        withSeparators.add(',');
      }
      withSeparators.add(reversed[i]);
    }

    return withSeparators.reversed.join('');
  }
}
