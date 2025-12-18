// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  ODWPaymentDataProtocolExtensionsTests.swift
//  RunnerTests
//
//  Created by Tests on 12/2/24.
//

import XCTest
import OloDigitalWalletsSDK
import PassKit
@testable import pay_digitalwallets_sdk_ios

class ODWPaymentDataProtocolExtensionsTests: XCTestCase {

    // MARK: - toDictionary Tests

    func testToDictionary_withFullPaymentData_hasCorrectLength() {
        let paymentData = MockPaymentData(
            token: "test_token_12345",
            lastFour: "1234",
            paymentNetwork: .visa,
            oloPaymentNetworkDescription: "Visa",
            cardDescription: "Visa ••••1234",
            email: "test@example.com",
            phoneNumber: "5551234567",
            fullName: "John Doe",
            fullPhoneticName: "Jon Doh",
            billingAddress: MockAddress(
                street: "123 Main St",
                city: "New York",
                state: "NY",
                postalCode: "10001",
                countryCode: "US"
            )
        )

        let result = paymentData.toDictionary()

        XCTAssertEqual(result.count, 10)
    }

    func testToDictionary_withFullPaymentData_hasCorrectKeys() {
        let paymentData = MockPaymentData(
            token: "test_token_12345",
            lastFour: "1234",
            paymentNetwork: .visa,
            oloPaymentNetworkDescription: "Visa",
            cardDescription: "Visa ••••1234",
            email: "test@example.com",
            phoneNumber: "5551234567",
            fullName: "John Doe",
            fullPhoneticName: "Jon Doh",
            billingAddress: MockAddress(
                street: "123 Main St",
                city: "New York",
                state: "NY",
                postalCode: "10001",
                countryCode: "US"
            )
        )

        let result = paymentData.toDictionary()

        XCTAssertTrue(result.keys.contains(DataKeys.PaymentDataTokenKey))
        XCTAssertTrue(result.keys.contains(DataKeys.PaymentDataLastFourKey))
        XCTAssertTrue(result.keys.contains(DataKeys.PaymentDataCardTypeKey))
        XCTAssertTrue(result.keys.contains(DataKeys.PaymentDataOloCardDescriptionKey))
        XCTAssertTrue(result.keys.contains(DataKeys.PaymentDataCardDetailsKey))
        XCTAssertTrue(result.keys.contains(DataKeys.PaymentDataEmailKey))
        XCTAssertTrue(result.keys.contains(DataKeys.PaymentDataPhoneNumberKey))
        XCTAssertTrue(result.keys.contains(DataKeys.PaymentDataFullNameKey))
        XCTAssertTrue(result.keys.contains(DataKeys.PaymentDataFullPhoneticNameKey))
        XCTAssertTrue(result.keys.contains(DataKeys.PaymentDataBillingAddressKey))
    }

    func testToDictionary_withFullPaymentData_hasCorrectValues() {
        let paymentData = MockPaymentData(
            token: "test_token_12345",
            lastFour: "1234",
            paymentNetwork: .visa,
            oloPaymentNetworkDescription: "Visa",
            cardDescription: "Visa ••••1234",
            email: "test@example.com",
            phoneNumber: "5551234567",
            fullName: "John Doe",
            fullPhoneticName: "Jon Doh",
            billingAddress: MockAddress(
                street: "123 Main St",
                city: "New York",
                state: "NY",
                postalCode: "10001",
                countryCode: "US"
            )
        )

        let result = paymentData.toDictionary()

        XCTAssertEqual(result[DataKeys.PaymentDataTokenKey] as? String, "test_token_12345")
        XCTAssertEqual(result[DataKeys.PaymentDataLastFourKey] as? String, "1234")
        XCTAssertEqual(result[DataKeys.PaymentDataCardTypeKey] as? String, "visa")
        XCTAssertEqual(result[DataKeys.PaymentDataOloCardDescriptionKey] as? String, "Visa")
        XCTAssertEqual(result[DataKeys.PaymentDataCardDetailsKey] as? String, "Visa ••••1234")
        XCTAssertEqual(result[DataKeys.PaymentDataEmailKey] as? String, "test@example.com")
        XCTAssertEqual(result[DataKeys.PaymentDataPhoneNumberKey] as? String, "5551234567")
        XCTAssertEqual(result[DataKeys.PaymentDataFullNameKey] as? String, "John Doe")
        XCTAssertEqual(result[DataKeys.PaymentDataFullPhoneticNameKey] as? String, "Jon Doh")
    }

