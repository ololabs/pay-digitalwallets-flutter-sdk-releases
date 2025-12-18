// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk_platform_interface/src/private/data/data_keys.dart';

/// Enum representing the type of a line item in a digital wallet transaction
enum LineItemType {
  /// Represents a line item in a digital wallet transaction
  lineItem(stringValue: DataKeys.googlePayLineItemTypeKey),

  /// Represents a subtotal line item in a digital wallet transaction
  subtotal(stringValue: DataKeys.googlePaySubtotalTypeKey),

  /// Represents a tax line item in a digital wallet transaction
  tax(stringValue: DataKeys.googlePayTaxTypeKey);

  /// @nodoc
  const LineItemType({required this.stringValue});

  /// The string value of the enum
  final String stringValue;

  /// @nodoc
  @override
  String toString() {
    return stringValue;
  }
}
