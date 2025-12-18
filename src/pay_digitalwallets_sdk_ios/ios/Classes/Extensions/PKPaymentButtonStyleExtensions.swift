// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  PKPaymentButtonStyleExtensions.swift
//  Pods
//
//  Created by Richard Dowdy on 11/13/25.
//

import PassKit

extension PKPaymentButtonStyle {
    static func convert(from str: String) -> PKPaymentButtonStyle {
        switch str {
        case DataKeys.ApplePayButtonStyleBlack:
            return .black
        case DataKeys.ApplePayButtonStyleWhite:
            return .white
        case DataKeys.ApplePayButtonStyleWhiteOutline:
            return .whiteOutline
        case DataKeys.ApplePayButtonStyleAutomatic:
            if #available(iOS 14.0, *) {
                return .automatic
            } else {
                return .black
            }
        default:
            return .black
        }
    }
}
