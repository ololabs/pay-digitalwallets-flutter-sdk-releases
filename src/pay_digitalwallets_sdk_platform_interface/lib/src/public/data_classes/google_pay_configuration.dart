// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk_platform_interface/src/private/data/data_keys.dart';

/// Configuration parameters for Google Pay transactions
class GooglePayConfiguration {
  /// Parameters for the gateway, as a JSON-formatted string
  ///
  /// _Example JSON Object:_
  /// ```json
  /// {
  ///   "gateway": "exampleGateway",
  ///   "gatewayMerchantId": "exampleGatewayMerchantId"
  /// }
  /// ```
  /// For more details, see Google's [Gateway](https://developers.google.com/pay/api/android/reference/request-objects#gateway) documentation
  /// <br><br>
  ///
  /// **Important:**
  /// An error will be thrown if this is not a valid JSON string
  ///
  final String gatewayParametersJson;

  /// Whether Google Pay will use the production environment
  ///
  /// Set to `true` to use the Google Pay production environment, `false` for
  /// the test environment. Before setting this to `true` Google will need to
  /// whitelist the app for production access.
  ///
  /// Default value is `true`
  final bool productionEnvironment;

  /// Whether an existing saved payment method is required for Google Pay
  /// to be considered ready.
  ///
  /// Since cards can be added within the Google Pay sheet, it is recommended
  /// to set this to `false`
  ///
  /// Default value is `false`
  final bool existingPaymentMethodRequired;

  /// Multiplier to convert the amount to the currency's smallest unit
  ///
  /// Google Pay requires the amount to be specified in terms of the currency's smallest unit (e.g. pennies for USD).
  /// The SDK does that calculation for you. In most cases the currency multiplier is going to be 100, and
  /// is the default value if this property is not specified in the constructor.
  ///
  /// Example: $2.34 * 100 = 234 cents.
  ///
  /// Default value is `100`
  final int currencyMultiplier;

  /// Create a new instance of this class to configure Google Pay
  ///
  /// Optional parameters will result in the following default values being used if not specified:
  /// - [productionEnvironment] : `true`
  /// - [existingPaymentMethodRequired] : `false`
  /// - [currencyMultiplier] : `100`
  const GooglePayConfiguration({
    required this.gatewayParametersJson,
    this.productionEnvironment = true,
    this.existingPaymentMethodRequired = false,
    this.currencyMultiplier = 100,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.googlePayGatewayParametersJsonParameterKey:
          gatewayParametersJson,
      DataKeys.googlePayProductionEnvironmentParameterKey:
          productionEnvironment,
      DataKeys.googlePayExistingPaymentMethodRequiredParameterKey:
          existingPaymentMethodRequired,
      DataKeys.googlePayCurrencyMultiplierParameterKey: currencyMultiplier,
    };
  }
}
