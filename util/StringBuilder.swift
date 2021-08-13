//
// Created by angcyo on 21/08/12.
//

import Foundation

class StringBuilder {

    var _raw: String = ""

    func append(_ str: String?) {
        if let str = str {
            _raw.append(str)
        }
    }

    func append(_ c: Character?) {
        if let c = c {
            _raw.append(c)
        }
    }

    func append(_ obj: Any?) {
        if let obj = obj {
            append("\(obj)")
        }
    }

    func appendLine() {
        append("\n")
    }

    func appendLine(_ str: String?) {
        if let str = str {
            append(str)
            appendLine()
        }
    }

    func appendLine(_ obj: Any?) {
        if let obj = obj {
            append(obj)
            appendLine()
        }
    }

    func build() -> String {
        _raw
    }
}

func buildString(_ action: (StringBuilder) -> Void) -> String {
    let builder = StringBuilder()
    action(builder)
    return builder.build()
}