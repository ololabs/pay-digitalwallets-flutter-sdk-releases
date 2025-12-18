// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  PKPaymentButtonStyleExtensionsTests.swift
//  pay_digitalwallets_sdk_ios Tests
//
//  Created by Tests on 12/2/24.
//

import XCTest
import PassKit
@testable import pay_digitalwallets_sdk_ios

class PKPaymentButtonStyleExtensionsTests: XCTestCase {

    func testConvert_fromBlack_returnsBlackStyle() {
        let result = PKPaymentButtonStyle.convert(from: DataKeys.ApplePayButtonStyleBlack)
        XCTAssertEqual(result, .black)
    }

    func testConvert_fromWhite_returnsWhiteStyle() {
        let result = PKPaymentButtonStyle.convert(from: DataKeys.ApplePayButtonStyleWhite)
        XCTAssertEqual(result, .white)
    }

    func testConvert_fromWhiteOutline_returnsWhiteOutlineStyle() {
        let result = PKPaymentButtonStyle.convert(from: DataKeys.ApplePayButtonStyleWhiteOutline)
        XCTAssertEqual(result, .whiteOutline)
    }

    func testConvert_fromAutomatic_returnsAppropriateStyle() {
        let result = PKPaymentButtonStyle.convert(from: DataKeys.ApplePayButtonStyleAutomatic)

        if #available(iOS 14.0, *) {
            XCTAssertEqual(result, .automatic)
        } else {
            XCTAssertEqual(result, .black)
        }
    }

    func testConvert_fromInvalidString_returnsBlackAsDefault() {
        let result = PKPaymentButtonStyle.convert(from: "invalid")
        XCTAssertEqual(result, .black)
    }

    func testConvert_fromEmptyString_returnsBlackAsDefault() {
        let result = PKPaymentButtonStyle.convert(from: "")
        XCTAssertEqual(result, .black)
    }
}
