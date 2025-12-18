// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  StringExtensions.swift
//  Pods
//
//  Created by Richard Dowdy on 11/19/25.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func isValidDecimalNumber() -> Bool {
        let decimalRegex = "^-?\\d+(\\.\\d+)?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", decimalRegex)
        return predicate.evaluate(with: self)
    }
}
