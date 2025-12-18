// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  PKPaymentButtonTypeExtensionsTests.swift
//  pay_digitalwallets_sdk_ios Tests
//
//  Created by Tests on 12/2/24.
//

import XCTest
import PassKit
@testable import pay_digitalwallets_sdk_ios

class PKPaymentButtonTypeExtensionsTests: XCTestCase {

    func testConvert_fromPlain_returnsPlainType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypePlain)
        XCTAssertEqual(result, .plain)
    }

    func testConvert_fromBuy_returnsBuyType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeBuy)
        XCTAssertEqual(result, .buy)
    }

    func testConvert_fromBook_returnsBookType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeBook)
        XCTAssertEqual(result, .book)
    }

    func testConvert_fromCheckout_returnsCheckoutType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeCheckout)
        XCTAssertEqual(result, .checkout)
    }

    func testConvert_fromDonate_returnsDonateType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeDonate)
        XCTAssertEqual(result, .donate)
    }

    func testConvert_fromInStore_returnsInStoreType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeInStore)
        XCTAssertEqual(result, .inStore)
    }

    func testConvert_fromSetUp_returnsSetUpType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeSetUp)
        XCTAssertEqual(result, .setUp)
    }

    func testConvert_fromSubscribe_returnsSubscribeType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeSubscribe)
        XCTAssertEqual(result, .subscribe)
    }

    // Test iOS 14.0+ types
    func testConvert_fromAddMoney_returnsAppropriateType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeAddMoney)

        if #available(iOS 14.0, *) {
            XCTAssertEqual(result, .addMoney)
        } else {
            XCTAssertEqual(result, .checkout)
        }
    }

    func testConvert_fromContribute_returnsAppropriateType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeContribute)

        if #available(iOS 14.0, *) {
            XCTAssertEqual(result, .contribute)
        } else {
            XCTAssertEqual(result, .checkout)
        }
    }

    func testConvert_fromOrder_returnsAppropriateType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeOrder)

        if #available(iOS 14.0, *) {
            XCTAssertEqual(result, .order)
        } else {
            XCTAssertEqual(result, .checkout)
        }
    }

    func testConvert_fromReload_returnsAppropriateType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeReload)

        if #available(iOS 14.0, *) {
            XCTAssertEqual(result, .reload)
        } else {
            XCTAssertEqual(result, .checkout)
        }
    }

    func testConvert_fromRent_returnsAppropriateType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeRent)

        if #available(iOS 14.0, *) {
            XCTAssertEqual(result, .rent)
        } else {
            XCTAssertEqual(result, .checkout)
        }
    }

    func testConvert_fromSupport_returnsAppropriateType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeSupport)

        if #available(iOS 14.0, *) {
            XCTAssertEqual(result, .support)
        } else {
            XCTAssertEqual(result, .checkout)
        }
    }

    func testConvert_fromTip_returnsAppropriateType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeTip)

        if #available(iOS 14.0, *) {
            XCTAssertEqual(result, .tip)
        } else {
            XCTAssertEqual(result, .checkout)
        }
    }

    func testConvert_fromTopUp_returnsAppropriateType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeTopUp)

        if #available(iOS 14.0, *) {
            XCTAssertEqual(result, .topUp)
        } else {
            XCTAssertEqual(result, .checkout)
        }
    }

    // Test iOS 15.0+ types
    func testConvert_fromContinue_returnsAppropriateType() {
        let result = PKPaymentButtonType.convert(from: DataKeys.ApplePayButtonTypeContinue)

        if #available(iOS 15.0, *) {
            XCTAssertEqual(result, .continue)
        } else {
            XCTAssertEqual(result, .checkout)
        }
    }

    // Test invalid/unknown types
    func testConvert_fromInvalidString_returnsCheckoutAsDefault() {
        let result = PKPaymentButtonType.convert(from: "invalid")
        XCTAssertEqual(result, .checkout)
    }

    func testConvert_fromEmptyString_returnsCheckoutAsDefault() {
        let result = PKPaymentButtonType.convert(from: "")
        XCTAssertEqual(result, .checkout)
    }
}
