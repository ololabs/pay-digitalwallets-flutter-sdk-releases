// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets.extensions

import com.olo.flutter.digitalwallets.data.DataKeys
import com.olo.pay.digitalwalletssdk.data.Address

fun Address.toMap(): Map<String, Any> {
    return mapOf(
        DataKeys.Address1Key to this.address1,
        DataKeys.Address2Key to this.address2,
        DataKeys.Address3Key to this.address3,
        DataKeys.LocalityKey to this.locality,
        DataKeys.AdministrativeAreaKey to this.administrativeArea,
        DataKeys.PostalCodeKey to this.postalCode,
        DataKeys.CountryCodeKey to this.countryCode,
        DataKeys.SortingCodeKey to this.sortingCode
    )
}
