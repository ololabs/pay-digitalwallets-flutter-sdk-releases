// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/card_type.dart';

void main() {
  group('CardType:', () {
    test('All CardType values accounted for', () {
      final allCardTypes = CardType.values;

      final expectedCardTypes = [
        CardType.visa,
        CardType.americanExpress,
        CardType.discover,
        CardType.masterCard,
        CardType.jcb,
        CardType.dinersClub,
        CardType.chinaUnionPay,
        CardType.bankAxept,
        CardType.bancomat,
        CardType.bancontact,
        CardType.barcode,
        CardType.carteBancaire,
        CardType.carteBancaires,
        CardType.cartesBancaires,
        CardType.dankort,
        CardType.eftpos,
        CardType.electron,
        CardType.elo,
        CardType.girocard,
        CardType.himyan,
        CardType.idCredit,
        CardType.interac,
        CardType.jayWan,
        CardType.mada,
        CardType.maestro,
        CardType.meeza,
        CardType.mir,
        CardType.myDebit,
        CardType.napas,
        CardType.nanaco,
        CardType.pagoBancomat,
        CardType.postFinance,
        CardType.privateLabel,
        CardType.quicPay,
        CardType.suica,
        CardType.tMoney,
        CardType.vPay,
        CardType.unsupported,
      ];

      for (final cardType in allCardTypes) {
        expect(expectedCardTypes, contains(cardType));
      }
    });

    group('toOloBrand', () {
      test('Converts to Visa', () {
        expect(CardType.visa.oloDescription, 'Visa');
      });

      test('Converts to Mastercard', () {
        expect(CardType.masterCard.oloDescription, 'Mastercard');
      });

      test('Converts to Amex', () {
        expect(CardType.americanExpress.oloDescription, 'Amex');
      });

      test('Converts to Discover', () {
        expect(CardType.discover.oloDescription, 'Discover');
      });

      test('Converts JCB to Discover', () {
        expect(CardType.jcb.oloDescription, 'Discover');
      });

      test('Converts chinaUnionPay to Discover', () {
        expect(CardType.chinaUnionPay.oloDescription, 'Discover');
      });

      test('Converts dinersClub to Discover', () {
        expect(CardType.dinersClub.oloDescription, 'Discover');
      });

      test('Converts to unsupported', () {
        expect(CardType.bankAxept.oloDescription, 'Unsupported');
        expect(CardType.bancomat.oloDescription, 'Unsupported');
        expect(CardType.bancontact.oloDescription, 'Unsupported');
        expect(CardType.barcode.oloDescription, 'Unsupported');
        expect(CardType.carteBancaire.oloDescription, 'Unsupported');
        expect(CardType.carteBancaires.oloDescription, 'Unsupported');
        expect(CardType.cartesBancaires.oloDescription, 'Unsupported');
        expect(CardType.dankort.oloDescription, 'Unsupported');
        expect(CardType.eftpos.oloDescription, 'Unsupported');
        expect(CardType.electron.oloDescription, 'Unsupported');
        expect(CardType.elo.oloDescription, 'Unsupported');
        expect(CardType.girocard.oloDescription, 'Unsupported');
        expect(CardType.himyan.oloDescription, 'Unsupported');
        expect(CardType.idCredit.oloDescription, 'Unsupported');
        expect(CardType.interac.oloDescription, 'Unsupported');
        expect(CardType.jayWan.oloDescription, 'Unsupported');
        expect(CardType.mada.oloDescription, 'Unsupported');
        expect(CardType.maestro.oloDescription, 'Unsupported');
        expect(CardType.meeza.oloDescription, 'Unsupported');
        expect(CardType.mir.oloDescription, 'Unsupported');
        expect(CardType.myDebit.oloDescription, 'Unsupported');
        expect(CardType.napas.oloDescription, 'Unsupported');
        expect(CardType.nanaco.oloDescription, 'Unsupported');
        expect(CardType.pagoBancomat.oloDescription, 'Unsupported');
        expect(CardType.postFinance.oloDescription, 'Unsupported');
        expect(CardType.privateLabel.oloDescription, 'Unsupported');
        expect(CardType.quicPay.oloDescription, 'Unsupported');
        expect(CardType.suica.oloDescription, 'Unsupported');
        expect(CardType.tMoney.oloDescription, 'Unsupported');
        expect(CardType.vPay.oloDescription, 'Unsupported');
        expect(CardType.unsupported.oloDescription, 'Unsupported');
      });
    });

    group('isSupportedByOlo', () {
      test('Supported card types return true', () {
        expect(CardType.visa.isSupportedByOlo, true);
        expect(CardType.masterCard.isSupportedByOlo, true);
        expect(CardType.americanExpress.isSupportedByOlo, true);
        expect(CardType.discover.isSupportedByOlo, true);
        expect(CardType.jcb.isSupportedByOlo, true);
        expect(CardType.dinersClub.isSupportedByOlo, true);
        expect(CardType.chinaUnionPay.isSupportedByOlo, true);
      });

      test('Unsupported card types return false', () {
        expect(CardType.interac.isSupportedByOlo, false);
        expect(CardType.bankAxept.isSupportedByOlo, false);
        expect(CardType.bancomat.isSupportedByOlo, false);
        expect(CardType.bancontact.isSupportedByOlo, false);
        expect(CardType.barcode.isSupportedByOlo, false);
        expect(CardType.carteBancaire.isSupportedByOlo, false);
        expect(CardType.carteBancaires.isSupportedByOlo, false);
        expect(CardType.cartesBancaires.isSupportedByOlo, false);
        expect(CardType.dankort.isSupportedByOlo, false);
        expect(CardType.eftpos.isSupportedByOlo, false);
        expect(CardType.electron.isSupportedByOlo, false);
        expect(CardType.elo.isSupportedByOlo, false);
        expect(CardType.girocard.isSupportedByOlo, false);
        expect(CardType.himyan.isSupportedByOlo, false);
        expect(CardType.idCredit.isSupportedByOlo, false);
        expect(CardType.jayWan.isSupportedByOlo, false);
        expect(CardType.mada.isSupportedByOlo, false);
        expect(CardType.maestro.isSupportedByOlo, false);
        expect(CardType.meeza.isSupportedByOlo, false);
        expect(CardType.mir.isSupportedByOlo, false);
        expect(CardType.myDebit.isSupportedByOlo, false);
        expect(CardType.napas.isSupportedByOlo, false);
        expect(CardType.nanaco.isSupportedByOlo, false);
        expect(CardType.pagoBancomat.isSupportedByOlo, false);
        expect(CardType.postFinance.isSupportedByOlo, false);
        expect(CardType.privateLabel.isSupportedByOlo, false);
        expect(CardType.quicPay.isSupportedByOlo, false);
        expect(CardType.suica.isSupportedByOlo, false);
        expect(CardType.tMoney.isSupportedByOlo, false);
        expect(CardType.vPay.isSupportedByOlo, false);
      });
    });
  });
}
