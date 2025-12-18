// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/card_type.dart';
import 'package:pay_digitalwallets_sdk_ios/src/private/data/data_keys.dart';

extension CardTypeExtensions on CardType {
  static CardType from(String? stringValue) {
    switch (stringValue?.toLowerCase()) {
      case DataKeys.visaFieldValue:
        return CardType.visa;
      case DataKeys.amexFieldValue:
        return CardType.americanExpress;
      case DataKeys.discoverFieldValue:
        return CardType.discover;
      case DataKeys.masterCardFieldValue:
        return CardType.masterCard;
      case DataKeys.jcbFieldValue:
        return CardType.jcb;
      case DataKeys.bankAxeptFieldValue:
        return CardType.bankAxept;
      case DataKeys.bancomatFieldValue:
        return CardType.bancomat;
      case DataKeys.bancontactFieldValue:
        return CardType.bancontact;
      case DataKeys.barcodeFieldValue:
        return CardType.barcode;
      case DataKeys.carteBancaireFieldValue:
        return CardType.carteBancaire;
      case DataKeys.carteBancairesFieldValue:
        return CardType.carteBancaires;
      case DataKeys.cartesBancairesFieldValue:
        return CardType.cartesBancaires;
      case DataKeys.chinaUnionPayFieldValue:
        return CardType.chinaUnionPay;
      case DataKeys.dankortFieldValue:
        return CardType.dankort;
      case DataKeys.dinersClubFieldValue:
        return CardType.dinersClub;
      case DataKeys.eftposFieldValue:
        return CardType.eftpos;
      case DataKeys.electronFieldValue:
        return CardType.electron;
      case DataKeys.eloFieldValue:
        return CardType.elo;
      case DataKeys.girocardFieldValue:
        return CardType.girocard;
      case DataKeys.himyanFieldValue:
        return CardType.himyan;
      case DataKeys.idCreditFieldValue:
        return CardType.idCredit;
      case DataKeys.interacFieldValue:
        return CardType.interac;
      case DataKeys.jayWanFieldValue:
        return CardType.jayWan;
      case DataKeys.madaFieldValue:
        return CardType.mada;
      case DataKeys.maestroFieldValue:
        return CardType.maestro;
      case DataKeys.meezaFieldValue:
        return CardType.meeza;
      case DataKeys.mirFieldValue:
        return CardType.mir;
      case DataKeys.myDebitFieldValue:
        return CardType.myDebit;
      case DataKeys.napasFieldValue:
        return CardType.napas;
      case DataKeys.nanacoFieldValue:
        return CardType.nanaco;
      case DataKeys.pagoBancomatFieldValue:
        return CardType.pagoBancomat;
      case DataKeys.postFinanceFieldValue:
        return CardType.postFinance;
      case DataKeys.privateLabelFieldValue:
        return CardType.privateLabel;
      case DataKeys.quicPayFieldValue:
        return CardType.quicPay;
      case DataKeys.suicaFieldValue:
        return CardType.suica;
      case DataKeys.tMoneyFieldValue:
        return CardType.tMoney;
      case DataKeys.vPayFieldValue:
        return CardType.vPay;
      default:
        return CardType.unsupported;
    }
  }
}
