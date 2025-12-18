// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  ODWPaymentDataProtocolExtensions.swift
//  Pods
//
//  Created by Richard Dowdy on 11/21/25.
//

import Foundation
import OloDigitalWalletsSDK
import PassKit

extension ODWPaymentDataProtocol {
    func toDictionary() -> [String: Any] {
        return [
            DataKeys.PaymentDataTokenKey: self.token,
            DataKeys.PaymentDataLastFourKey: self.lastFour,
            DataKeys.PaymentDataCardTypeKey: self.paymentNetwork?.rawValue.lowercased() ?? "unsupported",
            DataKeys.PaymentDataOloCardDescriptionKey: self.oloPaymentNetworkDescription,
            DataKeys.PaymentDataCardDetailsKey: self.cardDescription,
            DataKeys.PaymentDataEmailKey: self.email,
            DataKeys.PaymentDataPhoneNumberKey: self.phoneNumber,
            DataKeys.PaymentDataFullNameKey: self.fullName,
            DataKeys.PaymentDataFullPhoneticNameKey: self.fullPhoneticName,
            DataKeys.PaymentDataBillingAddressKey: self.billingAddress.toDictionary()
        ]
    }
}
