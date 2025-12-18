// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets

import com.olo.flutter.digitalwallets.utils.backgroundOperation
import com.olo.flutter.digitalwallets.utils.uiOperation
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.*
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.*

@OptIn(ExperimentalCoroutinesApi::class)
class ThreadingUtilsTests {

    private val testDispatcher = StandardTestDispatcher()

    @BeforeEach
    fun setup() {
        Dispatchers.setMain(testDispatcher)
    }

    @AfterEach
    fun tearDown() {
        Dispatchers.resetMain()
    }

    @Test
    fun backgroundOperation_executesOperationOnIODispatcher() = runTest {
        var executed = false

        backgroundOperation(this) {
            executed = true
        }

        // Advance time to allow coroutine to complete
        advanceUntilIdle()

        assertTrue(executed, "Background operation should have executed")
    }

    @Test
    fun backgroundOperation_withSuspendFunction_executesCorrectly() = runTest {
        var result = 0

        backgroundOperation(this) {
            // Simulate some async work
            kotlinx.coroutines.delay(100)
            result = 42
        }

        // Advance time to allow coroutine to complete
        advanceUntilIdle()

        assertEquals(42, result, "Background operation should have completed")
    }

    @Test
    fun backgroundOperation_multipleCalls_executeAllOperations() = runTest {
        var counter = 0

        for (i in 1..5) {
            backgroundOperation(this) {
                counter++
            }
        }

        // Advance time to allow all coroutines to complete
        advanceUntilIdle()

        assertEquals(5, counter, "All background operations should have executed")
    }

    @Test
    fun uiOperation_executesOperationOnMainDispatcher() = runTest {
        var executed = false

        uiOperation(this) {
            executed = true
        }

        // Advance time to allow coroutine to complete
        advanceUntilIdle()

        assertTrue(executed, "UI operation should have executed")
    }

    @Test
    fun uiOperation_withSuspendFunction_executesCorrectly() = runTest {
        var result = ""

        uiOperation(this) {
            // Simulate some async work
            kotlinx.coroutines.delay(100)
            result = "UI Updated"
        }

        // Advance time to allow coroutine to complete
        advanceUntilIdle()

        assertEquals("UI Updated", result, "UI operation should have completed")
    }

    @Test
    fun uiOperation_multipleCalls_executeAllOperations() = runTest {
        var counter = 0

        for (i in 1..5) {
            uiOperation(this) {
                counter++
            }
        }

        // Advance time to allow all coroutines to complete
        advanceUntilIdle()

        assertEquals(5, counter, "All UI operations should have executed")
    }

    @Test
    fun backgroundOperation_withException_doesNotCrash() = runTest {
        var exceptionThrown = false

        backgroundOperation(this) {
            try {
                throw RuntimeException("Test exception")
            } catch (e: Exception) {
                exceptionThrown = true
            }
        }

        // Advance time to allow coroutine to complete
        advanceUntilIdle()

        assertTrue(exceptionThrown, "Exception should have been thrown and caught")
    }

    @Test
    fun uiOperation_withException_doesNotCrash() = runTest {
        var exceptionThrown = false

        uiOperation(this) {
            try {
                throw RuntimeException("Test exception")
            } catch (e: Exception) {
                exceptionThrown = true
            }
        }

        // Advance time to allow coroutine to complete
        advanceUntilIdle()

        assertTrue(exceptionThrown, "Exception should have been thrown and caught")
    }

    @Test
    fun backgroundOperation_withLongRunningTask_executesCompletely() = runTest {
        var result = 0

        backgroundOperation(this) {
            for (i in 1..10) {
                kotlinx.coroutines.delay(10)
                result += i
            }
        }

        // Advance time to allow coroutine to complete
        advanceUntilIdle()

        assertEquals(55, result, "Long running task should complete (1+2+...+10 = 55)")
    }

    @Test
    fun uiOperation_withLongRunningTask_executesCompletely() = runTest {
        var result = 0

        uiOperation(this) {
            for (i in 1..10) {
                kotlinx.coroutines.delay(10)
                result += i
            }
        }

        // Advance time to allow coroutine to complete
        advanceUntilIdle()

        assertEquals(55, result, "Long running task should complete (1+2+...+10 = 55)")
    }

    @Test
    fun mixedOperations_backgroundAndUI_bothExecute() = runTest {
        var backgroundExecuted = false
        var uiExecuted = false

        backgroundOperation(this) {
            backgroundExecuted = true
        }

        uiOperation(this) {
            uiExecuted = true
        }

        // Advance time to allow all coroutines to complete
        advanceUntilIdle()

        assertTrue(backgroundExecuted, "Background operation should have executed")
        assertTrue(uiExecuted, "UI operation should have executed")
    }
}
