// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import XCTest
import Flutter
@testable import pay_digitalwallets_sdk_ios
@testable import OloDigitalWalletsSDK

class PayDigitalWalletsSdkPluginTests: XCTestCase {
    // IMPORTANT: Using expectations makes debugging difficult due to the
    // wait(for:timeout:) call. When debugging and stepping through
    // code, it may be necessary to set the timeout value to something
    // much larger to allow time to step through the code.
    //
    // NOTE: The value of 180 may seem excessive when not debugging, but
    // is needed due to attempt preventing flaky test results in Github Actions.
    // The first time the SDK is initialized by a test it has taken up to
    // 150 seconds to complete. All subsequent initializations are much faster
    // We really need to look into why this is happening
    let expectationTimeout: TimeInterval = 180

    var plugin: PayDigitalWalletsSdkPlugin!
    var mockResult: MockFlutterResult!

    override func setUp() {
        super.setUp()
        plugin = PayDigitalWalletsSdkPlugin()
        plugin._isUnitTestMode = true
        mockResult = MockFlutterResult()
    }

    override func tearDown() {
        plugin = nil
        mockResult = nil
        super.tearDown()
    }

    // MARK: - configure Tests

    func testConfigure_WithAllParameters_ReturnsSuccess() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletFullBillingAddressRequired: true,
            DataKeys.DigitalWalletFullNameRequired: true,
            DataKeys.DigitalWalletPhoneNumberRequired: true,
            DataKeys.DigitalWalletEmailRequired: true,
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa", "mastercard"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            XCTAssertNil(result)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithRequiredParametersOnly_ReturnsSuccess() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            XCTAssertNil(result)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    // MARK: - configure Missing Parameter Tests

