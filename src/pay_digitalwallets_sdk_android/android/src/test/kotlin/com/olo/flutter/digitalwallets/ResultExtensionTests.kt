// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets

import com.olo.flutter.digitalwallets.extensions.oloError
import io.flutter.plugin.common.MethodChannel
import org.junit.jupiter.api.Test
import org.mockito.Mockito

class ResultExtensionTests {
    @Test
    fun oloError_callsErrorWithCorrectParameters() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val errorCode = "TestErrorCode"
        val errorMessage = "Test error message"

        mockResult.oloError(errorCode, errorMessage)

        Mockito.verify(mockResult).error(errorCode, errorMessage, null)
    }

    @Test
    fun oloError_withDifferentCode_callsErrorWithCorrectParameters() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val errorCode = "AnotherError"
        val errorMessage = "Another error message"

        mockResult.oloError(errorCode, errorMessage)

        Mockito.verify(mockResult).error(errorCode, errorMessage, null)
    }

    @Test
    fun oloError_withEmptyMessage_callsErrorWithEmptyMessage() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val errorCode = "ErrorCode"
        val errorMessage = ""

        mockResult.oloError(errorCode, errorMessage)

        Mockito.verify(mockResult).error(errorCode, errorMessage, null)
    }
}
