// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk_platform_interface/src/private/data/data_keys.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/apple_pay_configuration.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/card_type.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/google_pay_configuration.dart';

/// Configuration parameters for digital wallets.
class Configuration {
  /// The company display name
  ///
  /// This will usually show up in the Apple Pay / Google Pay sheet next to
  /// the total
  ///
  /// **Important:** For Google Pay, this name must match the name set in the
  /// Google Pay Business Console when setting up production access
  final String companyLabel;

  /// The currency used to process transactions
  ///
  /// Must be a valid 3-character ISO 4217 currency code (e.g., "USD", "EUR", "GBP")
  ///
  /// Default value is "USD"
  final String currencyCode;

  /// A two character country code for the vendor that will be processing
  /// transactions
  ///
  /// Default value is "US"
  final String countryCode;

  /// Whether the Digital Wallet collects and returns a full billing address when
  /// processing transactions
  ///
  /// If `false`, only postal code and country code will be provided
  ///
  /// Default value is `false`
  final bool fullBillingAddressRequired;

  /// Whether the Digital Wallet collects and returns an email address when processing
  /// payments
  ///
  /// Default value is `false`
  final bool emailRequired;

  /// Whether the Digital Wallet collects and returns a phone number when processing
  /// transactions
  ///
  /// Default value is `false`
  final bool phoneNumberRequired;

  /// Whether the Digital Wallet collects and returns a name when processing transactions
  ///
  /// Default value is `false`
  final bool fullNameRequired;

  /// The list of card networks that are allowed for Digital Wallet transactions
  ///
  /// Default value is `[CardType.visa, CardType.masterCard, CardType.americanExpress, CardType.discover]`
  final List<CardType> allowedCardNetworks;

  /// Configuration parameters specific to Google Pay
  ///
  /// Required in order to use Google Pay
  final GooglePayConfiguration? googlePayConfig;

  /// Configuration parameters specific to Apple Pay
  ///
  /// Required in order to use Apple Pay
  final ApplePayConfiguration? applePayConfig;

  /// Create a new instance of this class to configure Digital Wallets
  ///
  /// Optional parameters will result in the following default values being used if not specified:
  /// - [countryCode] : "US"
  /// - [currencyCode] : "USD"
  /// - [emailRequired] : `false`
  /// - [phoneNumberRequired] : `false`
  /// - [fullNameRequired] : `false`
  /// - [fullBillingAddressRequired] : `false`
  const Configuration({
    required this.companyLabel,
    this.countryCode = "US",
    this.currencyCode = "USD",
    this.emailRequired = false,
    this.phoneNumberRequired = false,
    this.fullNameRequired = false,
    this.fullBillingAddressRequired = false,
    this.allowedCardNetworks = const [
      CardType.visa,
      CardType.masterCard,
      CardType.americanExpress,
      CardType.discover,
    ],
    this.applePayConfig,
    this.googlePayConfig,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    Map<String, dynamic> dataMap = {
      DataKeys.companyLabelKey: companyLabel,
      DataKeys.digitalWalletCountryCodeParameterKey: countryCode,
      DataKeys.currencyCodeKey: currencyCode,
      DataKeys.emailRequiredKey: emailRequired,
      DataKeys.phoneNumberRequiredKey: phoneNumberRequired,
      DataKeys.fullNameRequiredKey: fullNameRequired,
      DataKeys.fullBillingAddressRequiredKey: fullBillingAddressRequired,
      DataKeys.allowedCardNetworksKey: allowedCardNetworks
          .map((cardType) => cardType.name
              .toLowerCase()) // CardType names are converted to lowercase for cross-platform consistency when passing data across the platform channel.
          .toList(),
    };

    if (applePayConfig != null) {
      dataMap.addAll(applePayConfig!.toMap());
    }

    if (googlePayConfig != null) {
      dataMap.addAll(googlePayConfig!.toMap());
    }

    return dataMap;
  }
}
