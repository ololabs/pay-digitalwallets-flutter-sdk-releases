// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets

import com.olo.flutter.digitalwallets.extensions.toMap
import com.olo.pay.digitalwalletssdk.data.ErrorType
import com.olo.pay.digitalwalletssdk.exceptions.GooglePayException
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Test
import kotlin.Exception

class GooglePayExceptionExtensionTests {
    @Test
    fun toMap_hasCorrectLength() {
        val map = GooglePayException(
            throwable = Exception("message"),
            errorType = ErrorType.Internal,
        ).toMap()

        assertEquals(3, map.size)
    }

    @Test
    fun toMap_hasCorrectKeys() {
        val map = GooglePayException(
            throwable = Exception("message"),
            errorType = ErrorType.Internal,
        ).toMap()

        assertNotNull(map["errorMessage"])
        assertNotNull(map["digitalWalletErrorCode"])
        assertNotNull(map["digitalWalletType"])
    }

    @Test
    fun toMap_hasCorrectValues() {
        val map = GooglePayException(
            throwable = Exception("test error message"),
            errorType = ErrorType.Internal,
        ).toMap()

        assertEquals("java.lang.Exception: test error message", map["errorMessage"])
        assertEquals("Internal", map["digitalWalletErrorCode"])
        assertEquals("googlePay", map["digitalWalletType"])
    }
}
