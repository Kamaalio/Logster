//
//  LogsterTests.swift
//
//
//  Created by Kamaal M Farah on 20/09/2022.
//

import XCTest
@testable import Logster

final class LogsterTests: XCTestCase {
    var logger: Logster!

    override func setUpWithError() throws {
        let holder = LogHolder(max: 1)
        logger = .init(subsystem: "io.kamaal.Testing", from: LogsterTests.self, holder: holder)
    }

    func testErrorLogged() async throws {
        let label = "Oh No!"
        let error = TestError.test
        logger.error(label: label, error: error)

        let log = try await getLog()
        XCTAssert(log.message.contains(label))
        XCTAssert(log.message.contains(error.localizedDescription))
        XCTAssertEqual(log.label, String(describing: LogsterTests.self))
        XCTAssertEqual(log.type, .error)
        XCTAssertEqual(log.type.color, .red)
    }

    func testWarningLogged() async throws {
        let message1 = "Oh well! 🤷"
        let message2 = "Go on as usual"
        logger.warning(message1, message2)

        let log = try await getLog()
        XCTAssert(log.message.contains(message1))
        XCTAssert(log.message.contains(message2))
        XCTAssertEqual(log.label, String(describing: LogsterTests.self))
        XCTAssertEqual(log.type, .warning)
        XCTAssertEqual(log.type.color, .yellow)
    }

    func testInfoLogged() async throws {
        let message1 = "Phew!"
        let message2 = "Run Forest Run"
        logger.info(message1, message2)

        let log = try await getLog()
        XCTAssert(log.message.contains(message1))
        XCTAssert(log.message.contains(message2))
        XCTAssertEqual(log.label, String(describing: LogsterTests.self))
        XCTAssertEqual(log.type, .info)
        XCTAssertEqual(log.type.color, .green)
    }

    private func getLog() async throws -> HoldedLog {
        var log: HoldedLog!
        try await expectToEventually({
            log = await logger.holder?.logs.first
            return log != nil
        }, timeout: 0.5, message: "Getting log")
        return log
    }
}

enum TestError: LocalizedError {
    case test

    public var errorDescription: String? {
        return "something horrible happened"
    }
}

extension XCTestCase {
    func expectToEventually(_ test: () async -> Bool, timeout: TimeInterval = 1, message: String = "") async throws {
        let timeoutDate = Date(timeIntervalSinceNow: timeout)
        repeat {
            let condition = await test()
            if condition {
                return
            }

            if #available(iOS 16.0, macOS 13.0, *) {
                try await Task.sleep(for: .milliseconds(100))
            } else {
                XCTFail("can't test on this version")
            }
        } while Date().compare(timeoutDate) == .orderedAscending

        XCTFail(message)
    }
}
