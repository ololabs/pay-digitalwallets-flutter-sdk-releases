// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk_platform_interface/src/private/data/data_keys.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/address.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/card_type.dart';

/// Payment data for the digital wallet card (from Apple Pay or Google Pay) selected by the user when presenting the payment sheet
class PaymentData {
  /// Encrypted token string from the digital wallet that represents the selected payment method
  final String token;

  /// The last four digits of the payment account number, if they are returned, otherwise an empty string
  final String lastFour;

  /// The issuer of the card
  ///
  /// **Important:** When submitting this data to Olo's Ordering API, it is important to use [CardType.oloDescription] or [oloCardDescription].
  /// Additionally, if the [CardType.isSupportedByOlo] is false, attempting to submit an order to Olo's Ordering API will result in an error.
  final CardType cardType;

  /// The description of the card type used for this transaction as required by Olo's
  /// ordering ecosystem
  ///
  /// **Important:** If this has a value of "Unsupported" then attempting to process the payment within
  /// Olo's ordering ecosystem will fail
  final String oloCardDescription;

  /// The details about the card, if returned by the digital wallet, an empty string otherwise
  ///
  /// This is commonly the last four digits of the payment account number
  final String cardDetails;

  /// The email address associated with the transaction, or an empty string if unavailable
  final String email;

  /// The phone number associated with the transaction, or an empty string if unavailable
  final String phoneNumber;

  /// The full name associated with the transaction, or an empty string if unavailable
  final String fullName;

  /// The full phonetic name associated with the transaction, or an empty string if unavailable _**(iOS Only)**_
  final String fullPhoneticName;

  /// The billing address associated with the transaction. The country code and postal code fields will always be set
  final Address billingAddress;

  /// Create an instance of a payment data object
  ///
  /// **Important:** Other than for testing purposes, there should generally be no reason to create an instance of this class.
  const PaymentData({
    required this.token,
    required this.lastFour,
    required this.cardType,
    required this.oloCardDescription,
    required this.cardDetails,
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.fullPhoneticName,
    required this.billingAddress,
  });

  /// @nodoc
  factory PaymentData.fromMap(Map<dynamic, dynamic> map) {
    return PaymentData(
      token: map[DataKeys.pdTokenKey] ?? "",
      lastFour: map[DataKeys.pdLastFourKey] ?? "",
      cardType: CardType.fromStringValue(map[DataKeys.pdCardTypeKey]),
      oloCardDescription: map[DataKeys.pdOloCardDescriptionKey] ?? "",
      cardDetails: map[DataKeys.pdCardDetailsKey] ?? "",
      email: map[DataKeys.pdEmailKey] ?? "",
      phoneNumber: map[DataKeys.pdPhoneNumberKey] ?? "",
      fullName: map[DataKeys.pdFullNameKey] ?? "",
      fullPhoneticName: map[DataKeys.pdFullPhoneticNameKey] ?? "",
      billingAddress: Address.fromMap(map[DataKeys.pdBillingAddressKey]),
    );
  }

  /// @nodoc
  @override
  String toString() {
    return '''
      token: $token
      lastFour: $lastFour
      cardType: $cardType
      oloCardDescription: $oloCardDescription
      cardDetails: $cardDetails
      email: $email
      phoneNumber: $phoneNumber
      fullName: $fullName
      fullPhoneticName: $fullPhoneticName
      billingAddress:
$billingAddress
    ''';
  }
}
