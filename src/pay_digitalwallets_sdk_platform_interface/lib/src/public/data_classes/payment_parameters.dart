// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk_platform_interface/src/private/data/data_keys.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/google_pay_checkout_status.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/line_item.dart';

/// Parameters used to get payment data from a digital wallet
class PaymentParameters {
  /// The amount to be charged
  final double amount;

  /// The status for the transaction _**(Android Only)**_
  ///
  /// For [GooglePayCheckoutStatus.finalImmediatePurchase], the pay button
  /// text in the Google Pay sheet will be "Pay Now". For other statuses it will say "Continue"
  final GooglePayCheckoutStatus googlePayCheckoutStatus;

  /// A custom value to override the default total price label in the Google Pay sheet _**(Android Only)**_
  final String? totalPriceLabel;

  /// A list of line items to be displayed in the digital wallet payment sheet
  final List<LineItem>? lineItems;

  /// Whether or not to validate the line items. If `true`, [PayDigitalWalletsSdk.getPaymentData](https://pub.dev/documentation/pay_digitalwallets_sdk/latest/pay_digitalwallets_sdk/PayDigitalWalletsSdk/getPaymentData.html)
  /// will throw an exception if the sum of the line items does not equal the total amount passed in.
  /// If no line items are provided, this parameter is ignored.
  ///
  /// Default value is `true`.
  final bool validateLineItems;

  /// Create payment parameters
  PaymentParameters({
    required this.amount,
    this.googlePayCheckoutStatus =
        GooglePayCheckoutStatus.finalImmediatePurchase,
    this.totalPriceLabel,
    this.lineItems,
    this.validateLineItems = true,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.paymentAmountKey: amount.toString(),
      DataKeys.googlePayCheckoutStatusKey: googlePayCheckoutStatus.stringValue,
      DataKeys.totalPriceLabelKey: totalPriceLabel,
      DataKeys.lineItemsKey: lineItems?.map((item) => item.toMap()).toList(),
      DataKeys.validateLineItemsKey: validateLineItems,
    };
  }
}
