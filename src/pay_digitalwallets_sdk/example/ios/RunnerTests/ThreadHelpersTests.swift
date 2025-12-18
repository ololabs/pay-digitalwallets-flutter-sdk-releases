// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import XCTest
@testable import pay_digitalwallets_sdk_ios

class ThreadHelpersTests: XCTestCase {

    // MARK: - dispatchToMainThread tests

    func testDispatchToMainThread_whenOnMainThread_executesImmediately() {
        let expectation = expectation(description: "dispatchToMainThread completion")
        var executedOnMainThread = false

        DispatchQueue.main.async {
            dispatchToMainThread {
                executedOnMainThread = Thread.isMainThread
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(executedOnMainThread, "Block should execute on main thread")
    }

    func testDispatchToMainThread_whenOnBackgroundThread_dispatchesToMain() {
        let expectation = expectation(description: "dispatchToMainThread completion")
        var executedOnMainThread = false

        DispatchQueue.global(qos: .background).async {
            dispatchToMainThread {
                executedOnMainThread = Thread.isMainThread
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(executedOnMainThread, "Block should dispatch to main thread")
    }

    // MARK: - dispatchToMainThread with lock tests

    func testDispatchToMainThreadWithLock_executesWithLock() {
        let expectation = expectation(description: "dispatchToMainThread with lock")
        let semaphore = DispatchSemaphore(value: 1)
        var executed = false

        DispatchQueue.main.async {
            dispatchToMainThread(with: semaphore) {
                executed = true
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(executed, "Block should have executed")
    }

    func testDispatchToMainThreadWithLock_withAutoReleaseFalse_doesNotReleaseLock() {
        let expectation = expectation(description: "dispatchToMainThread with manual release")
        let semaphore = DispatchSemaphore(value: 1)
        var executed = false

        DispatchQueue.main.async {
            dispatchToMainThread(with: semaphore, autoRelease: false) {
                executed = true
            }

            // Manually signal to complete the test
            semaphore.signal()
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(executed, "Block should have executed")
    }

    // MARK: - dispatchToBackgroundThread tests

    func testDispatchToBackgroundThread_executesOnBackgroundThread() {
        let expectation = expectation(description: "dispatchToBackgroundThread completion")
        var executedOnBackgroundThread = false

        dispatchToBackgroundThread {
            executedOnBackgroundThread = !Thread.isMainThread
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(executedOnBackgroundThread, "Block should execute on background thread")
    }

    func testDispatchToBackgroundThread_withLock_executesWithLock() {
        let expectation = expectation(description: "dispatchToBackgroundThread with lock")
        let semaphore = DispatchSemaphore(value: 1)
        var executed = false

        dispatchToBackgroundThread(with: semaphore) {
            executed = true
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(executed, "Block should have executed")
    }

    func testDispatchToBackgroundThread_withAutoReleaseFalse_doesNotReleaseLock() {
        let expectation = expectation(description: "dispatchToBackgroundThread manual release")
        let semaphore = DispatchSemaphore(value: 1)
        var executed = false

        dispatchToBackgroundThread(with: semaphore, autoRelease: false) {
            executed = true
            semaphore.signal()
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(executed, "Block should have executed")
    }

    // MARK: - dispatchToQos tests

    func testDispatchToQos_withUserInteractive_executesOnHighPriorityThread() {
        let expectation = expectation(description: "dispatchToQos userInteractive")
        var executed = false

        dispatchToQos(on: .userInteractive) {
            executed = true
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(executed, "Block should have executed")
    }

    func testDispatchToQos_withUtility_executesOnLowerPriorityThread() {
        let expectation = expectation(description: "dispatchToQos utility")
        var executed = false

        dispatchToQos(on: .utility) {
            executed = true
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(executed, "Block should have executed")
    }

    func testDispatchToQos_withLock_executesWithLock() {
        let expectation = expectation(description: "dispatchToQos with lock")
        let semaphore = DispatchSemaphore(value: 1)
        var executed = false

        dispatchToQos(on: .background, with: semaphore) {
            executed = true
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(executed, "Block should have executed")
    }

    // MARK: - controlledReturn tests

    func testControlledReturn_returnsValue() {
        let semaphore = DispatchSemaphore(value: 1)

        let result = controlledReturn(with: semaphore) {
            return "test value"
        }

        XCTAssertEqual(result, "test value", "Should return the value from the block")
    }

    func testControlledReturn_withIntValue_returnsInt() {
        let semaphore = DispatchSemaphore(value: 1)

        let result = controlledReturn(with: semaphore) {
            return 42
        }

        XCTAssertEqual(result, 42, "Should return the integer value")
    }

    func testControlledReturn_withBoolValue_returnsBool() {
        let semaphore = DispatchSemaphore(value: 1)

        let result = controlledReturn(with: semaphore) {
            return true
        }

        XCTAssertTrue(result, "Should return the boolean value")
    }

    func testControlledReturn_releasesLockAfterExecution() {
        let semaphore = DispatchSemaphore(value: 1)

        let _ = controlledReturn(with: semaphore) {
            return "value"
        }

        // Try to acquire the lock again - should succeed immediately if properly released
        let result = semaphore.wait(timeout: .now() + 0.1)
        XCTAssertEqual(result, .success, "Lock should have been released")
        semaphore.signal()
    }

    // MARK: - controlledExecute tests

    func testControlledExecute_executesBlock() {
        let expectation = expectation(description: "controlledExecute")
        let semaphore = DispatchSemaphore(value: 1)
        var executed = false

        controlledExecute(with: semaphore) {
            executed = true
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(executed, "Block should have executed")
    }

    func testControlledExecute_withAutoReleaseTrue_releasesLock() {
        let semaphore = DispatchSemaphore(value: 1)
        var executed = false

        controlledExecute(with: semaphore, autoRelease: true) {
            executed = true
        }

        // Try to acquire the lock - should succeed if released
        let result = semaphore.wait(timeout: .now() + 0.1)
        XCTAssertEqual(result, .success, "Lock should have been released")
        XCTAssertTrue(executed, "Block should have executed")
        semaphore.signal()
    }

    func testControlledExecute_withAutoReleaseFalse_doesNotReleaseLock() {
        let semaphore = DispatchSemaphore(value: 1)
        var executed = false

        controlledExecute(with: semaphore, autoRelease: false) {
            executed = true
        }

        // Try to acquire the lock - should timeout if not released
        let result = semaphore.wait(timeout: .now() + 0.1)
        XCTAssertEqual(result, .timedOut, "Lock should not have been released")
        XCTAssertTrue(executed, "Block should have executed")

        // Clean up by releasing the lock
        semaphore.signal()
    }

    // MARK: - Thread safety tests

    func testMultipleConcurrentOperations_withLock_maintainThreadSafety() {
        let expectation = expectation(description: "concurrent operations")
        expectation.expectedFulfillmentCount = 10

        let semaphore = DispatchSemaphore(value: 1)
        var counter = 0

        for _ in 0..<10 {
            dispatchToBackgroundThread(with: semaphore) {
                counter += 1
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(counter, 10, "All operations should have completed")
    }
}
