// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  OloError.swift
//  Pods
//
//  Created by Richard Dowdy on 11/19/25.
//

import Foundation

enum OloError: Error {
    case AssetNotFoundError
    case UnexpectedError
    case UnexpectedTypeError
    case MissingKeyError
    case EmptyValueError
    case NullValueError
}
