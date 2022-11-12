//
//  Logster.swift
//
//
//  Created by Kamaal M Farah on 20/09/2022.
//

import OSLog
import Foundation

/// Utility library to handle logging.
public struct Logster {
    private let logger: Logger
    let label: String
    let holder: LogHolder?

    /// Initialize with type as label.
    /// - Parameters:
    ///   - subsystem: Subsystem search term for console.
    ///   - type: The type to name the label when logging.
    ///   - holder: Custom ``LogHolder``.
    public init<T>(
        subsystem: String = Bundle.main.bundleIdentifier ?? "",
        from type: T.Type,
        holder: LogHolder = .shared) {
            self.init(subsystem: subsystem, label: String(describing: type), holder: holder)
        }

    /// Initialize with custom label.
    /// - Parameters:
    ///   - subsystem: Subsystem search term for console.
    ///   - label: The label to display when logging.
    ///   - holder: Custom ``LogHolder``.
    public init(subsystem: String = Bundle.main.bundleIdentifier ?? "", label: String, holder: LogHolder = .shared) {
        self.label = label
        self.logger = .init(subsystem: subsystem, category: label)
        self.holder = holder
    }

    /// To log errors
    /// - Parameter message: The message to log.
    public func error(_ message: String) {
        logger.error("\(message)")
        addLogToQueue(type: .error, message: message)
    }

    /// To log errors formatted with an extra label.
    /// - Parameters:
    ///   - label: The label to show before the error.
    ///   - error: The error to log.
    public func error(label: String, error: Error) {
        let message = [label, "description='\(error.localizedDescription)'", "error='\(error)'"].joined(separator: "; ")
        self.error(message)
    }

    /// To log warnings.
    /// - Parameter message: The message to log.
    public func warning(_ message: String) {
        logger.warning("\(message)")
        addLogToQueue(type: .warning, message: message)
    }

    /// To log warnings.
    /// - Parameter messages: The messages to log separated by a `; `.
    public func warning(_ messages: String...) {
        warning(messages.joined(separator: "; "))
    }

    /// To log information.
    /// - Parameter message: The message to log.
    public func info(_ message: String) {
        logger.info("\(message)")
        addLogToQueue(type: .info, message: message)
    }

    /// To log information.
    /// - Parameter messages: The messages to log separated by a `; `.
    public func info(_ messages: String...) {
        info(messages.joined(separator: "; "))
    }

    private func addLogToQueue(type: HoldedLog.LogTypes, message: String) {
        guard let holder else { return }

        Task {
            await holder.addLog(.init(label: label, type: type, message: message, timestamp: Date()))
        }
    }

    /// General logger labeled with `Tasktive`.
    public static let general = Logster(label: "Tasktive")
}
