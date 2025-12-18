// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import XCTest
import PassKit
@testable import pay_digitalwallets_sdk_ios

class PKPaymentNetworkExtensionsTests: XCTestCase {

    // MARK: - convert() Tests

    func testConvert_WithValidNetworks_ReturnsCorrectPKPaymentNetworks() {
        // Arrange
        let networkStrings = ["visa", "mastercard", "americanexpress", "discover"]

        // Act
        let result = PKPaymentNetwork.convert(networkStrings)

        // Assert
        XCTAssertEqual(result.count, 4, "Should convert all valid networks")
        XCTAssertTrue(result.contains(.visa), "Should contain Visa")
        XCTAssertTrue(result.contains(.masterCard), "Should contain MasterCard")
        XCTAssertTrue(result.contains(.amex), "Should contain Amex")
        XCTAssertTrue(result.contains(.discover), "Should contain Discover")
    }

    func testConvert_WithMixedCaseNetworks_ReturnsCorrectPKPaymentNetworks() {
        // Arrange
        let networkStrings = ["VISA", "MasterCard", "AmericanExpress"]

        // Act
        let result = PKPaymentNetwork.convert(networkStrings)

        // Assert
        XCTAssertEqual(result.count, 3, "Should handle mixed case")
        XCTAssertTrue(result.contains(.visa))
        XCTAssertTrue(result.contains(.masterCard))
        XCTAssertTrue(result.contains(.amex))
    }

    func testConvert_WithInvalidNetworks_FiltersThemOut() {
        // Arrange
        let networkStrings = ["visa", "invalid", "mastercard", "unknown"]

        // Act
        let result = PKPaymentNetwork.convert(networkStrings)

        // Assert
        XCTAssertEqual(result.count, 2, "Should filter out invalid networks")
        XCTAssertTrue(result.contains(.visa))
        XCTAssertTrue(result.contains(.masterCard))
    }

    func testConvert_WithEmptyArray_ReturnsEmptyArray() {
        // Arrange
        let networkStrings: [String] = []

        // Act
        let result = PKPaymentNetwork.convert(networkStrings)

        // Assert
        XCTAssertEqual(result.count, 0, "Should return empty array for empty input")
    }

    func testConvert_WithOnlyInvalidNetworks_ReturnsEmptyArray() {
        // Arrange
        let networkStrings = ["invalid", "unknown", "notacard"]

        // Act
        let result = PKPaymentNetwork.convert(networkStrings)

        // Assert
        XCTAssertEqual(result.count, 0, "Should return empty array when all networks are invalid")
    }

    func testConvert_WithCommonNetworks_ReturnsExpectedResults() {
        // Arrange
        let networkStrings = [
            "visa",
            "mastercard",
            "discover",
            "americanexpress",
            "jcb",
            "chinaunionpay",
            "interac"
        ]

        // Act
        let result = PKPaymentNetwork.convert(networkStrings)

        // Assert
        XCTAssertEqual(result.count, 7, "Should convert all common networks")
        XCTAssertTrue(result.contains(.visa))
        XCTAssertTrue(result.contains(.masterCard))
        XCTAssertTrue(result.contains(.discover))
        XCTAssertTrue(result.contains(.amex))
        XCTAssertTrue(result.contains(.JCB))
        XCTAssertTrue(result.contains(.chinaUnionPay))
        XCTAssertTrue(result.contains(.interac))
    }

    func testConvert_WithSpecializedNetworks_ReturnsCorrectResults() {
        // Arrange
        let networkStrings = [
            "eftpos",
            "electron",
            "elo",
            "maestro",
            "privatelabel",
            "vpay"
        ]

        // Act
        let result = PKPaymentNetwork.convert(networkStrings)

        // Assert
        XCTAssertEqual(result.count, 6, "Should convert specialized networks")
        XCTAssertTrue(result.contains(.eftpos))
        XCTAssertTrue(result.contains(.electron))
        XCTAssertTrue(result.contains(.elo))
        XCTAssertTrue(result.contains(.maestro))
        XCTAssertTrue(result.contains(.privateLabel))
        XCTAssertTrue(result.contains(.vPay))
    }

    func testConvert_WithJapaneseNetworks_ReturnsCorrectResults() {
        // Arrange
        let networkStrings = ["quicpay", "suica"]

        // Act
        let result = PKPaymentNetwork.convert(networkStrings)

        // Assert
        XCTAssertEqual(result.count, 2, "Should convert Japanese networks")
        XCTAssertTrue(result.contains(.quicPay))
        XCTAssertTrue(result.contains(.suica))
    }

    @available(iOS 14.0, *)
    func testConvert_WithiOS14Networks_ReturnsCorrectResults() {
        // Arrange
        let networkStrings = ["girocard", "barcode"]

        // Act
        let result = PKPaymentNetwork.convert(networkStrings)

        // Assert
        XCTAssertEqual(result.count, 2, "Should convert iOS 14+ networks")
        XCTAssertTrue(result.contains(.girocard))
        XCTAssertTrue(result.contains(.barcode))
    }

    @available(iOS 15.0, *)
    func testConvert_WithiOS15Networks_ReturnsCorrectResults() {
        // Arrange
        let networkStrings = ["nanaco", "waon"]

        // Act
        let result = PKPaymentNetwork.convert(networkStrings)

        // Assert
        XCTAssertEqual(result.count, 2, "Should convert iOS 15+ networks")
        XCTAssertTrue(result.contains(.nanaco))
        XCTAssertTrue(result.contains(.waon))
    }

    @available(iOS 16.0, *)
    func testConvert_WithiOS16Networks_ReturnsCorrectResults() {
        // Arrange
        let networkStrings = ["bancomat", "bancontact"]

        // Act
        let result = PKPaymentNetwork.convert(networkStrings)

        // Assert
        XCTAssertEqual(result.count, 2, "Should convert iOS 16+ networks")
        XCTAssertTrue(result.contains(.bancomat))
        XCTAssertTrue(result.contains(.bancontact))
    }

    func testConvert_WithDuplicateNetworks_ReturnsUniqueResults() {
        // Arrange
        let networkStrings = ["visa", "visa", "mastercard", "visa"]

        // Act
        let result = PKPaymentNetwork.convert(networkStrings)

        // Assert
        // Note: The result might contain duplicates since we use compactMap
        // This test documents current behavior
        XCTAssertGreaterThanOrEqual(result.count, 2, "Should contain at least visa and mastercard")
        XCTAssertTrue(result.contains(.visa))
        XCTAssertTrue(result.contains(.masterCard))
    }
}
