// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets.extensions

import com.olo.flutter.digitalwallets.data.DataKeys
import com.olo.pay.digitalwalletssdk.exceptions.GooglePayException

fun GooglePayException.toMap(): Map<String, Any> {
    return mapOf(
        DataKeys.DigitalWalletErrorMessageParameterKey to (this.message ?: ""),
        DataKeys.DigitalWalletErrorCode to this.errorType.toString(),
        DataKeys.DigitalWalletTypeParameterKey to DataKeys.DigitalWalletTypeParameterValue
    )
}