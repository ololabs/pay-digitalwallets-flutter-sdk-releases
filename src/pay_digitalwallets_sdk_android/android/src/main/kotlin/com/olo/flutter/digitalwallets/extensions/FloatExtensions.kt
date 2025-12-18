// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets.extensions

import android.content.Context

internal fun Float.dpToPx(context: Context): Float =
    (this * context.resources.displayMetrics.density)