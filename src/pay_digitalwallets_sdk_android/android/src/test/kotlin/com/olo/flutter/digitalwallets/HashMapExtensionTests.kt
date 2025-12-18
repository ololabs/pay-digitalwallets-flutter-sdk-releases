// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets

import com.olo.flutter.digitalwallets.data.EmptyValueException
import com.olo.flutter.digitalwallets.data.MissingKeyException
import com.olo.flutter.digitalwallets.data.NullValueException
import com.olo.flutter.digitalwallets.data.UnexpectedTypeException
import com.olo.flutter.digitalwallets.extensions.getArgOrThrow
import com.olo.flutter.digitalwallets.extensions.getArgOrErrorResult
import com.olo.flutter.digitalwallets.extensions.getStringArgOrErrorResult
import io.flutter.plugin.common.MethodChannel
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.fail
import org.junit.jupiter.api.Test
import org.mockito.Mockito

class HashMapExtensionTests {
    // MARK: - getArgOrThrow Tests (No Default Value)

    @Test
    fun getArgOrThrow_keyMissing_throwsMissingKeyException() {
        val map = hashMapOf<String, Any?>("foo" to "1.2.3")

        try {
            map.getArgOrThrow<String>("bar")
            fail("Exception should be thrown")
        } catch (e: MissingKeyException) {
            assertEquals("Missing key 'bar'", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type MissingKeyException")
        }
    }

    @Test
    fun getArgOrThrow_keyExists_valueIsNull_throwsNullValueException() {
        val map = hashMapOf<String, Any?>("foo" to null)

        try {
            map.getArgOrThrow<String>("foo")
            fail("Exception should be thrown")
        } catch (e: NullValueException) {
            assertEquals("Value for 'foo' is null", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type NullValueException")
        }
    }

    @Test
    fun getArgOrThrow_keyExists_valueIsIncorrectType_throwsUnexpectedTypeException() {
        val map = hashMapOf<String, Any?>("foo" to 2.0)

        try {
            map.getArgOrThrow<String>("foo")
            fail("Exception should be thrown")
        } catch (e: UnexpectedTypeException) {
            assertEquals("Value for 'foo' is not of type String", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type UnexpectedTypeException")
        }
    }

    @Test
    fun getArgOrThrow_keyExists_valueIsCorrectType_returnsArgValue() {
        val map = hashMapOf<String, Any?>("foo" to "bar")

        val argValue = try {
            map.getArgOrThrow<String>("foo")
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        assertEquals("bar", argValue)
    }

    // MARK: - getArgOrThrow Tests (With Default Value)

    @Test
    fun getArgOrThrow_withDefaultValue_keyMissing_returnsDefaultValue() {
        val map = hashMapOf<String, Any?>("foo" to "bar")

        val argValue = try {
            map.getArgOrThrow<String>("bar", "default")
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        assertEquals("default", argValue)
    }

    @Test
    fun getArgOrThrow_withDefaultValue_keyExists_valueIsNull_returnsDefaultValue() {
        val map = hashMapOf<String, Any?>("foo" to null)

        val argValue = try {
            map.getArgOrThrow<String>("foo", "default")
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        assertEquals("default", argValue)
    }

    @Test
    fun getArgOrThrow_withDefaultValue_keyExists_valueIsIncorrectType_throwsUnexpectedTypeException() {
        val map = hashMapOf<String, Any?>("foo" to 2.0)

        try {
            map.getArgOrThrow<String>("foo", "default")
            fail("Exception should be thrown")
        } catch (e: UnexpectedTypeException) {
            assertEquals("Value for 'foo' is not of type String", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type UnexpectedTypeException")
        }
    }

    @Test
    fun getArgOrThrow_withDefaultValue_keyExists_valueIsCorrectType_returnsArgValue() {
        val map = hashMapOf<String, Any?>("foo" to "bar")

        val argValue = try {
            map.getArgOrThrow<String>("foo", "default")
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        assertEquals("bar", argValue)
    }

    // MARK: - getArgOrThrow Tests (Different Types)

    @Test
    fun getArgOrThrow_withIntegerType_returnsInteger() {
        val map = hashMapOf<String, Any?>("key" to 42)

        val argValue = try {
            map.getArgOrThrow<Int>("key")
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        assertEquals(42, argValue)
    }

    @Test
    fun getArgOrThrow_withBooleanType_returnsBoolean() {
        val map = hashMapOf<String, Any?>("key" to true)

        val argValue = try {
            map.getArgOrThrow<Boolean>("key")
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        assertEquals(true, argValue)
    }

    @Test
    fun getArgOrThrow_withListType_returnsList() {
        val list = listOf("item1", "item2")
        val map = hashMapOf<String, Any?>("key" to list)

        val argValue = try {
            map.getArgOrThrow<List<*>>("key")
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        assertEquals(list, argValue)
    }

    @Test
    fun getArgOrThrow_withMapType_returnsMap() {
        val nestedMap = mapOf("nested" to "value")
        val map = hashMapOf<String, Any?>("key" to nestedMap)

        val argValue = try {
            map.getArgOrThrow<Map<*, *>>("key")
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        assertEquals(nestedMap, argValue)
    }

    // MARK: - getArgOrErrorResult Tests (No Default Value)

    @Test
    fun getArgOrErrorResult_argsMissingKey_returnsMissingParameter_throwsMissingKeyException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "1.2.3")

        try {
            map.getArgOrErrorResult<String>(
                "bar",
                "Test",
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: MissingKeyException) {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "Test: Missing parameter 'bar'",
                null
            )

            assertEquals("Test: Missing parameter 'bar'", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type MissingKeyException")
        }
    }

    @Test
    fun getArgOrErrorResult_argValueIsNull_returnsMissingParameter_throwsNullValueException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to null)

        try {
            map.getArgOrErrorResult<String>(
                "foo",
                "Test",
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: NullValueException) {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "Test: Missing parameter 'foo'",
                null
            )

            assertEquals("Test: Missing parameter 'foo'", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type NullValueException")
        }
    }

    @Test
    fun getArgOrErrorResult_argValueIncorrectType_returnsUnexpectedParameterType_throwsUnexpectedTypeException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to true)

        try {
            map.getArgOrErrorResult<String>(
                "foo",
                "Test",
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: UnexpectedTypeException) {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "Test: Value for 'foo' is not of type String",
                null
            )

            assertEquals("Test: Value for 'foo' is not of type String", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type UnexpectedTypeException")
        }
    }

    @Test
    fun getArgOrErrorResult_argValueIsCorrectType_returnsArgValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "bar")

        val argValue = try {
            map.getArgOrErrorResult<String>(
                "foo",
                "Test",
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("bar", argValue)
    }

    // MARK: - getArgOrErrorResult Tests (With Default Value)

    @Test
    fun getArgOrErrorResult_withDefaultValue_argsMissingKey_returnsDefaultValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "1.2.3")

        try {
            val argValue = map.getArgOrErrorResult<String>(
                "bar",
                "default",
                "Test",
                mockResult
            )

            Mockito.verifyNoInteractions(mockResult)
            assertEquals("default", argValue)
        } catch(e: Exception) {
            fail("Exception should not be thrown")
        }
    }

    @Test
    fun getArgOrErrorResult_withDefaultValue_argsValueIsNull_returnsDefaultValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to null)

        try {
            val argValue = map.getArgOrErrorResult<String>(
                "foo",
                "default",
                "Test",
                mockResult
            )

            Mockito.verifyNoInteractions(mockResult)
            assertEquals("default", argValue)
        } catch(e: Exception) {
            fail("Exception should not be thrown")
        }
    }

    @Test
    fun getArgOrErrorResult_withDefaultValue_argValueIncorrectType_returnsUnexpectedParameterType_throwsUnexpectedTypeError() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to true)

        try {
            map.getArgOrErrorResult<String>(
                "foo",
                "default",
                "Test",
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: UnexpectedTypeException) {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "Test: Value for 'foo' is not of type String",
                null
            )

            assertEquals("Test: Value for 'foo' is not of type String", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type UnexpectedTypeException")
        }
    }

    @Test
    fun getArgOrErrorResult_withDefaultValue_argValueIsCorrectType_returnsArgValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "bar")

        val argValue = try {
            map.getArgOrErrorResult<String>(
                "foo",
                "default",
                "Test",
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("bar", argValue)
    }

    // MARK: - getStringArgOrErrorResult Tests (No Default Value)

    @Test
    fun getStringArgOrErrorResult_argsMissingKey_returnsMissingParameter_throwsMissingKeyException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "1.2.3")

        try {
            map.getStringArgOrErrorResult(
                "bar",
                "Test",
                true,
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: MissingKeyException) {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "Test: Missing parameter 'bar'",
                null
            )

            assertEquals("Test: Missing parameter 'bar'", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type MissingKeyException")
        }
    }

    @Test
    fun getStringArgOrErrorResult_argValueIsNull_returnsMissingParameter_throwsNullValueException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to null)

        try {
            map.getStringArgOrErrorResult(
                "foo",
                "Test",
                true,
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: NullValueException) {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "Test: Missing parameter 'foo'",
                null
            )

            assertEquals("Test: Missing parameter 'foo'", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type NullValueException")
        }
    }

    @Test
    fun getStringArgOrErrorResult_argValueNotString_returnsUnexpectedParameterType_throwsUnexpectedTypeException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to true)

        try {
            map.getStringArgOrErrorResult(
                "foo",
                "Test",
                true,
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: UnexpectedTypeException) {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "Test: Value for 'foo' is not of type String",
                null
            )

            assertEquals("Test: Value for 'foo' is not of type String", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type UnexpectedTypeException")
        }
    }

    @Test
    fun getStringArgOrErrorResult_emptyValueNotAccepted_argValueIsEmpty_returnsInvalidParameter_throwsEmptyValueException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "")

