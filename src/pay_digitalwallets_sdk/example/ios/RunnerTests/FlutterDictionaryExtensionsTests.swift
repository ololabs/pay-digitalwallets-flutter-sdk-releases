// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  FlutterDictionaryExtensionsTests.swift
//  RunnerTests
//
//  Created by Tests on 12/2/24.
//

import XCTest
import Flutter
@testable import pay_digitalwallets_sdk_ios

class FlutterDictionaryExtensionsTests: XCTestCase {

    var resultError: FlutterError?
    var resultSuccess: Any?

    override func setUp() {
        super.setUp()
        resultError = nil
        resultSuccess = nil
    }

    func mockResult(_ result: Any?) {
        if let error = result as? FlutterError {
            resultError = error
        } else {
            resultSuccess = result
        }
    }

    // MARK: - Dictionary getOrErrorResult Tests (no default)

    func testGetOrErrorResult_withValidKey_returnsValue() throws {
        let dict: [String: Any] = ["name": "John", "age": 30]

        let name: String = try dict.getOrErrorResult(
            for: "name",
            baseError: "Test",
            result: mockResult
        )
        let age: Int = try dict.getOrErrorResult(
            for: "age",
            baseError: "Test",
            result: mockResult
        )

        XCTAssertEqual(name, "John")
        XCTAssertEqual(age, 30)
        XCTAssertNil(resultError)
    }

    func testGetOrErrorResult_withMissingKey_returnsError() {
        let dict: [String: Any] = ["name": "John"]

        XCTAssertThrowsError(try dict.getOrErrorResult(
            for: "age",
            baseError: "Test",
            result: mockResult
        ) as Int)

        XCTAssertNotNil(resultError)
        XCTAssertEqual(resultError?.code, ErrorCodes.MissingParameter)
        XCTAssertTrue(resultError?.message?.contains("Test: Missing parameter 'age'") ?? false)
    }

    func testGetOrErrorResult_withNullValue_returnsError() {
        let dict: [String: Any] = ["name": NSNull()]

        XCTAssertThrowsError(try dict.getOrErrorResult(
            for: "name",
            baseError: "Test",
            result: mockResult
        ) as String)

        XCTAssertNotNil(resultError)
        XCTAssertEqual(resultError?.code, ErrorCodes.MissingParameter)
        XCTAssertTrue(resultError?.message?.contains("Test: Missing parameter 'name'") ?? false)
    }

    func testGetOrErrorResult_withWrongType_returnsError() {
        let dict: [String: Any] = ["age": 30]

        XCTAssertThrowsError(try dict.getOrErrorResult(
            for: "age",
            baseError: "Test",
            result: mockResult
        ) as String)

        XCTAssertNotNil(resultError)
        XCTAssertEqual(resultError?.code, ErrorCodes.UnexpectedParameterType)
        XCTAssertTrue(resultError?.message?.contains("Test: Value for 'age' is not of type String") ?? false)
    }

    // MARK: - Dictionary getOrErrorResult Tests (with default)

    func testGetOrErrorResultWithDefault_withValidKey_returnsValue() throws {
        let dict: [String: Any] = ["name": "John"]

        let name: String = try dict.getOrErrorResult(
            for: "name",
            withDefault: "Default",
            baseError: "Test",
            result: mockResult
        )

        XCTAssertEqual(name, "John")
        XCTAssertNil(resultError)
    }

    func testGetOrErrorResultWithDefault_withMissingKey_returnsDefault() throws {
        let dict: [String: Any] = ["name": "John"]

        let age: Int = try dict.getOrErrorResult(
            for: "age",
            withDefault: 25,
            baseError: "Test",
            result: mockResult
        )

        XCTAssertEqual(age, 25)
        XCTAssertNil(resultError)
    }

    func testGetOrErrorResultWithDefault_withNullValue_returnsDefault() throws {
        let dict: [String: Any] = ["name": NSNull()]

        let name: String = try dict.getOrErrorResult(
            for: "name",
            withDefault: "Default",
            baseError: "Test",
            result: mockResult
        )

        XCTAssertEqual(name, "Default")
        XCTAssertNil(resultError)
    }

