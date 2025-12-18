// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets.extensions

import kotlinx.coroutines.sync.Semaphore

fun Semaphore.safeRelease() {
    if (this.availablePermits == 0) {
        this.release()
    }
}