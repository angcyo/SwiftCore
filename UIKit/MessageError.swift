//
// Created by angcyo on 21/08/10.
//

import Foundation

class MessageError: Error {

    var message: String

    init(message: String) {
        self.message = message
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

func messageError(_ message: String) -> MessageError {
    MessageError(message: message)
}