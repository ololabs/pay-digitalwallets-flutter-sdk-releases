// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets

import com.olo.flutter.digitalwallets.extensions.safeRelease
import kotlinx.coroutines.sync.Semaphore
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

class SemaphoreExtensionTests {
    @Test
    fun safeRelease_withNoPermits_releasesSemaphore() {
        val semaphore = Semaphore(1)
        semaphore.tryAcquire() // Acquire the permit, so availablePermits = 0

        assertEquals(0, semaphore.availablePermits)

        semaphore.safeRelease()

        assertEquals(1, semaphore.availablePermits)
    }

    @Test
    fun safeRelease_withPermitAvailable_doesNotRelease() {
        val semaphore = Semaphore(1)

        assertEquals(1, semaphore.availablePermits)

        semaphore.safeRelease()

        // Should still have 1 permit, not 2
        assertEquals(1, semaphore.availablePermits)
    }

    @Test
    fun safeRelease_withMultiplePermits_doesNotRelease() {
        val semaphore = Semaphore(3)

        assertEquals(3, semaphore.availablePermits)

        semaphore.safeRelease()

        // Should still have 3 permits, not 4
        assertEquals(3, semaphore.availablePermits)
    }
}
