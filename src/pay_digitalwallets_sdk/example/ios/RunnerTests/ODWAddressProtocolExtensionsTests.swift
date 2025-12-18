// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  ODWAddressProtocolExtensionsTests.swift
//  RunnerTests
//
//  Created by Tests on 12/2/24.
//

import XCTest
import OloDigitalWalletsSDK
@testable import pay_digitalwallets_sdk_ios

class ODWAddressProtocolExtensionsTests: XCTestCase {

    // MARK: - toDictionary Tests

    func testToDictionary_withFullAddress_hasCorrectLength() {
        let address = MockAddress(
            street: "123 Main St",
            city: "New York",
            state: "NY",
            postalCode: "10001",
            countryCode: "US"
        )

        let result = address.toDictionary()

        XCTAssertEqual(result.count, 8)
    }

    func testToDictionary_withFullAddress_hasCorrectKeys() {
        let address = MockAddress(
            street: "123 Main St",
            city: "New York",
            state: "NY",
            postalCode: "10001",
            countryCode: "US"
        )

        let result = address.toDictionary()

        XCTAssertTrue(result.keys.contains(DataKeys.AddressLine1Key))
        XCTAssertTrue(result.keys.contains(DataKeys.AddressLine2Key))
        XCTAssertTrue(result.keys.contains(DataKeys.AddressLine3Key))
        XCTAssertTrue(result.keys.contains(DataKeys.AddressLocalityKey))
        XCTAssertTrue(result.keys.contains(DataKeys.AddressAdministrativeAreaKey))
        XCTAssertTrue(result.keys.contains(DataKeys.AddressPostalCodeKey))
        XCTAssertTrue(result.keys.contains(DataKeys.AddressCountryCodeKey))
        XCTAssertTrue(result.keys.contains(DataKeys.AddressSortingCodeKey))
    }

    func testToDictionary_withFullAddress_hasCorrectValues() {
        let address = MockAddress(
            street: "123 Main St",
            city: "New York",
            state: "NY",
            postalCode: "10001",
            countryCode: "US"
        )

        let result = address.toDictionary()

        XCTAssertEqual(result[DataKeys.AddressLine1Key] as? String, "123 Main St")
        XCTAssertEqual(result[DataKeys.AddressLine2Key] as? String, "")
        XCTAssertEqual(result[DataKeys.AddressLine3Key] as? String, "")
        XCTAssertEqual(result[DataKeys.AddressLocalityKey] as? String, "New York")
        XCTAssertEqual(result[DataKeys.AddressAdministrativeAreaKey] as? String, "NY")
        XCTAssertEqual(result[DataKeys.AddressPostalCodeKey] as? String, "10001")
        XCTAssertEqual(result[DataKeys.AddressCountryCodeKey] as? String, "US")
        XCTAssertEqual(result[DataKeys.AddressSortingCodeKey] as? String, "")
    }

    func testToDictionary_withMinimalAddress_hasCorrectValues() {
        let address = MockAddress(
            street: "",
            city: "",
            state: "",
            postalCode: "12345",
            countryCode: "US"
        )

        let result = address.toDictionary()

        XCTAssertEqual(result[DataKeys.AddressLine1Key] as? String, "")
        XCTAssertEqual(result[DataKeys.AddressLocalityKey] as? String, "")
        XCTAssertEqual(result[DataKeys.AddressAdministrativeAreaKey] as? String, "")
        XCTAssertEqual(result[DataKeys.AddressPostalCodeKey] as? String, "12345")
        XCTAssertEqual(result[DataKeys.AddressCountryCodeKey] as? String, "US")
    }

    func testToDictionary_alwaysHasEmptyAddress2() {
        let address = MockAddress(
            street: "123 Main St",
            city: "New York",
            state: "NY",
            postalCode: "10001",
            countryCode: "US"
        )

        let result = address.toDictionary()

        XCTAssertEqual(result[DataKeys.AddressLine2Key] as? String, "")
    }

    func testToDictionary_alwaysHasEmptyAddress3() {
        let address = MockAddress(
            street: "123 Main St",
            city: "New York",
            state: "NY",
            postalCode: "10001",
            countryCode: "US"
        )

        let result = address.toDictionary()

        XCTAssertEqual(result[DataKeys.AddressLine3Key] as? String, "")
    }

    func testToDictionary_alwaysHasEmptySortingCode() {
        let address = MockAddress(
            street: "123 Main St",
            city: "New York",
            state: "NY",
            postalCode: "10001",
            countryCode: "US"
        )

        let result = address.toDictionary()

        XCTAssertEqual(result[DataKeys.AddressSortingCodeKey] as? String, "")
    }
}

// MARK: - Mock Address

class MockAddress: NSObject, ODWAddressProtocol {
    var street: String
    var city: String
    var state: String
    var postalCode: String
    var country: String
    var countryCode: String
    var administrativeArea: String
    var locality: String

    init(street: String, city: String, state: String, postalCode: String, countryCode: String) {
        self.street = street
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.country = "" // Not used in tests
        self.countryCode = countryCode
        self.administrativeArea = state // Same as state
        self.locality = city // Same as city
        super.init()
    }
}
