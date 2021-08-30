//
// Created by angcyo on 21/08/10.
//

import Foundation

class MessageError: Error, LocalizedError, CustomDebugStringConvertible, CustomStringConvertible {

    var message: String

    init(message: String) {
        self.message = message
    }

    //MARK: --

    var errorDescription: String? {
        message
    }

    var failureReason: String? {
        message
    }

    var description: String {
        "MessageError:\(message)"
    }

    var debugDescription: String {
        "MessageError:debug:\(message)"
    }
}

extension Error {
    var message: String {
        if let error = self as? MessageError {
            return error.message
        }
        return localizedDescription
    }
}


func error(_ message: String) -> MessageError {
    MessageError(message: message)
}

func apiError(_ message: String) -> MessageError {
    MessageError(message: message)
}