    func testConfigure_WithMissingMerchantId_ReturnsMissingParameter() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.MissingParameter)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithMissingCountryCode_ReturnsMissingParameter() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.MissingParameter)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithMissingCurrencyCode_ReturnsMissingParameter() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.MissingParameter)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithMissingCompanyLabel_ReturnsMissingParameter() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.MissingParameter)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    // MARK: - configure Empty/Invalid Parameter Tests

    func testConfigure_WithEmptyMerchantId_ReturnsInvalidParameter() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.InvalidParameter)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithEmptyCountryCode_ReturnsInvalidParameter() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.InvalidParameter)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithEmptyCurrencyCode_ReturnsInvalidParameter() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.InvalidParameter)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithEmptyCompanyLabel_ReturnsInvalidParameter() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.InvalidParameter)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithEmptyAllowedCardNetworks_ReturnsNoAllowedPaymentNetworks() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: []
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.NoAllowedPaymentNetworks)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithOnlyInvalidCardNetworks_ReturnsNoAllowedPaymentNetworks() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["invalid", "unknown"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.NoAllowedPaymentNetworks)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithInvalidCurrencyCodeLength_ReturnsInvalidCurrencyCodeError() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "US", // 2 characters instead of 3
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.InvalidCurrencyCode)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithInvalidCountryCodeLength_ReturnsInvalidCountryCodeError() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "USA", // 3 characters instead of 2
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.InvalidCountryCode)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    // MARK: - configure Wrong Type Tests

    func testConfigure_WithMerchantIdNotString_ReturnsUnexpectedParameterType() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: 12345,
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithCountryCodeNotString_ReturnsUnexpectedParameterType() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: 12345,
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithCurrencyCodeNotString_ReturnsUnexpectedParameterType() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: 123,
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithCompanyLabelNotString_ReturnsUnexpectedParameterType() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: false,
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithEmailRequiredNotBoolean_ReturnsUnexpectedParameterType() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletEmailRequired: "true",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithPhoneNumberRequiredNotBoolean_ReturnsUnexpectedParameterType() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletPhoneNumberRequired: "false",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithFullNameRequiredNotBoolean_ReturnsUnexpectedParameterType() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletFullNameRequired: 1.5,
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithFullBillingAddressRequiredNotBoolean_ReturnsUnexpectedParameterType() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletFullBillingAddressRequired: "yes",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testConfigure_WithAllowedCardNetworksNotArray_ReturnsUnexpectedParameterType() {
        let expectation = expectation(description: "configure completion")
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: "visa,mastercard"
        ]
        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    // MARK: - getApplePayConfig Tests

    func testGetApplePayConfig_WithAllParameters_ReturnsConfiguration() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "CA",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "CAD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletFullBillingAddressRequired: true,
            DataKeys.DigitalWalletFullNameRequired: true,
            DataKeys.DigitalWalletPhoneNumberRequired: true,
            DataKeys.DigitalWalletEmailRequired: true,
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa", "mastercard"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNotNil(config, "Configuration should not be nil")
        XCTAssertNil(mockResult.error, "Should not have returned an error")
    }

    func testGetApplePayConfig_WithAllParameters_ReturnsConfigurationWithCorrectValues() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "CA",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "CAD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletFullBillingAddressRequired: true,
            DataKeys.DigitalWalletFullNameRequired: true,
            DataKeys.DigitalWalletPhoneNumberRequired: true,
            DataKeys.DigitalWalletFullPhoneticNameRequired: true,
            DataKeys.DigitalWalletEmailRequired: true,
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa", "mastercard"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNotNil(config, "Configuration should not be nil")
        XCTAssertNil(mockResult.error, "Should not have returned an error")

        // Verify all values are set correctly
        XCTAssertEqual(config?.merchantId, "merchant.com.test", "Merchant ID should match")
        XCTAssertEqual(config?.countryCode, "CA", "Country code should match")
        XCTAssertEqual(config?.currencyCode, "CAD", "Currency code should match")
        XCTAssertEqual(config?.companyLabel, "Test Company", "Company label should match")
        XCTAssertTrue(config?.fullBillingAddressRequired ?? false, "Full billing address should be required")
        XCTAssertTrue(config?.fullNameRequired ?? false, "Full name should be required")
        XCTAssertTrue(config?.phoneNumberRequired ?? false, "Phone number should be required")
        XCTAssertTrue(config?.fullPhoneticNameRequired ?? false, "Full phonetic name should be required")
        XCTAssertTrue(config?.emailRequired ?? false, "Email should be required")
        XCTAssertEqual(config?.allowedCardNetworks.count, 2, "Should have 2 allowed card networks")
        XCTAssertTrue(config?.allowedCardNetworks.contains(.visa) ?? false, "Should contain Visa")
        XCTAssertTrue(config?.allowedCardNetworks.contains(.masterCard) ?? false, "Should contain MasterCard")
    }

    func testGetApplePayConfig_WithRequiredParametersOnly_ReturnsConfigurationWithDefaults() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNotNil(config, "Configuration should not be nil")
        XCTAssertNil(mockResult.error, "Should not have returned an error")
    }

    func testGetApplePayConfig_WithRequiredParametersOnly_ReturnsConfigurationWithCorrectDefaultValues() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNotNil(config, "Configuration should not be nil")
        XCTAssertNil(mockResult.error, "Should not have returned an error")

        // Verify required values are set correctly
        XCTAssertEqual(config?.merchantId, "merchant.com.test", "Merchant ID should match")
        XCTAssertEqual(config?.countryCode, "US", "Country code should match")
        XCTAssertEqual(config?.currencyCode, "USD", "Currency code should match")
        XCTAssertEqual(config?.companyLabel, "Test Company", "Company label should match")

        // Verify optional boolean fields default to false
        XCTAssertFalse(config?.fullBillingAddressRequired ?? true, "Full billing address should default to false")
        XCTAssertFalse(config?.fullNameRequired ?? true, "Full name should default to false")
        XCTAssertFalse(config?.phoneNumberRequired ?? true, "Phone number should default to false")
        XCTAssertFalse(config?.fullPhoneticNameRequired ?? true, "Full phonetic name should default to false")
        XCTAssertFalse(config?.emailRequired ?? true, "Email should default to false")

        // Verify single network in allowedCardNetworks
        XCTAssertEqual(config?.allowedCardNetworks.count, 1, "Should have 1 allowed card network")
        XCTAssertTrue(config?.allowedCardNetworks.contains(.visa) ?? false, "Should contain Visa")
    }

    func testGetApplePayConfig_WithMissingMerchantId_ReturnsMissingParameter() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.MissingParameter)
    }

    func testGetApplePayConfig_WithMissingCountryCode_ReturnsMissingParameter() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.MissingParameter)
    }

    func testGetApplePayConfig_WithMissingCurrencyCode_ReturnsMissingParameter() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.MissingParameter)
    }

    func testGetApplePayConfig_WithMissingCompanyLabel_ReturnsMissingParameter() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.MissingParameter)
    }

    func testGetApplePayConfig_WithEmptyAllowedCardNetworks_ReturnsNoAllowedCardNetworks() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: []
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.NoAllowedPaymentNetworks)
    }

    func testGetApplePayConfig_WithOnlyInvalidCardNetworks_ReturnsNoAllowedCardNetworks() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["invalid", "unknown"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.NoAllowedPaymentNetworks)
    }

    func testGetApplePayConfig_WithMixedValidAndInvalidCardNetworks_ReturnsConfiguration() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa", "invalid", "mastercard", "unknown"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNotNil(config, "Configuration should not be nil (valid networks present)")
        XCTAssertNil(mockResult.error, "Should not have returned an error")
    }

    func testGetApplePayConfig_WithEmptyCountryCode_ReturnsInvalidParameter() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.InvalidParameter)
    }

    func testGetApplePayConfig_WithEmptyCompanyLabel_ReturnsInvalidParameter() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.InvalidParameter)
    }

    // MARK: - Wrong Type Tests

    func testGetApplePayConfig_WithMerchantIdNotString_ReturnsUnexpectedParameterType() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: 12345,
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.UnexpectedParameterType)
    }

    func testGetApplePayConfig_WithCountryCodeNotString_ReturnsUnexpectedParameterType() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: 12345,
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.UnexpectedParameterType)
    }

    func testGetApplePayConfig_WithCurrencyCodeNotString_ReturnsUnexpectedParameterType() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: 123,
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.UnexpectedParameterType)
    }

    func testGetApplePayConfig_WithCompanyLabelNotString_ReturnsUnexpectedParameterType() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: false,
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.UnexpectedParameterType)
    }

    func testGetApplePayConfig_WithEmailRequiredNotBoolean_ReturnsUnexpectedParameterType() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletEmailRequired: "true",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.UnexpectedParameterType)
    }

    func testGetApplePayConfig_WithPhoneNumberRequiredNotBoolean_ReturnsUnexpectedParameterType() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletPhoneNumberRequired: "false",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.UnexpectedParameterType)
    }

    func testGetApplePayConfig_WithFullNameRequiredNotBoolean_ReturnsUnexpectedParameterType() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletFullNameRequired: 1,
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.UnexpectedParameterType)
    }

    func testGetApplePayConfig_WithFullPhoneticNameRequiredNotBoolean_ReturnsUnexpectedParameterType() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletFullPhoneticNameRequired: 1.5,
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.UnexpectedParameterType)
    }

    func testGetApplePayConfig_WithFullBillingAddressRequiredNotBoolean_ReturnsUnexpectedParameterType() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletFullBillingAddressRequired: "yes",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.UnexpectedParameterType)
    }

    func testGetApplePayConfig_WithAllowedCardNetworksNotArray_ReturnsUnexpectedParameterType() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: "visa,mastercard"
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.UnexpectedParameterType)
    }

    // MARK: - Nil/Empty Parameter Tests

    // Note: In Swift, setting a dictionary value to nil removes the key from the dictionary,
    // so nil tests are functionally equivalent to missing parameter tests

    func testGetApplePayConfig_WithEmptyMerchantId_ReturnsInvalidParameter() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.InvalidParameter)
    }

    func testGetApplePayConfig_WithEmptyCurrencyCode_ReturnsInvalidParameter() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.InvalidParameter)
    }

    func testGetApplePayConfig_WithInvalidCurrencyCodeLength_ReturnsInvalidCurrencyCodeError() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "US", // 2 characters instead of 3
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.InvalidCurrencyCode)
    }

    func testGetApplePayConfig_WithInvalidCountryCodeLength_ReturnsInvalidCountryCodeError() {
        // Arrange
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "USA", // 3 characters instead of 2
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNil(config, "Configuration should be nil")
        XCTAssertNotNil(mockResult.error, "Should have returned an error")
        XCTAssertEqual(mockResult.error?.code, ErrorCodes.InvalidCountryCode)
    }

    // MARK: - getPaymentData Tests

    func testGetPaymentData_NotConfigured_ReturnsSdkNotConfiguredError() {
        let expectation = expectation(description: "getPaymentData completion")
        let arguments: [String: Any] = [
            DataKeys.DigitalWalletAmountParameterKey: "10.50",
            DataKeys.DigitalWalletValidateLineItemsKey: false
        ]
        let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

        plugin.handle(call) { result in
            if let error = result as? FlutterError {
                XCTAssertEqual(error.code, ErrorCodes.SdkNotConfigured)
            } else {
                XCTFail("Expected error result")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithNegativeAmount_ReturnsInvalidParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "-10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.InvalidParameter, "Should return InvalidParameter for negative amount")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'amount' cannot be negative", "Error message should match exactly")
                } else {
                    XCTFail("Expected InvalidParameter error for negative amount")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithNilArguments_ReturnsMissingParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: nil)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.MissingParameter, "Should return MissingParameter for nil arguments")
                    XCTAssertEqual(error.message, "Unable to get payment data: Missing parameter amount", "Error message should match exactly")
                } else {
                    XCTFail("Expected MissingParameter error for nil arguments")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithMissingAmount_ReturnsMissingParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletValidateLineItemsKey: false
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.MissingParameter, "Should return MissingParameter for missing amount")
                    XCTAssertEqual(error.message, "Unable to get payment data: Missing parameter 'amount'", "Error message should match exactly")
                } else {
                    XCTFail("Expected MissingParameter error for missing amount")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithNilAmount_ReturnsMissingParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any?] = [
                DataKeys.DigitalWalletAmountParameterKey: nil,
                DataKeys.DigitalWalletValidateLineItemsKey: false
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.MissingParameter, "Should return MissingParameter for nil amount")
                    XCTAssertEqual(error.message, "Unable to get payment data: Missing parameter 'amount'", "Error message should match exactly")
                } else {
                    XCTFail("Expected MissingParameter error for nil amount")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithAmountWrongType_ReturnsUnexpectedParameterTypeError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: 10.50,
                DataKeys.DigitalWalletValidateLineItemsKey: false
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType, "Should return UnexpectedParameterType for Double amount")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'amount' is not of type String", "Error message should match exactly")
                } else {
                    XCTFail("Expected UnexpectedParameterType error for Double amount")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithAmountBoolType_ReturnsUnexpectedParameterTypeError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: true,
                DataKeys.DigitalWalletValidateLineItemsKey: false
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType, "Should return UnexpectedParameterType for Bool amount")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'amount' is not of type String", "Error message should match exactly")
                } else {
                    XCTFail("Expected UnexpectedParameterType error for Bool amount")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithEmptyAmountString_ReturnsInvalidParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "",
                DataKeys.DigitalWalletValidateLineItemsKey: false
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.InvalidParameter, "Should return InvalidParameter for empty amount string")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'amount' cannot be empty", "Error message should match exactly")
                } else {
                    XCTFail("Expected InvalidParameter error for empty amount string")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithWhitespaceAmount_ReturnsInvalidParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "   ",
                DataKeys.DigitalWalletValidateLineItemsKey: false
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.InvalidParameter, "Should return InvalidParameter for whitespace amount")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'amount' cannot be empty", "Error message should match exactly")
                } else {
                    XCTFail("Expected InvalidParameter error for whitespace amount")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithInvalidAmountFormat_ReturnsInvalidParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "abc",
                DataKeys.DigitalWalletValidateLineItemsKey: false
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.InvalidParameter, "Should return InvalidParameter for non-numeric amount")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'amount' is not a valid number", "Error message should match exactly")
                } else {
                    XCTFail("Expected InvalidParameter error for non-numeric amount")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithInvalidAmountFormatMultipleDecimals_ReturnsInvalidParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50.25",
                DataKeys.DigitalWalletValidateLineItemsKey: false
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.InvalidParameter, "Should return InvalidParameter for malformed amount")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'amount' is not a valid number", "Error message should match exactly")
                } else {
                    XCTFail("Expected InvalidParameter error for malformed amount")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithSpecialCharacterAmount_ReturnsInvalidParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "$10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.InvalidParameter, "Should return InvalidParameter for amount with currency symbol")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'amount' is not a valid number", "Error message should match exactly")
                } else {
                    XCTFail("Expected InvalidParameter error for amount with currency symbol")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    // Validates that when all guard checks pass, getPaymentData() will indeed present the apple pay sheet when
    // not in test mode
    func testGetPaymentData_WithValidParameters_InUnitTestMode_ReturnsApplePayUnitTestModeError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, "ApplePayUnitTestModeError", "Should return ApplePayUnitTestModeError in unit test mode")
                    XCTAssertEqual(error.message, "Apple Pay is not supported in unit test mode", "Error message should match exactly")
                } else {
                    XCTFail("Expected ApplePayUnitTestModeError when all validation passes but in unit test mode")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    // MARK: ValidateLineItems Parameter Tests

    func testGetPaymentData_WithMissingValidateLineItems_ReturnsMissingParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50"
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.MissingParameter, "Should return MissingParameter for missing validateLineItems")
                    XCTAssertEqual(error.message, "Unable to get payment data: Missing parameter 'validateLineItems'", "Error message should match exactly")
                } else {
                    XCTFail("Expected MissingParameter error for missing validateLineItems")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithNilValidateLineItems_ReturnsMissingParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any?] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: nil
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.MissingParameter, "Should return MissingParameter for nil validateLineItems")
                    XCTAssertEqual(error.message, "Unable to get payment data: Missing parameter 'validateLineItems'", "Error message should match exactly")
                } else {
                    XCTFail("Expected MissingParameter error for nil validateLineItems")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithValidateLineItemsWrongType_ReturnsUnexpectedParameterTypeError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: "false"
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType, "Should return UnexpectedParameterType for String validateLineItems")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'validateLineItems' is not of type Bool", "Error message should match exactly")
                } else {
                    XCTFail("Expected UnexpectedParameterType error for String validateLineItems")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithValidateLineItemsIntType_ReturnsUnexpectedParameterTypeError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: 1
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType, "Should return UnexpectedParameterType for Int validateLineItems")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'validateLineItems' is not of type Bool", "Error message should match exactly")
                } else {
                    XCTFail("Expected UnexpectedParameterType error for Int validateLineItems")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    // MARK: LineItems Array Validation Tests

    func testGetPaymentData_WithLineItemsWrongType_ReturnsUnexpectedParameterTypeError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false,
                DataKeys.DigitalWalletLineItemsKey: "not an array"
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType, "Should return UnexpectedParameterType for String lineItems")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'lineItems' is not of type Optional<Array<Dictionary<String, Optional<Any>>>>", "Error message should match exactly")
                } else {
                    XCTFail("Expected UnexpectedParameterType error for String lineItems")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithLineItemsWrongArrayType_ReturnsUnexpectedParameterTypeError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false,
                DataKeys.DigitalWalletLineItemsKey: ["string1", "string2"]
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType, "Should return UnexpectedParameterType for array of strings")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'lineItems' is not of type Optional<Array<Dictionary<String, Optional<Any>>>>", "Error message should match exactly")
                } else {
                    XCTFail("Expected UnexpectedParameterType error for array of strings")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    // MARK: Line Item Field Validation Tests - Amount

    func testGetPaymentData_WithLineItemAmountMissing_ReturnsMissingParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let lineItem: [String: Any] = [
                DataKeys.DigitalWalletLineItemLabelKey: "Test Item",
                DataKeys.DigitalWalletLineItemStatusKey: "Final"
            ]
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false,
                DataKeys.DigitalWalletLineItemsKey: [lineItem]
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.MissingParameter, "Should return MissingParameter for missing lineItemAmount")
                    XCTAssertEqual(error.message, "Unable to get payment data: Missing parameter 'lineItemAmount'", "Error message should match exactly")
                } else {
                    XCTFail("Expected MissingParameter error for missing lineItemAmount")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithLineItemAmountNil_ReturnsMissingParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let lineItem: [String: Any?] = [
                DataKeys.DigitalWalletLineItemAmountKey: NSNull(),
                DataKeys.DigitalWalletLineItemLabelKey: "Test Item",
                DataKeys.DigitalWalletLineItemStatusKey: "Final"
            ]
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false,
                DataKeys.DigitalWalletLineItemsKey: [lineItem]
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.MissingParameter, "Should return MissingParameter for nil lineItemAmount")
                    XCTAssertEqual(error.message, "Unable to get payment data: Missing parameter 'lineItemAmount'", "Error message should match exactly")
                } else {
                    XCTFail("Expected MissingParameter error for nil lineItemAmount")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithLineItemAmountWrongType_ReturnsUnexpectedParameterTypeError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let lineItem: [String: Any] = [
                DataKeys.DigitalWalletLineItemAmountKey: 5.50,
                DataKeys.DigitalWalletLineItemLabelKey: "Test Item",
                DataKeys.DigitalWalletLineItemStatusKey: "Final"
            ]
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false,
                DataKeys.DigitalWalletLineItemsKey: [lineItem]
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType, "Should return UnexpectedParameterType for Double lineItemAmount")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'lineItemAmount' is not of type String", "Error message should match exactly")
                } else {
                    XCTFail("Expected UnexpectedParameterType error for Double lineItemAmount")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithLineItemAmountInvalidFormat_ReturnsInvalidParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let lineItem: [String: Any] = [
                DataKeys.DigitalWalletLineItemAmountKey: "not-a-number",
                DataKeys.DigitalWalletLineItemLabelKey: "Test Item",
                DataKeys.DigitalWalletLineItemStatusKey: "Final"
            ]
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false,
                DataKeys.DigitalWalletLineItemsKey: [lineItem]
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.InvalidParameter, "Should return InvalidParameter for non-numeric lineItemAmount")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'lineItemAmount' is not a valid number", "Error message should match exactly")
                } else {
                    XCTFail("Expected InvalidParameter error for non-numeric lineItemAmount")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithLineItemAmountEmpty_ReturnsInvalidParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let lineItem: [String: Any] = [
                DataKeys.DigitalWalletLineItemAmountKey: "",
                DataKeys.DigitalWalletLineItemLabelKey: "Test Item",
                DataKeys.DigitalWalletLineItemStatusKey: "Final"
            ]
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false,
                DataKeys.DigitalWalletLineItemsKey: [lineItem]
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.InvalidParameter, "Should return InvalidParameter for empty lineItemAmount")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'lineItemAmount' cannot be empty", "Error message should match exactly")
                } else {
                    XCTFail("Expected InvalidParameter error for empty lineItemAmount")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    // MARK: Line Item Field Validation Tests - Label

    func testGetPaymentData_WithLineItemLabelMissing_ReturnsMissingParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let lineItem: [String: Any] = [
                DataKeys.DigitalWalletLineItemAmountKey: "5.50",
                DataKeys.DigitalWalletLineItemStatusKey: "Final"
            ]
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false,
                DataKeys.DigitalWalletLineItemsKey: [lineItem]
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.MissingParameter, "Should return MissingParameter for missing lineItemLabel")
                    XCTAssertEqual(error.message, "Unable to get payment data: Missing parameter 'lineItemLabel'", "Error message should match exactly")
                } else {
                    XCTFail("Expected MissingParameter error for missing lineItemLabel")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithLineItemLabelNil_ReturnsMissingParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let lineItem: [String: Any?] = [
                DataKeys.DigitalWalletLineItemAmountKey: "5.50",
                DataKeys.DigitalWalletLineItemLabelKey: NSNull(),
                DataKeys.DigitalWalletLineItemStatusKey: "Final"
            ]
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false,
                DataKeys.DigitalWalletLineItemsKey: [lineItem]
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.MissingParameter, "Should return MissingParameter for nil lineItemLabel")
                    XCTAssertEqual(error.message, "Unable to get payment data: Missing parameter 'lineItemLabel'", "Error message should match exactly")
                } else {
                    XCTFail("Expected MissingParameter error for nil lineItemLabel")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithLineItemLabelWrongType_ReturnsUnexpectedParameterTypeError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let lineItem: [String: Any] = [
                DataKeys.DigitalWalletLineItemAmountKey: "5.50",
                DataKeys.DigitalWalletLineItemLabelKey: 123,
                DataKeys.DigitalWalletLineItemStatusKey: "Final"
            ]
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false,
                DataKeys.DigitalWalletLineItemsKey: [lineItem]
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType, "Should return UnexpectedParameterType for Int lineItemLabel")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'lineItemLabel' is not of type String", "Error message should match exactly")
                } else {
                    XCTFail("Expected UnexpectedParameterType error for Int lineItemLabel")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    func testGetPaymentData_WithLineItemLabelEmpty_ReturnsInvalidParameterError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let lineItem: [String: Any] = [
                DataKeys.DigitalWalletLineItemAmountKey: "5.50",
                DataKeys.DigitalWalletLineItemLabelKey: "",
                DataKeys.DigitalWalletLineItemStatusKey: "Final"
            ]
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false,
                DataKeys.DigitalWalletLineItemsKey: [lineItem]
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.InvalidParameter, "Should return InvalidParameter for empty lineItemLabel")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'lineItemLabel' cannot be empty", "Error message should match exactly")
                } else {
                    XCTFail("Expected InvalidParameter error for empty lineItemLabel")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    // MARK: Line Item Field Validation Tests - Status

    func testGetPaymentData_WithLineItemStatusWrongType_ReturnsUnexpectedParameterTypeError() {
        let expectation = expectation(description: "getPaymentData completion")

        configureApplePay() {
            let lineItem: [String: Any] = [
                DataKeys.DigitalWalletLineItemAmountKey: "5.50",
                DataKeys.DigitalWalletLineItemLabelKey: "Test Item",
                DataKeys.DigitalWalletLineItemStatusKey: 123
            ]
            let arguments: [String: Any] = [
                DataKeys.DigitalWalletAmountParameterKey: "10.50",
                DataKeys.DigitalWalletValidateLineItemsKey: false,
                DataKeys.DigitalWalletLineItemsKey: [lineItem]
            ]
            let call = FlutterMethodCall(methodName: DataKeys.GetPaymentDataMethodKey, arguments: arguments)

            self.plugin.handle(call) { result in
                if let error = result as? FlutterError {
                    XCTAssertEqual(error.code, ErrorCodes.UnexpectedParameterType, "Should return UnexpectedParameterType for Int lineItemStatus")
                    XCTAssertEqual(error.message, "Unable to get payment data: Value for 'lineItemStatus' is not of type String", "Error message should match exactly")
                } else {
                    XCTFail("Expected UnexpectedParameterType error for Int lineItemStatus")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: expectationTimeout)
    }

    // MARK: - Edge Case Tests

    func testGetApplePayConfig_WithVeryLongStrings_HandlesCorrectly() {
        // Arrange
        let longString = String(repeating: "A", count: 10000)
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: longString,
            DataKeys.DigitalWalletCountryCodeParameterKey: longString,
            DataKeys.DigitalWalletCurrencyCodeParameterKey: longString,
            DataKeys.ApplePayCompanyLabelParameterKey: longString,
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert - Should handle gracefully (either succeed or return appropriate error)
        // Configuration may be nil or not nil depending on validation rules
        XCTAssertTrue(config != nil || mockResult.error != nil, "Should handle very long strings")
    }

    func testGetApplePayConfig_WithSpecialCharacters_HandlesCorrectly() {
        // Arrange
        let specialChars = "!@#$%^&*()_+-=[]{}|;':\",./<>?"
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.\(specialChars)",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company \(specialChars)",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert - Should handle special characters
        XCTAssertTrue(config != nil || mockResult.error != nil, "Should handle special characters")
    }

    func testGetApplePayConfig_WithUnicode_HandlesCorrectly() {
        // Arrange
        let unicodeString = "テスト会社 🏢 Société 中文"
        let arguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: unicodeString,
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Act
        let config = plugin.getApplePayConfig(
            args: arguments,
            result: mockResult.flutterResult,
            baseError: "Test Error"
        )

        // Assert
        XCTAssertNotNil(config, "Should handle unicode characters")
        XCTAssertEqual(config?.companyLabel, unicodeString, "Unicode should be preserved")
    }

    // MARK: - Helper Methods

    private func configureApplePay(
        with args: [String: Any?] = [:],
        completion: @escaping () -> Void
    ) {
        var configArguments: [String: Any?] = [
            DataKeys.ApplePayMerchantIdParameterKey: "merchant.com.test",
            DataKeys.DigitalWalletCountryCodeParameterKey: "US",
            DataKeys.DigitalWalletCurrencyCodeParameterKey: "USD",
            DataKeys.ApplePayCompanyLabelParameterKey: "Test Company",
            DataKeys.DigitalWalletAllowedCardNetworksParameterKey: ["visa"]
        ]

        // Merge custom arguments
        for (key, value) in args {
            configArguments[key] = value
        }
        
        let expectation = expectation(description: "configure apple pay completion")

        let call = FlutterMethodCall(methodName: DataKeys.ConfigureMethodKey, arguments: configArguments)
        plugin.handle(call) { result in
            XCTAssertNil(result, "Configuration result should be nil")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: expectationTimeout)
        completion()

    }

    // MARK: - Mock Flutter Result

    class MockFlutterResult {
        var result: Any?
        var error: FlutterErrorDetails?

        lazy var flutterResult: FlutterResult = { [weak self] (result: Any?) -> Void in
            guard let self = self else { return }

            if let error = result as? FlutterError {
                self.error = FlutterErrorDetails(
                    code: error.code,
                    message: error.message,
                    details: error.details
                )
            } else {
                self.result = result
            }
        }

        struct FlutterErrorDetails {
            let code: String
            let message: String?
            let details: Any?
        }
    }
}
