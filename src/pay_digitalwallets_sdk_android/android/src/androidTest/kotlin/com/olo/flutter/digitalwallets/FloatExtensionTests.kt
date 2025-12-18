// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets

import android.content.Context
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import com.olo.flutter.digitalwallets.extensions.dpToPx
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class FloatExtensionTests {
    private lateinit var context: Context

    @Before
    fun setup() {
        context = InstrumentationRegistry.getInstrumentation().targetContext
    }

    @Test
    fun dpToPx_withZeroDp_returnsZero() {
        val result = 0f.dpToPx(context)
        assertEquals(0f, result, 0.01f)
    }

    @Test
    fun dpToPx_withPositiveValue_returnsScaledValue() {
        val dpValue = 10f
        val density = context.resources.displayMetrics.density
        val expectedPx = dpValue * density

        val result = dpValue.dpToPx(context)

        assertEquals(expectedPx, result, 0.01f)
    }

    @Test
    fun dpToPx_withLargeValue_returnsScaledValue() {
        val dpValue = 100f
        val density = context.resources.displayMetrics.density
        val expectedPx = dpValue * density

        val result = dpValue.dpToPx(context)

        assertEquals(expectedPx, result, 0.01f)
    }

    @Test
    fun dpToPx_returnsValueBasedOnDensity() {
        val dpValue = 16f
        val result = dpValue.dpToPx(context)

        // The result should be greater than the input for any screen density > 1
        val density = context.resources.displayMetrics.density
        if (density > 1f) {
            assertTrue("Result should be greater than input dp for density > 1", result > dpValue)
        } else {
            assertEquals(dpValue, result, 0.01f)
        }
    }

    @Test
    fun dpToPx_withFractionalValue_returnsScaledValue() {
        val dpValue = 12.5f
        val density = context.resources.displayMetrics.density
        val expectedPx = dpValue * density

        val result = dpValue.dpToPx(context)

        assertEquals(expectedPx, result, 0.01f)
    }
}