        try {
            map.getStringArgOrErrorResult(
                "foo",
                "Test",
                false,
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: EmptyValueException) {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "Test: Value for 'foo' cannot be empty",
                null
            )

            assertEquals("Test: Value for 'foo' cannot be empty", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type EmptyValueException")
        }
    }

    @Test
    fun getStringArgOrErrorResult_emptyValueNotAccepted_argValueNotEmpty_returnsArgValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "bar")

        val argValue = try {
            map.getStringArgOrErrorResult(
                "foo",
                "Test",
                false,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("bar", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_emptyValueAccepted_argValueIsEmpty_returnsEmptyString() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "")

        val argValue = try {
            map.getStringArgOrErrorResult(
                "foo",
                "Test",
                true,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_emptyValueAccepted_argValueNotEmpty_returnsArg() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "bar")

        val argValue = try {
            map.getStringArgOrErrorResult(
                "foo",
                "Test",
                true,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("bar", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_withWhitespace_trimsValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("key" to "  value  ")

        val argValue = try {
            map.getStringArgOrErrorResult(
                "key",
                "Test",
                false,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("value", argValue)
    }

    // MARK: - getStringArgOrErrorResult Tests (With Default Value)

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_argsMissingKey_returnsDefaultValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "1.2.3")

        val argValue = try {
            map.getStringArgOrErrorResult(
                "bar",
                "default",
                "Test",
                true,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("default", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_argValueIsNull_returnsDefaultValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to null)

        val argValue = try {
            map.getStringArgOrErrorResult(
                "foo",
                "default",
                "Test",
                true,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("default", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_argValueNotString_returnsUnexpectedParameterType_throwsUnexpectedTypeException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to true)

        try {
            map.getStringArgOrErrorResult(
                "foo",
                "default",
                "Test",
                true,
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: UnexpectedTypeException) {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "Test: Value for 'foo' is not of type String",
                null
            )

            assertEquals("Test: Value for 'foo' is not of type String", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type UnexpectedTypeException")
        }
    }

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_emptyValueNotAccepted_argValueIsEmpty_returnsDefaultValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "")

        val argValue = try {
            map.getStringArgOrErrorResult(
                "foo",
                "default",
                "Test",
                false,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("default", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_emptyValueNotAccepted_argValueNotEmpty_returnsArgValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "bar")

        val argValue = try {
            map.getStringArgOrErrorResult(
                "foo",
                "default",
                "Test",
                false,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("bar", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_emptyValueAccepted_argValueIsEmpty_returnsEmptyString() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "")

        val argValue = try {
            map.getStringArgOrErrorResult(
                "foo",
                "default",
                "Test",
                true,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_emptyValueAccepted_argValueNotEmpty_returnsArgValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val map = hashMapOf<String, Any?>("foo" to "bar")

        val argValue = try {
            map.getStringArgOrErrorResult(
                "foo",
                "default",
                "Test",
                true,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("bar", argValue)
    }
}
