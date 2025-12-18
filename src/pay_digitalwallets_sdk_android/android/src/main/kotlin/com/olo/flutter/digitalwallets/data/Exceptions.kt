// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets.data

import java.lang.RuntimeException

class MissingKeyException(
    message: String,
    exception: Throwable? = null
): RuntimeException(message, exception)

class NullValueException(
    message: String,
    exception: Throwable? = null
): RuntimeException(message, exception)

class UnexpectedTypeException(
    message: String,
    exception: Throwable? = null
): RuntimeException(message, exception)

class EmptyValueException(
    message: String,
    exception: Throwable? = null
): RuntimeException(message, exception)