    func testToDictionary_withBillingAddress_includesBillingAddressDictionary() {
        let address = MockAddress(
            street: "456 Oak Ave",
            city: "Los Angeles",
            state: "CA",
            postalCode: "90001",
            countryCode: "US"
        )

        let paymentData = MockPaymentData(
            token: "token",
            lastFour: "5678",
            paymentNetwork: .masterCard,
            oloPaymentNetworkDescription: "Mastercard",
            cardDescription: "Mastercard ••••5678",
            email: "",
            phoneNumber: "",
            fullName: "",
            fullPhoneticName: "",
            billingAddress: address
        )

        let result = paymentData.toDictionary()
        let billingAddress = result[DataKeys.PaymentDataBillingAddressKey] as? [String: Any]

        XCTAssertNotNil(billingAddress)
        XCTAssertEqual(billingAddress?[DataKeys.AddressLine1Key] as? String, "456 Oak Ave")
        XCTAssertEqual(billingAddress?[DataKeys.AddressLocalityKey] as? String, "Los Angeles")
        XCTAssertEqual(billingAddress?[DataKeys.AddressAdministrativeAreaKey] as? String, "CA")
        XCTAssertEqual(billingAddress?[DataKeys.AddressPostalCodeKey] as? String, "90001")
        XCTAssertEqual(billingAddress?[DataKeys.AddressCountryCodeKey] as? String, "US")
    }

    func testToDictionary_withNullPaymentNetwork_returnsUnsupported() {
        let paymentData = MockPaymentData(
            token: "token",
            lastFour: "1234",
            paymentNetwork: nil,
            oloPaymentNetworkDescription: "Unsupported",
            cardDescription: "Card ••••1234",
            email: "",
            phoneNumber: "",
            fullName: "",
            fullPhoneticName: "",
            billingAddress: MockAddress(
                street: "",
                city: "",
                state: "",
                postalCode: "12345",
                countryCode: "US"
            )
        )

        let result = paymentData.toDictionary()

        XCTAssertEqual(result[DataKeys.PaymentDataCardTypeKey] as? String, "unsupported")
    }

    func testToDictionary_withAmexNetwork_returnsAmex() {
        let paymentData = MockPaymentData(
            token: "token",
            lastFour: "1234",
            paymentNetwork: .amex,
            oloPaymentNetworkDescription: "Amex",
            cardDescription: "Amex ••••1234",
            email: "",
            phoneNumber: "",
            fullName: "",
            fullPhoneticName: "",
            billingAddress: MockAddress(
                street: "",
                city: "",
                state: "",
                postalCode: "12345",
                countryCode: "US"
            )
        )

        let result = paymentData.toDictionary()

        XCTAssertEqual(result[DataKeys.PaymentDataCardTypeKey] as? String, "amex")
    }

    func testToDictionary_withDiscoverNetwork_returnsDiscover() {
        let paymentData = MockPaymentData(
            token: "token",
            lastFour: "1234",
            paymentNetwork: .discover,
            oloPaymentNetworkDescription: "Discover",
            cardDescription: "Discover ••••1234",
            email: "",
            phoneNumber: "",
            fullName: "",
            fullPhoneticName: "",
            billingAddress: MockAddress(
                street: "",
                city: "",
                state: "",
                postalCode: "12345",
                countryCode: "US"
            )
        )

        let result = paymentData.toDictionary()

        XCTAssertEqual(result[DataKeys.PaymentDataCardTypeKey] as? String, "discover")
    }

    func testToDictionary_withEmptyOptionalFields_hasEmptyStrings() {
        let paymentData = MockPaymentData(
            token: "token",
            lastFour: "1234",
            paymentNetwork: .visa,
            oloPaymentNetworkDescription: "Visa",
            cardDescription: "Visa ••••1234",
            email: "",
            phoneNumber: "",
            fullName: "",
            fullPhoneticName: "",
            billingAddress: MockAddress(
                street: "",
                city: "",
                state: "",
                postalCode: "12345",
                countryCode: "US"
            )
        )

        let result = paymentData.toDictionary()

        XCTAssertEqual(result[DataKeys.PaymentDataEmailKey] as? String, "")
        XCTAssertEqual(result[DataKeys.PaymentDataPhoneNumberKey] as? String, "")
        XCTAssertEqual(result[DataKeys.PaymentDataFullNameKey] as? String, "")
        XCTAssertEqual(result[DataKeys.PaymentDataFullPhoneticNameKey] as? String, "")
    }
}

// MARK: - Mock Payment Data

class MockPaymentData: NSObject, ODWPaymentDataProtocol {
    var token: String
    var lastFour: String
    var paymentNetwork: PKPaymentNetwork?
    var oloPaymentNetworkDescription: String
    var cardDescription: String
    var email: String
    var phoneNumber: String
    var fullName: String
    var fullPhoneticName: String
    var billingAddress: any ODWAddressProtocol

    init(
        token: String,
        lastFour: String,
        paymentNetwork: PKPaymentNetwork?,
        oloPaymentNetworkDescription: String,
        cardDescription: String,
        email: String,
        phoneNumber: String,
        fullName: String,
        fullPhoneticName: String,
        billingAddress: any ODWAddressProtocol
    ) {
        self.token = token
        self.lastFour = lastFour
        self.paymentNetwork = paymentNetwork
        self.oloPaymentNetworkDescription = oloPaymentNetworkDescription
        self.cardDescription = cardDescription
        self.email = email
        self.phoneNumber = phoneNumber
        self.fullName = fullName
        self.fullPhoneticName = fullPhoneticName
        self.billingAddress = billingAddress
        super.init()
    }
}
