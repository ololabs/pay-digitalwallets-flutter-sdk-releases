// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets.utils

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

fun backgroundOperation(
    scope: CoroutineScope = CoroutineScope(Dispatchers.IO),
    operation: suspend() -> Unit
) {
    scope.launch {
        operation()
    }
}

fun uiOperation(
    scope: CoroutineScope = CoroutineScope(Dispatchers.Main),
    operation: suspend() -> Unit
) {
    scope.launch {
        operation()
    }
}