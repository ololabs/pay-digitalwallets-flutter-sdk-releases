// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk_platform_interface/src/private/data/data_keys.dart';

/// Enum representing credit card types
///
/// For more general information on card types supported by each platform see:
/// * Apple Pay - [PKPaymentNetwork](https://developer.apple.com/documentation/passkit/pkpaymentnetwork)
/// * Google Pay - [CardParameters.allowedCardNetworks](https://developers.google.com/pay/api/android/reference/request-objects#CardParameters)
///
/// **Important:** When submitting card details to Olo's ordering API
/// the card type value passed should be the [oloDescription] of this enum.
///
/// Supported card types by Olo:
/// * Visa
/// * Mastercard
/// * American Express
/// * Discover
/// * JCB
/// * Diners Club
/// * Union Pay
enum CardType {
  /// Visa
  /// Availability: Apple Pay & Google Pay
  ///
  /// **Note:** _Supported by Olo's Ordering API_
  visa(oloDescription: DataKeys.visaFieldValue),

  /// American Express
  /// Availability: Apple Pay & Google Pay
  ///
  /// **Note:** _Supported by Olo's Ordering API_
  americanExpress(oloDescription: DataKeys.amexFieldValue),

  /// Discover
  /// Availability: Apple Pay & Google Pay
  ///
  /// **Note:** _Supported by Olo's Ordering API_
  discover(oloDescription: DataKeys.discoverFieldValue),

  /// Mastercard
  /// Availability: Apple Pay & Google Pay
  ///
  /// **Note:** _Supported by Olo's Ordering API_
  masterCard(oloDescription: DataKeys.masterCardFieldValue),

  /// JCB
  /// Availability: Apple Pay & Google Pay
  ///
  /// **Note:** _Supported by Olo's Ordering API (processed as "Discover")_
  jcb(oloDescription: DataKeys.discoverFieldValue),

  /// Diners Club
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Supported by Olo's Ordering API (processed as "Discover")_
  dinersClub(oloDescription: DataKeys.discoverFieldValue),

  /// China UnionPay
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Supported by Olo's Ordering API (processed as "Discover")_
  chinaUnionPay(oloDescription: DataKeys.discoverFieldValue),

  /// BankAxept
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  bankAxept(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Bancomat
  /// Availability: Apple Pay Only _(Deprecated in iOS 17)_
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  bancomat(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Bancontact
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  bancontact(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Barcode/QR code payment
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  barcode(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Carte Bancaire
  /// Availability: Apple Pay Only _(Deprecated in iOS 11)_
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  carteBancaire(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Carte Bancaires
  /// Availability: Apple Pay Only _(Deprecated in iOS 11.2)_
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  carteBancaires(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Cartes Bancaires
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  cartesBancaires(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Dankort
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  dankort(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Eftpos
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  eftpos(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Electron
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  electron(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Elo
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  elo(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Girocard
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  girocard(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Himyan
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  himyan(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// IDCredit
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  idCredit(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Interac
  /// Availability: Apple Pay & Google Pay
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  interac(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// JayWan
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  jayWan(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Mada
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  mada(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Maestro
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  maestro(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Meeza
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  meeza(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Mir
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  mir(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// MyDebit
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  myDebit(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// NAPAS
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  napas(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Nanaco
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  nanaco(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// PagoBancomat
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  pagoBancomat(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// PostFinance
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  postFinance(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// PrivateLabel
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  privateLabel(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// QuicPay
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  quicPay(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Suica
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  suica(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// TMoney
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  tMoney(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// VPay
  /// Availability: Apple Pay Only
  ///
  /// **Note:** _Not Supported by Olo's Ordering API_
  vPay(oloDescription: DataKeys.unsupportedCardFieldValue),

  /// Unsupported
  /// This value is rarely seen and most likely indicates support for a
  /// new card type was added by Apple or Google after the release of the SDK.
  /// Updating to the most recent version of the SDK should resolve the issue.
  /// If currently using the latest version of the SDK, file an issue in the
  /// [Android](https://github.com/ololabs/pay-digitalwallets-android-sdk-releases) or
  /// [iOS](https://github.com/ololabs/pay-digitalwallets-ios-sdk-releases) SDK's Github repository.
  unsupported(oloDescription: DataKeys.unsupportedCardFieldValue);

  /// The string value of the enum that is used for Olo's Ordering ecosystem
  final String oloDescription;

  /// @nodoc
  const CardType({
    required this.oloDescription,
  });

  /// Checks if the card type is supported by Olo's Ordering API
  bool get isSupportedByOlo =>
      oloDescription != DataKeys.unsupportedCardFieldValue;

  /// @nodoc
  static final Map<String, CardType> _stringValueMap = {
    'visa': CardType.visa,
    'amex': CardType.americanExpress,
    'americanexpress': CardType.americanExpress,
    'discover': CardType.discover,
    'mastercard': CardType.masterCard,
    'jcb': CardType.jcb,
    'jcbpremo': CardType.jcb,
    'dinersclub': CardType.dinersClub,
    'chinaunionpay': CardType.chinaUnionPay,
    'bankaxept': CardType.bankAxept,
    'bancomat': CardType.bancomat,
    'bancontact': CardType.bancontact,
    'barcode': CardType.barcode,
    'cartebancaire': CardType.carteBancaire,
    'cartebancaires': CardType.carteBancaires,
    'cartesbancaires': CardType.cartesBancaires,
    'dankort': CardType.dankort,
    'eftpos': CardType.eftpos,
    'electron': CardType.electron,
    'elo': CardType.elo,
    'girocard': CardType.girocard,
    'interac': CardType.interac,
    'mada': CardType.mada,
    'maestro': CardType.maestro,
    'meeza': CardType.meeza,
    'mir': CardType.mir,
    'mydebit': CardType.myDebit,
    'napas': CardType.napas,
    'nanaco': CardType.nanaco,
    'pagobancomat': CardType.pagoBancomat,
    'postfinance': CardType.postFinance,
    'privatelabel': CardType.privateLabel,
    'quicpay': CardType.quicPay,
    'suica': CardType.suica,
    'tmoney': CardType.tMoney,
    'vpay': CardType.vPay,
  };

  /// @nodoc
  static CardType fromStringValue(String? stringValue) {
    if (stringValue == null) return CardType.unsupported;
    return _stringValueMap[stringValue.toLowerCase()] ?? CardType.unsupported;
  }
}
