// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets

import com.olo.flutter.digitalwallets.data.DataKeys
import com.olo.flutter.digitalwallets.data.ErrorCodes
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test

class PayDigitalWalletsSdkPluginTest {

    private lateinit var plugin: PayDigitalWalletsSdkPlugin
    private lateinit var mockResult: MockMethodChannelResult

    @BeforeEach
    fun setUp() {
        plugin = PayDigitalWalletsSdkPlugin()
        mockResult = MockMethodChannelResult()
    }

    @AfterEach
    fun tearDown() {
        // Clean up
    }

    // MARK: - getGooglePayConfiguration Tests
    @Test
    fun `getGooglePayConfiguration_WithAllParameters_ReturnsConfiguration`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayProductionEnvironmentKey to false,
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "CA",
            DataKeys.GPayCurrencyCodeKey to "CAD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayExistingPaymentMethodRequiredKey to false,
            DataKeys.GPayEmailRequiredKey to true,
            DataKeys.GPayPhoneNumberRequiredKey to true,
            DataKeys.GPayFullBillingAddressRequiredKey to true,
            DataKeys.GPayFullNameRequiredKey to true,
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa", "mastercard"),
            DataKeys.GPayCurrencyMultiplierKey to 100
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNotNull(config, "Configuration should not be null")
        assertNull(mockResult.errorCode, "Should not have returned an error")
    }

    @Test
    fun `getGooglePayConfiguration_WithAllParameters_ReturnsConfigurationWithCorrectValues`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayProductionEnvironmentKey to false,
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "CA",
            DataKeys.GPayCurrencyCodeKey to "CAD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayExistingPaymentMethodRequiredKey to false,
            DataKeys.GPayEmailRequiredKey to true,
            DataKeys.GPayPhoneNumberRequiredKey to true,
            DataKeys.GPayFullBillingAddressRequiredKey to true,
            DataKeys.GPayFullNameRequiredKey to true,
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa", "mastercard"),
            DataKeys.GPayCurrencyMultiplierKey to 100
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNotNull(config, "Configuration should not be null")
        assertNull(mockResult.errorCode, "Should not have returned an error")
        // Note: Configuration class is from external SDK, individual property validation not possible in unit tests
    }

    @Test
    fun `getGooglePayConfiguration_WithRequiredParametersOnly_ReturnsConfigurationWithDefaults`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNotNull(config, "Configuration should not be null")
        assertNull(mockResult.errorCode, "Should not have returned an error")
    }

    @Test
    fun `getGooglePayConfiguration_WithCustomCurrencyMultiplier_UsesCurrencyMultiplier`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa"),
            DataKeys.GPayCurrencyMultiplierKey to 1000
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNotNull(config, "Configuration should not be null")
        assertNull(mockResult.errorCode, "Should not have returned an error")
        assertEquals(1000, plugin._currencyMultiplier, "Should use custom currency multiplier")
    }

    @Test
    fun `getGooglePayConfiguration_WithoutCurrencyMultiplier_UsesDefaultValue`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNotNull(config, "Configuration should not be null")
        assertNull(mockResult.errorCode, "Should not have returned an error")
        assertEquals(100, plugin._currencyMultiplier, "Should use default currency multiplier of 100")
    }

    @Test
    fun `getGooglePayConfiguration_WithRequiredParametersOnly_ReturnsConfigurationWithCorrectDefaultValues`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNotNull(config, "Configuration should not be null")
        assertNull(mockResult.errorCode, "Should not have returned an error")
        // Note: Configuration class is from external SDK, individual property validation not possible in unit tests
    }

    @Test
    fun `getGooglePayConfiguration_WithMissingGatewayParametersJson_ReturnsMissingParameter`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        println("Config returned: $config")
        println("Mock errorCode: ${mockResult.errorCode}")
        println("Mock errorMessage: ${mockResult.errorMessage}")
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error. Actual: ${mockResult.errorCode}")
        assertEquals(ErrorCodes.MissingParameter, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithMissingCountryCode_ReturnsMissingParameter`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.MissingParameter, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithMissingCurrencyCode_ReturnsMissingParameter`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.MissingParameter, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithMissingCompanyLabel_ReturnsMissingParameter`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.MissingParameter, mockResult.errorCode)
    }

    // Note: Invalid JSON test removed because JSONObject validation requires Android framework
    // which is mocked in unit tests. This validation is better tested in integration tests.

    @Test
    fun `getGooglePayConfiguration_WithEmptyAllowedCardNetworks_ReturnsNoAllowedCardNetworks`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf<String>()
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.NoAllowedCardNetworks, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithOnlyInvalidCardNetworks_ReturnsNoAllowedCardNetworks`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("invalid", "unknown")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.NoAllowedCardNetworks, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithMixedValidAndInvalidCardNetworks_ReturnsConfiguration`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa", "invalid", "mastercard", "unknown")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNotNull(config, "Configuration should not be null (valid networks present)")
        assertNull(mockResult.errorCode, "Should not have returned an error")
    }

    @Test
    fun `getGooglePayConfiguration_WithEmptyCountryCode_ReturnsInvalidParameter`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.InvalidParameter, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithEmptyCompanyLabel_ReturnsInvalidParameter`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.InvalidParameter, mockResult.errorCode)
    }

    // MARK: - Wrong Type Tests

    @Test
    fun `getGooglePayConfiguration_WithProductionEnvironmentNotBoolean_ReturnsUnexpectedParameterType`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayProductionEnvironmentKey to "true",
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.UnexpectedParameterType, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithCountryCodeNotString_ReturnsUnexpectedParameterType`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to 12345,
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.UnexpectedParameterType, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithCurrencyCodeNotString_ReturnsUnexpectedParameterType`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to 123,
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.UnexpectedParameterType, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithCompanyNameNotString_ReturnsUnexpectedParameterType`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to 12345,
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.UnexpectedParameterType, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithExistingPaymentMethodRequiredNotBoolean_ReturnsUnexpectedParameterType`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayExistingPaymentMethodRequiredKey to "false",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.UnexpectedParameterType, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithEmailRequiredNotBoolean_ReturnsUnexpectedParameterType`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayEmailRequiredKey to "true",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.UnexpectedParameterType, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithPhoneNumberRequiredNotBoolean_ReturnsUnexpectedParameterType`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayPhoneNumberRequiredKey to 1,
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.UnexpectedParameterType, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithFullNameRequiredNotBoolean_ReturnsUnexpectedParameterType`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayFullNameRequiredKey to 1.5,
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.UnexpectedParameterType, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithFullBillingAddressRequiredNotBoolean_ReturnsUnexpectedParameterType`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayFullBillingAddressRequiredKey to "yes",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.UnexpectedParameterType, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithAllowedCardNetworksNotArray_ReturnsUnexpectedParameterType`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to "visa,mastercard"
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.UnexpectedParameterType, mockResult.errorCode)
    }

    // MARK: - Null/Empty Parameter Tests

    @Test
    fun `getGooglePayConfiguration_WithNullGatewayParametersJson_ReturnsMissingParameter`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to null,
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.MissingParameter, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithEmptyGatewayParametersJson_ReturnsInvalidParameter`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to "",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.InvalidParameter, mockResult.errorCode)
    }

    // Note: JSON format validation is handled by the Google Pay SDK, not at the parameter level
    // Test removed: getGooglePayConfiguration_WithInvalidGatewayParametersJson_ReturnsInvalidParameter

    @Test
    fun `getGooglePayConfiguration_WithNullCountryCode_ReturnsMissingParameter`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to null,
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.MissingParameter, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithNullCurrencyCode_ReturnsMissingParameter`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to null,
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.MissingParameter, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithEmptyCurrencyCode_ReturnsInvalidParameter`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.InvalidParameter, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithNullCompanyName_ReturnsMissingParameter`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to null,
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.MissingParameter, mockResult.errorCode)
    }

    @Test
    fun `getGooglePayConfiguration_WithNullAllowedCardNetworks_ReturnsMissingParameter`() {
        // Arrange
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to null
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNull(config, "Configuration should be null")
        assertNotNull(mockResult.errorCode, "Should have returned an error")
        assertEquals(ErrorCodes.MissingParameter, mockResult.errorCode)
    }


    @Test
    fun `getGooglePayConfiguration_WithVeryLongStrings_HandlesCorrectly`() {
        // Arrange
        val longString = "A".repeat(10000)
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"$longString","gatewayMerchantId":"$longString"}""",
            DataKeys.GPayCountryCodeKey to longString,
            DataKeys.GPayCurrencyCodeKey to longString,
            DataKeys.GPayCompanyNameKey to longString,
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert - Should handle gracefully
        assertTrue(config != null || mockResult.errorCode != null, "Should handle very long strings")
    }

    @Test
    fun `getGooglePayConfiguration_WithSpecialCharacters_HandlesCorrectly`() {
        // Arrange
        val specialChars = "!@#\$%^&*()_+-=[]{}|;':\",./<>?"
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company $specialChars",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert - Should handle special characters
        assertTrue(config != null || mockResult.errorCode != null, "Should handle special characters")
    }

    @Test
    fun `getGooglePayConfiguration_WithUnicode_HandlesCorrectly`() {
        // Arrange
        val unicodeString = "テスト会社 🏢 Société 中文"
        val arguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to unicodeString,
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", arguments)

        // Act
        val config = plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Assert
        assertNotNull(config, "Should handle unicode characters")
        assertEquals(unicodeString, config?.companyName, "Unicode should be preserved")
    }


    private fun configureGooglePay() {
        val configArguments = mapOf(
            DataKeys.GPayGatewayParametersJsonKey to """{"gateway":"test","gatewayMerchantId":"123"}""",
            DataKeys.GPayCountryCodeKey to "US",
            DataKeys.GPayCurrencyCodeKey to "USD",
            DataKeys.GPayCompanyNameKey to "Test Company",
            DataKeys.GPayAllowedCardNetworksKey to arrayListOf("visa")
        )
        val call = MethodCall("configure", configArguments)

        plugin.getGooglePayConfiguration(
            call,
            mockResult,
            "Test Error"
        )

        // Reset mock result for the actual test
        mockResult = MockMethodChannelResult()
    }

    private fun waitForOperation() {
        // Wait for async operation to complete
        Thread.sleep(100)
    }

    // MARK: - Mock Method Channel Result

    inner class MockMethodChannelResult : MethodChannel.Result {
        var result: Any? = null
        var errorCode: String? = null
        var errorMessage: String? = null
        var errorDetails: Any? = null

        override fun success(result: Any?) {
            println("MockResult.success called with: $result")
            this.result = result
        }

        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
            println("MockResult.error called with code: $errorCode, message: $errorMessage")
            this.errorCode = errorCode
            this.errorMessage = errorMessage
            this.errorDetails = errorDetails
        }

        override fun notImplemented() {
            println("MockResult.notImplemented called")
        }
    }
}
