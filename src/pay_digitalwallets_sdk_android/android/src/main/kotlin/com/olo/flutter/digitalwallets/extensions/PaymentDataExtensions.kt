// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets.extensions

import com.olo.flutter.digitalwallets.data.DataKeys
import com.olo.pay.digitalwalletssdk.data.PaymentData

fun PaymentData.toMap(): Map<String,Any> {
    return mapOf(
        DataKeys.TokenKey to this.token,
        DataKeys.DescriptionKey to this.description,
        DataKeys.OloCardTypeDescriptionKey to this.oloCardTypeDescription,
        DataKeys.CardTypeKey to this.cardType.name.lowercase(),
        DataKeys.CardDetailsKey to this.cardDetails,
        DataKeys.LastFourKey to this.lastFour,
        DataKeys.BillingAddressKey to this.billingAddress.toMap(),
        DataKeys.EmailKey to this.email,
        DataKeys.FullNameKey to this.fullName,
        DataKeys.PhoneNumberKey to this.phoneNumber,
    )
}