// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
class DataKeys {
  // Prefix Keys
  static const bridgePrefix = "com.olo.flutter.payDigitalWalletsSdk";
  static const digitalWalletMethodChannelKey = '$bridgePrefix/sdk';

  // Event Handler Keys
  static const digitalWalletReadyEventHandlerKey = "digitalWalletReadyEvent";

  // Native Method Keys
  static const configureMethodKey = "configure";
  static const getPaymentDataMethodKey = "getPaymentData";

  // Native Method Parameter Keys
  static const digitalWalletReadyParameterKey = "isReady";

  // PaymentParameters keys
  static const paymentAmountKey = "amount";
  static const googlePayCheckoutStatusKey = "googlePayCheckoutStatus";
  static const totalPriceLabelKey = "totalPriceLabel";
  static const lineItemsKey = "lineItems";
  static const validateLineItemsKey = "validateLineItems";

  // GooglePayCheckoutStatus enum values
  static const estimatedDefault = "EstimatedDefault";
  static const finalDefault = "FinalDefault";
  static const finalImmediatePurchase = "FinalImmediatePurchase";

  // Card type enum values
  /// Supported by Olo
  static const visaFieldValue = "visa";
  static const amexFieldValue = "amex";
  static const discoverFieldValue = "discover";
  static const masterCardFieldValue = "mastercard";
  static const jcbFieldValue = "jcb";

  /// Unsupported by Olo
  static const interacFieldValue = "interac";
  static const unsupportedCardFieldValue = "unsupported";

  // PaymentData keys
  static const pdTokenKey = "token";
  static const pdLastFourKey = "lastFour";
  static const pdCardTypeKey = "cardType";
  static const pdOloCardDescriptionKey = "oloCardDescription";
  static const pdCardDetailsKey = "cardDetails";
  static const pdEmailKey = "email";
  static const pdPhoneNumberKey = "phoneNumber";
  static const pdFullNameKey = "fullName";
  static const pdBillingAddressKey = "billingAddress";

  // Address keys
  static const address1Key = "address1";
  static const address2Key = "address2";
  static const address3Key = "address3";
  static const administrativeAreaKey = "administrativeArea";
  static const countryCodeKey = "countryCode";
  static const localityKey = "locality";
  static const postalCodeKey = "postalCode";
  static const sortingCodeKey = "sortingCode";

  // Error keys
  static const errorMessageKey = "errorMessage";
  static const errorCodeKey = "errorCode";
  static const digitalWalletTypeKey = "digitalWalletType";
}
