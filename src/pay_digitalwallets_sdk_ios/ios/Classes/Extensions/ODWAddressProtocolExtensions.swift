// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  ODWAddressProtocolExtensions.swift
//  Pods
//
//  Created by Richard Dowdy on 11/21/25.
//

import Foundation
import OloDigitalWalletsSDK

extension ODWAddressProtocol {
    func toDictionary() -> [String: Any] {
        return [
            DataKeys.AddressLine1Key: self.street,
            DataKeys.AddressLine2Key: "",
            DataKeys.AddressLine3Key: "",
            DataKeys.AddressLocalityKey: self.city,
            DataKeys.AddressAdministrativeAreaKey: self.state,
            DataKeys.AddressPostalCodeKey: self.postalCode,
            DataKeys.AddressCountryCodeKey: self.countryCode,
            DataKeys.AddressSortingCodeKey: ""
        ]
    }
}
