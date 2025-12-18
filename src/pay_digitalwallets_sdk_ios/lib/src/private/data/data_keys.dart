// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
class DataKeys {
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
  static const dinersClubFieldValue = "dinersclub";
  static const chinaUnionPayFieldValue = "chinaunionpay";

  /// Unsupported by Olo
  static const bancomatFieldValue = "bancomat";
  static const bancontactFieldValue = "bancontact";
  static const bankAxeptFieldValue = "bankaxept";
  static const barcodeFieldValue = "barcode";
  static const carteBancaireFieldValue = "cartebancaire";
  static const carteBancairesFieldValue = "cartebancaires";
  static const cartesBancairesFieldValue = "cartesbancaires";
  static const dankortFieldValue = "dankort";
  static const eftposFieldValue = "eftpos";
  static const electronFieldValue = "electron";
  static const eloFieldValue = "elo";
  static const girocardFieldValue = "girocard";
  static const himyanFieldValue = "himyan";
  static const idCreditFieldValue = "idcredit";
  static const interacFieldValue = "interac";
  static const jayWanFieldValue = "jaywan";
  static const madaFieldValue = "mada";
  static const maestroFieldValue = "maestro";
  static const meezaFieldValue = "meeza";
  static const mirFieldValue = "mir";
  static const myDebitFieldValue = "mydebit";
  static const nanacoFieldValue = "nanaco";
  static const napasFieldValue = "napas";
  static const pagoBancomatFieldValue = "pagobancomat";
  static const postFinanceFieldValue = "postfinance";
  static const privateLabelFieldValue = "privatelabel";
  static const quicPayFieldValue = "quicpay";
  static const suicaFieldValue = "suica";
  static const tMoneyFieldValue = "tmoney";
  static const vPayFieldValue = "vpay";
  static const unsupportedCardFieldValue = "unsupported";

  // PaymentData keys
  static const pdTokenKey = "token";
  static const pdLastFourKey = "lastFour";
  static const pdCardTypeKey = "cardType";
  static const pdOloCardDescriptionKey = "oloPaymentNetworkDescription";
  static const pdCardDetailsKey = "cardDetails";
  static const pdEmailKey = "email";
  static const pdPhoneNumberKey = "phoneNumber";
  static const pdFullNameKey = "fullName";
  static const pdFullPhoneticNameKey = "fullPhoneticName";
  static const pdBillingAddressKey = "billingAddress";

  // Address keys
  static const address1Key = "street";
  static const administrativeAreaKey = "state";
  static const countryCodeKey = "countryCode";
  static const localityKey = "city";
  static const postalCodeKey = "postalCode";

  // Error keys
  static const errorMessageKey = "errorMessage";
  static const errorCodeKey = "errorCode";
  static const digitalWalletTypeKey = "digitalWalletType";
}
