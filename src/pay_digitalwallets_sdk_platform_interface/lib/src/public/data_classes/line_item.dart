// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk_platform_interface/src/private/data/data_keys.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/line_item_status.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/line_item_type.dart';

/// Represents a line item in a transaction
class LineItem {
  /// The amount of the line item
  final double amount;

  /// The type of the line item
  final LineItemType type;

  /// The label of the line item
  final String label;

  /// The status of the line item
  ///
  /// Default value is [LineItemStatus.finalStatus]
  final LineItemStatus status;

  /// Create a digital wallet line item
  ///
  /// If not specified, optional parameter [status] defaults to [LineItemStatus.finalStatus]
  LineItem({
    required this.amount,
    required this.type,
    required this.label,
    this.status = LineItemStatus.finalStatus,
  });

  /// Convenience constructor for a line item of type [LineItemType.lineItem]
  ///
  /// If not specified, optional parameter [status] defaults to [LineItemStatus.finalStatus]
  factory LineItem.lineItem({
    required double amount,
    required String label,
    LineItemStatus status = LineItemStatus.finalStatus,
  }) {
    return LineItem(
      amount: amount,
      type: LineItemType.lineItem,
      label: label,
      status: status,
    );
  }

  /// Convenience constructor for a line item of type [LineItemType.subtotal]
  ///
  /// Optional parameters will result in the following default values being used if not specified:
  /// - [label] : "Subtotal"
  /// - [status] : [LineItemStatus.finalStatus]
  factory LineItem.subtotal({
    required double amount,
    String label = DataKeys.lineItemSubtotalLabelKey,
    LineItemStatus status = LineItemStatus.finalStatus,
  }) {
    return LineItem(
      amount: amount,
      type: LineItemType.subtotal,
      label: label,
      status: status,
    );
  }

  /// Convenience constructor for a line item of type [LineItemType.tax]
  ///
  /// Optional parameters will result in the following default values being used if not specified:
  /// - [label] : "Tax"
  /// - [status] : [LineItemStatus.finalStatus]
  factory LineItem.tax({
    required double amount,
    String label = DataKeys.lineItemTaxLabelKey,
    LineItemStatus status = LineItemStatus.finalStatus,
  }) {
    return LineItem(
      amount: amount,
      type: LineItemType.tax,
      label: label,
      status: status,
    );
  }

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.lineItemAmountKey: amount.toString(),
      DataKeys.lineItemTypeKey: type.stringValue,
      DataKeys.lineItemLabelKey: label,
      DataKeys.lineItemStatusKey: status.stringValue,
    };
  }
}
