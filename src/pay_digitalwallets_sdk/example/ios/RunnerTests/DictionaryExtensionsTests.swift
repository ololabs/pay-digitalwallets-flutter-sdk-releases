// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  DictionaryExtensionsTests.swift
//  RunnerTests
//
//  Created by Tests on 12/2/24.
//

import XCTest
@testable import pay_digitalwallets_sdk_ios

class DictionaryExtensionsTests: XCTestCase {

    // MARK: - keyExists Tests

    func testKeyExists_withExistingKey_returnsTrue() {
        let dict: [String: Any] = ["key1": "value1"]
        XCTAssertTrue(dict.keyExists("key1"))
    }

    func testKeyExists_withMissingKey_returnsFalse() {
        let dict: [String: Any] = ["key1": "value1"]
        XCTAssertFalse(dict.keyExists("key2"))
    }

    func testKeyExists_withNullValue_returnsTrue() {
        let dict: [String: Any] = ["key1": NSNull()]
        XCTAssertTrue(dict.keyExists("key1"))
    }

    // MARK: - get<T> Tests

    func testGet_withValidKey_returnsValue() {
        let dict: [String: Any] = ["name": "John", "age": 30]

        let name: String? = dict.get("name")
        let age: Int? = dict.get("age")

        XCTAssertEqual(name, "John")
        XCTAssertEqual(age, 30)
    }

    func testGet_withMissingKey_returnsNil() {
        let dict: [String: Any] = ["name": "John"]

        let age: Int? = dict.get("age")

        XCTAssertNil(age)
    }

    func testGet_withWrongType_returnsNil() {
        let dict: [String: Any] = ["age": 30]

        let age: String? = dict.get("age")

        XCTAssertNil(age)
    }

    // MARK: - getOrThrow<T> (no default) Tests

    func testGetOrThrow_withValidKey_returnsValue() throws {
        let dict: [String: Any] = ["name": "John", "age": 30]

        let name: String = try dict.getOrThrow("name")
        let age: Int = try dict.getOrThrow("age")

        XCTAssertEqual(name, "John")
        XCTAssertEqual(age, 30)
    }

    func testGetOrThrow_withMissingKey_throwsMissingKeyError() {
        let dict: [String: Any] = ["name": "John"]

        XCTAssertThrowsError(try dict.getOrThrow("age") as Int) { error in
            XCTAssertTrue(error is OloError)
            if let oloError = error as? OloError {
                XCTAssertEqual(oloError, OloError.MissingKeyError)
            }
        }
    }

    func testGetOrThrow_withNullValue_throwsNullValueError() {
        let dict: [String: Any] = ["name": NSNull()]

        XCTAssertThrowsError(try dict.getOrThrow("name") as String) { error in
            XCTAssertTrue(error is OloError)
            if let oloError = error as? OloError {
                XCTAssertEqual(oloError, OloError.NullValueError)
            }
        }
    }

    func testGetOrThrow_withWrongType_throwsUnexpectedTypeError() {
        let dict: [String: Any] = ["age": 30]

        XCTAssertThrowsError(try dict.getOrThrow("age") as String) { error in
            XCTAssertTrue(error is OloError)
            if let oloError = error as? OloError {
                XCTAssertEqual(oloError, OloError.UnexpectedTypeError)
            }
        }
    }

    // MARK: - getOrThrow<T> (with default) Tests

    func testGetOrThrowWithDefault_withValidKey_returnsValue() throws {
        let dict: [String: Any] = ["name": "John", "age": 30]

        let name: String = try dict.getOrThrow("name", defaultValue: "Default")
        let age: Int = try dict.getOrThrow("age", defaultValue: 0)

        XCTAssertEqual(name, "John")
        XCTAssertEqual(age, 30)
    }

    func testGetOrThrowWithDefault_withMissingKey_returnsDefaultValue() throws {
        let dict: [String: Any] = ["name": "John"]

        let age: Int = try dict.getOrThrow("age", defaultValue: 25)

        XCTAssertEqual(age, 25)
    }

    func testGetOrThrowWithDefault_withNullValue_returnsDefaultValue() throws {
        let dict: [String: Any] = ["name": NSNull()]

        let name: String = try dict.getOrThrow("name", defaultValue: "Default")

        XCTAssertEqual(name, "Default")
    }

    func testGetOrThrowWithDefault_withWrongType_throwsUnexpectedTypeError() {
        let dict: [String: Any] = ["age": 30]

        XCTAssertThrowsError(try dict.getOrThrow("age", defaultValue: "0")) { error in
            XCTAssertTrue(error is OloError)
            if let oloError = error as? OloError {
                XCTAssertEqual(oloError, OloError.UnexpectedTypeError)
            }
        }
    }

    // MARK: - getDictionary Tests

    func testGetDictionary_withValidDictionary_returnsDictionary() {
        let innerDict = ["street": "123 Main St", "city": "New York"]
        let dict: [String: Any] = ["address": innerDict]

        let result = dict.getDictionary("address")

        XCTAssertNotNil(result)
        XCTAssertEqual(result?["street"] as? String, "123 Main St")
        XCTAssertEqual(result?["city"] as? String, "New York")
    }

    func testGetDictionary_withMissingKey_returnsNil() {
        let dict: [String: Any] = ["name": "John"]

        let result = dict.getDictionary("address")

        XCTAssertNil(result)
    }

    func testGetDictionary_withWrongType_returnsNil() {
        let dict: [String: Any] = ["address": "123 Main St"]

        let result = dict.getDictionary("address")

        XCTAssertNil(result)
    }

    // MARK: - getArray Tests

    func testGetArray_withValidArray_returnsArray() {
        let items = ["item1", "item2", "item3"]
        let dict: [String: Any] = ["items": items]

        let result = dict.getArray("items")

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 3)
    }

    func testGetArray_withMissingKey_returnsNil() {
        let dict: [String: Any] = ["name": "John"]

        let result = dict.getArray("items")

        XCTAssertNil(result)
    }

    func testGetArray_withWrongType_returnsNil() {
        let dict: [String: Any] = ["items": "not an array"]

        let result = dict.getArray("items")

        XCTAssertNil(result)
    }

    func testGetArray_withEmptyArray_returnsEmptyArray() {
        let dict: [String: Any] = ["items": []]

        let result = dict.getArray("items")

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 0)
    }
}