    func testGetOrErrorResultWithDefault_withWrongType_returnsError() {
        let dict: [String: Any] = ["age": 30]

        XCTAssertThrowsError(try dict.getOrErrorResult(
            for: "age",
            withDefault: "0",
            baseError: "Test",
            result: mockResult
        ))

        XCTAssertNotNil(resultError)
        XCTAssertEqual(resultError?.code, ErrorCodes.UnexpectedParameterType)
    }

    // MARK: - getStringOrErrorResult Tests (no default)

    func testGetStringOrErrorResult_withValidString_returnsString() throws {
        let dict: [String: Any] = ["name": "  John  "]

        let name = try dict.getStringOrErrorResult(
            for: "name",
            baseError: "Test",
            acceptEmptyValue: false,
            result: mockResult
        )

        XCTAssertEqual(name, "John")
        XCTAssertNil(resultError)
    }

    func testGetStringOrErrorResult_withEmptyString_whenNotAccepted_returnsError() {
        let dict: [String: Any] = ["name": "   "]

        XCTAssertThrowsError(try dict.getStringOrErrorResult(
            for: "name",
            baseError: "Test",
            acceptEmptyValue: false,
            result: mockResult
        ))

        XCTAssertNotNil(resultError)
        XCTAssertEqual(resultError?.code, ErrorCodes.InvalidParameter)
        XCTAssertTrue(resultError?.message?.contains("Test: Value for 'name' cannot be empty") ?? false)
    }

    func testGetStringOrErrorResult_withEmptyString_whenAccepted_returnsEmptyString() throws {
        let dict: [String: Any] = ["name": "   "]

        let name = try dict.getStringOrErrorResult(
            for: "name",
            baseError: "Test",
            acceptEmptyValue: true,
            result: mockResult
        )

        XCTAssertEqual(name, "")
        XCTAssertNil(resultError)
    }

    // MARK: - getStringOrErrorResult Tests (with default)

    func testGetStringOrErrorResultWithDefault_withValidString_returnsString() throws {
        let dict: [String: Any] = ["name": "  John  "]

        let name = try dict.getStringOrErrorResult(
            for: "name",
            withDefault: "Default",
            baseError: "Test",
            acceptEmptyValue: false,
            result: mockResult
        )

        XCTAssertEqual(name, "John")
        XCTAssertNil(resultError)
    }

    func testGetStringOrErrorResultWithDefault_withMissingKey_returnsDefault() throws {
        let dict: [String: Any] = ["age": 30]

        let name = try dict.getStringOrErrorResult(
            for: "name",
            withDefault: "Default",
            baseError: "Test",
            acceptEmptyValue: false,
            result: mockResult
        )

        XCTAssertEqual(name, "Default")
        XCTAssertNil(resultError)
    }

    func testGetStringOrErrorResultWithDefault_withEmptyString_whenNotAccepted_returnsDefault() throws {
        let dict: [String: Any] = ["name": "   "]

        let name = try dict.getStringOrErrorResult(
            for: "name",
            withDefault: "Default",
            baseError: "Test",
            acceptEmptyValue: false,
            result: mockResult
        )

        XCTAssertEqual(name, "Default")
        XCTAssertNil(resultError)
    }

    // MARK: - Optional Dictionary Tests

    func testOptionalGetOrErrorResult_withNilDictionary_returnsError() {
        let dict: [String: Any]? = nil

        XCTAssertThrowsError(try dict.getOrErrorResult(
            for: "name",
            baseError: "Test",
            result: mockResult
        ) as String)

        XCTAssertNotNil(resultError)
        XCTAssertEqual(resultError?.code, ErrorCodes.MissingParameter)
        XCTAssertTrue(resultError?.message?.contains("Test: Arguments dictionary is nil") ?? false)
    }

    func testOptionalGetOrErrorResult_withValidDictionary_returnsValue() throws {
        let dict: [String: Any]? = ["name": "John"]

        let name: String = try dict.getOrErrorResult(
            for: "name",
            baseError: "Test",
            result: mockResult
        )

        XCTAssertEqual(name, "John")
        XCTAssertNil(resultError)
    }

    func testOptionalGetOrErrorResultWithDefault_withNilDictionary_returnsError() {
        let dict: [String: Any]? = nil

        XCTAssertThrowsError(try dict.getOrErrorResult(
            for: "name",
            withDefault: "Default",
            baseError: "Test",
            result: mockResult
        ))

        XCTAssertNotNil(resultError)
        XCTAssertEqual(resultError?.code, ErrorCodes.MissingParameter)
    }
}
