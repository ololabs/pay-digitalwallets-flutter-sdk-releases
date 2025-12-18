// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  PKPaymentNetworkExtensions.swift
//  Pods
//
//  Created by Richard Dowdy on 11/19/25.
//

import PassKit

extension PKPaymentNetwork {
    private static let networkMap: [String: PKPaymentNetwork] = {
        var map: [String: PKPaymentNetwork] = [
            "americanexpress": .amex,
            "visa": .visa,
            "mastercard": .masterCard,
            "discover": .discover,
            "interac": .interac,
            "jcb": .JCB,
            "chinaunionpay": .chinaUnionPay,
            "cartebancaire": .carteBancaire,
            "cartebancaires": .carteBancaires,
            "cartesbancaires": .cartesBancaires,
            "eftpos": .eftpos,
            "electron": .electron,
            "elo": .elo,
            "mada": .mada,
            "maestro": .maestro,
            "privatelabel": .privateLabel,
            "vpay": .vPay,
            "quicpay": .quicPay,
            "suica": .suica,
            "idcredit": .idCredit
        ]

        // Version-specific additions
        if #available(iOS 14.0, *) {
            map["girocard"] = .girocard
            map["barcode"] = .barcode
        }

        if #available(iOS 14.5, *) {
            map["mir"] = .mir
        }

        if #available(iOS 15.0, *) {
            map["nanaco"] = .nanaco
            map["waon"] = .waon
        }

        if #available(iOS 15.1, *) {
            map["dankort"] = .dankort
        }

        if #available(iOS 16.0, *) {
            map["bancomat"] = .bancomat
            map["bancontact"] = .bancontact
        }

        if #available(iOS 16.4, *) {
            map["postfinance"] = .postFinance
        }

        if #available(iOS 17.0, *) {
            map["pagobancompat"] = .pagoBancomat
            map["tmoney"] = .tmoney
        }

        if #available(iOS 17.4, *) {
            map["meeza"] = .meeza
        }

        if #available(iOS 17.5, *) {
            map["napas"] = .NAPAS
        }

        return map
    }()

    static func convert(_ networkStrings: [String]) -> [PKPaymentNetwork] {
        return networkStrings.compactMap { networkMap[$0.lowercased()] }
    }
}
