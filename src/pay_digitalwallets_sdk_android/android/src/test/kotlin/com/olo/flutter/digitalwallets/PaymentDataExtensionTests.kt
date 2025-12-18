// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets

import com.olo.flutter.digitalwallets.extensions.toMap
import com.olo.pay.digitalwalletssdk.data.Address
import com.olo.pay.digitalwalletssdk.data.CardType
import com.olo.pay.digitalwalletssdk.data.PaymentData
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Test

class PaymentDataExtensionTests {
    @Test
    fun toMap_hasCorrectLength() {
        assertEquals(10, mockPaymentData.toMap().size)
    }

    @Test
    fun toMap_hasCorrectKeys() {
        val map = mockPaymentData.toMap()

        assertNotNull(map["token"])
        assertNotNull(map["description"])
        assertNotNull(map["oloCardTypeDescription"])
        assertNotNull(map["cardType"])
        assertNotNull(map["cardDetails"])
        assertNotNull(map["lastFour"])
        assertNotNull(map["billingAddress"])
        assertNotNull(map["email"])
        assertNotNull(map["fullName"])
        assertNotNull(map["phoneNumber"])
    }

    @Test
    fun toMap_hasCorrectValues() {
        val map = mockPaymentData.toMap()

        assertEquals("test_token_1234", map["token"])
        assertEquals("Visa ••••1234", map["description"])
        assertEquals("Visa", map["oloCardTypeDescription"])
        assertEquals("visa", map["cardType"])
        assertEquals("1234", map["cardDetails"])
        assertEquals("1234", map["lastFour"])
        assertEquals("test@example.com", map["email"])
        assertEquals("John Doe", map["fullName"])
        assertEquals("5551234567", map["phoneNumber"])

        @Suppress("UNCHECKED_CAST")
        val billingAddress = map["billingAddress"] as? Map<String, Any>
        assertNotNull(billingAddress)
        assertEquals("12345", billingAddress!!["postalCode"])
        assertEquals("US", billingAddress["countryCode"])
    }

    companion object {
        val mockPaymentData = PaymentData(
            token = "test_token_1234",
            description = "Visa ••••1234",
            cardType = CardType.Visa,
            oloCardTypeDescription = "Visa",
            cardDetails = "1234",
            lastFour = "1234",
            billingAddress = Address(
                postalCode = "12345",
                countryCode = "US"
            ),
            email = "test@example.com",
            fullName = "John Doe",
            phoneNumber = "5551234567"
        )
    }
}
