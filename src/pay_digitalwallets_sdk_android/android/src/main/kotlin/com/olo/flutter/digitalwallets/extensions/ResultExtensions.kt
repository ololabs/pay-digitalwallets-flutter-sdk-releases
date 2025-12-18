// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets.extensions

import com.olo.flutter.digitalwallets.utils.OloLog
import io.flutter.plugin.common.MethodChannel

fun MethodChannel.Result.oloError(errorCode: String, message: String) {
    OloLog.e("${errorCode}\n$message")
    error(errorCode, message, null)
}
