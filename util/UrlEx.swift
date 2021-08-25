//
// Created by angcyo on 21/08/24.
//

import Foundation

extension URL {

    func isHttp() -> Bool {
        scheme?.starts(with: "http") == true
    }

    func isFile() -> Bool {
        isFileURL
    }
}