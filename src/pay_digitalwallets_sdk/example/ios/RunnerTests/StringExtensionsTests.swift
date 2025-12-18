// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  StringExtensionsTests.swift
//  pay_digitalwallets_sdk_ios Tests
//
//  Created by Tests on 12/2/24.
//

import XCTest
@testable import pay_digitalwallets_sdk_ios

class StringExtensionsTests: XCTestCase {

    func testTrim_withLeadingSpaces_removesLeadingSpaces() {
        let input = "   hello"
        let result = input.trim()
        XCTAssertEqual(result, "hello")
    }

    func testTrim_withTrailingSpaces_removesTrailingSpaces() {
        let input = "hello   "
        let result = input.trim()
        XCTAssertEqual(result, "hello")
    }

    func testTrim_withLeadingAndTrailingSpaces_removesBoth() {
        let input = "   hello   "
        let result = input.trim()
        XCTAssertEqual(result, "hello")
    }

    func testTrim_withMiddleSpaces_keepsMiddleSpaces() {
        let input = "  hello world  "
        let result = input.trim()
        XCTAssertEqual(result, "hello world")
    }

    func testTrim_withNoSpaces_returnsUnchanged() {
        let input = "hello"
        let result = input.trim()
        XCTAssertEqual(result, "hello")
    }

    func testTrim_withOnlySpaces_returnsEmptyString() {
        let input = "     "
        let result = input.trim()
        XCTAssertEqual(result, "")
    }

    func testTrim_withEmptyString_returnsEmptyString() {
        let input = ""
        let result = input.trim()
        XCTAssertEqual(result, "")
    }

    func testTrim_withTabs_removesTabs() {
        let input = "\t\thello\t\t"
        let result = input.trim()
        XCTAssertEqual(result, "hello")
    }

    func testTrim_withNewlines_doesNotRemoveNewlines() {
        let input = "\n\nhello\n\n"
        let result = input.trim()
        XCTAssertEqual(result, "\n\nhello\n\n")
    }

    func testTrim_withMixedWhitespace_removesOnlySpacesAndTabs() {
        let input = " \t\n hello \n\t "
        let result = input.trim()
        XCTAssertEqual(result, "\n hello \n")
    }
}
