// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/line_item.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/line_item_status.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/data_classes/line_item_type.dart';

void main() {
  final allParamsMap = LineItem(
    amount: 1.20,
    type: LineItemType.lineItem,
    label: "Item 1",
    status: LineItemStatus.pendingStatus,
  ).toMap();

  final requiredParamsMap = LineItem(
    amount: 2.34,
    type: LineItemType.tax,
    label: "Item 2",
  ).toMap();

  final lineItemMap = LineItem.lineItem(amount: 1.00, label: "Item 1").toMap();

  final subtotalParamsMap = LineItem.subtotal(amount: 2.34).toMap();

  final taxParamsMap = LineItem.tax(amount: 2.34).toMap();

  group('LineItem', () {
    group('toMap():', () {
      group('All Params:', () {
        test('Has correct length', () {
          expect(allParamsMap.length, 4);
        });
        test('Has correct keys', () {
          expect(allParamsMap.containsKey('lineItemAmount'), true);
          expect(allParamsMap.containsKey('lineItemType'), true);
          expect(allParamsMap.containsKey('lineItemLabel'), true);
          expect(allParamsMap.containsKey('lineItemStatus'), true);
        });

        test('Keys have correct values', () {
          expect(allParamsMap['lineItemAmount'], '1.2');
          expect(allParamsMap['lineItemType'], 'Line_Item');
          expect(allParamsMap['lineItemLabel'], 'Item 1');
          expect(allParamsMap['lineItemStatus'], 'Pending');
        });
      });

      group('Required Params Only:', () {
        test('Has correct length', () {
          expect(requiredParamsMap.length, 4);
        });
        test('Has correct keys', () {
          expect(requiredParamsMap.containsKey('lineItemAmount'), true);
          expect(requiredParamsMap.containsKey('lineItemType'), true);
          expect(requiredParamsMap.containsKey('lineItemLabel'), true);
          expect(requiredParamsMap.containsKey('lineItemStatus'), true);
        });

        test('Keys have correct values', () {
          expect(requiredParamsMap['lineItemAmount'], '2.34');
          expect(requiredParamsMap['lineItemType'], 'Tax');
          expect(requiredParamsMap['lineItemLabel'], 'Item 2');
          expect(requiredParamsMap['lineItemStatus'], 'Final');
        });
      });

      group('Line Item type constructor:', () {
        test('Has correct length', () {
          expect(lineItemMap.length, 4);
        });
        test('Has correct keys', () {
          expect(lineItemMap.containsKey('lineItemAmount'), true);
          expect(lineItemMap.containsKey('lineItemType'), true);
          expect(lineItemMap.containsKey('lineItemLabel'), true);
          expect(lineItemMap.containsKey('lineItemStatus'), true);
        });

        test('Keys have correct values', () {
          expect(lineItemMap['lineItemAmount'], '1.0');
          expect(lineItemMap['lineItemType'], 'Line_Item');
          expect(lineItemMap['lineItemLabel'], 'Item 1');
          expect(lineItemMap['lineItemStatus'], 'Final');
        });
      });

      group('Subtotal type constructor:', () {
        test('Has correct length', () {
          expect(subtotalParamsMap.length, 4);
        });
        test('Has correct keys', () {
          expect(subtotalParamsMap.containsKey('lineItemAmount'), true);
          expect(subtotalParamsMap.containsKey('lineItemType'), true);
          expect(subtotalParamsMap.containsKey('lineItemLabel'), true);
          expect(subtotalParamsMap.containsKey('lineItemStatus'), true);
        });

        test('Keys have correct values', () {
          expect(subtotalParamsMap['lineItemAmount'], '2.34');
          expect(subtotalParamsMap['lineItemType'], 'Subtotal');
          expect(subtotalParamsMap['lineItemLabel'], 'Subtotal');
          expect(subtotalParamsMap['lineItemStatus'], 'Final');
        });
      });

      group('Tax type constructor:', () {
        test('Has correct length', () {
          expect(taxParamsMap.length, 4);
        });
        test('Has correct keys', () {
          expect(taxParamsMap.containsKey('lineItemAmount'), true);
          expect(taxParamsMap.containsKey('lineItemType'), true);
          expect(taxParamsMap.containsKey('lineItemLabel'), true);
          expect(taxParamsMap.containsKey('lineItemStatus'), true);
        });

        test('Keys have correct values', () {
          expect(taxParamsMap['lineItemAmount'], '2.34');
          expect(taxParamsMap['lineItemType'], 'Tax');
          expect(taxParamsMap['lineItemLabel'], 'Tax');
          expect(taxParamsMap['lineItemStatus'], 'Final');
        });
      });
    });
  });
}
