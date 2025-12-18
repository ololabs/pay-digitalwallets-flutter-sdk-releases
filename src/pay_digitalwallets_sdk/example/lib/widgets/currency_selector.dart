// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter/material.dart';

class CurrencySelector extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String> onChanged;
  final List<String> currencies = const ['USD', 'CAD'];

  const CurrencySelector({
    super.key,
    required this.selectedCurrency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: DropdownButtonFormField<String>(
        value: selectedCurrency,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        items: currencies.map((String currency) {
          return DropdownMenuItem<String>(
            value: currency,
            child: Text(currency),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        icon: const Icon(Icons.keyboard_arrow_down),
      ),
    );
  }
}
