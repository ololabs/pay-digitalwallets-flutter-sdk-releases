// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'dart:io';
import 'package:flutter/material.dart';

/// A modal dialog for displaying and modifying app settings.
class SettingsModal extends StatefulWidget {
  final bool usePayNowButton;
  final bool useLineItems;
  final ValueChanged<bool> onUsePayNowButtonChanged;
  final ValueChanged<bool> onUseLineItemsChanged;

  const SettingsModal({
    super.key,
    required this.usePayNowButton,
    required this.useLineItems,
    required this.onUsePayNowButtonChanged,
    required this.onUseLineItemsChanged,
  });

  @override
  State<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
  late bool _usePayNowButton;
  late bool _useLineItems;

  @override
  void initState() {
    super.initState();
    _usePayNowButton = widget.usePayNowButton;
    _useLineItems = widget.useLineItems;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Platform.isAndroid)
              SwitchListTile(
                title: const Text('Use "Pay Now" Button'),
                subtitle:
                    const Text('Final Immediate Purchase vs Final Default'),
                contentPadding: EdgeInsets.zero,
                value: _usePayNowButton,
                onChanged: (value) {
                  setState(() {
                    _usePayNowButton = value;
                  });
                  widget.onUsePayNowButtonChanged(value);
                },
              ),
            SwitchListTile(
              title: const Text('Use Line Items'),
              subtitle: const Text('Show subtotal, tax, and tip breakdown'),
              contentPadding: EdgeInsets.zero,
              value: _useLineItems,
              onChanged: (value) {
                setState(() {
                  _useLineItems = value;
                });
                widget.onUseLineItemsChanged(value);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
