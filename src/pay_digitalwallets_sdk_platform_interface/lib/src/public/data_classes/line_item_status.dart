// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk_platform_interface/src/private/data/data_keys.dart';

/// Enum representing the status of a line item
enum LineItemStatus {
  /// Indicates that the price is final and has no variance
  finalStatus(stringValue: DataKeys.finalStatus),

  /// Indicates that the price is pending and may change
  ///
  /// On iOS this will cause the amount to appear as an ellipsis ("...")
  pendingStatus(stringValue: DataKeys.pendingStatus);

  /// Create a Line Item Status
  const LineItemStatus({required this.stringValue});

  /// The string value of the enum
  final String stringValue;

  /// @nodoc
  @override
  String toString() {
    return stringValue;
  }
}
