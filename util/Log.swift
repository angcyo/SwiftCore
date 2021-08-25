//
// Created by wayto on 2021/7/28.
//

import Foundation

func logObj(_ obj: Any, _ prefix: String? = nil, newLine: Bool = false, debug: Bool = D.isDebug) {
    if debug {
        if newLine {
            Swift.debugPrint()
        }
        if let prefix = prefix {
            Swift.debugPrint(prefix, obj)
        } else {
            Swift.debugPrint(obj)
        }
    } else {
        if newLine {
            Swift.print()
        }
        if let prefix = prefix {
            Swift.print(prefix, obj)
        } else {
            Swift.print(obj)
        }
    }
}

func logObjNewLine(_ obj: Any, _ prefix: String? = nil, _ debug: Bool = D.isDebug) {
    logObj(obj, prefix, newLine: true, debug: debug)
}

extension NSObject {

    /// 打印日志
    func log(_ prefix: String? = nil, _ debug: Bool = true) {
        logObj(self, prefix, debug: debug)
    }
}

/// 字典数据类型
extension Dictionary {
    /// 打印日志
    func log(_ prefix: String? = nil, _ debug: Bool = true) {
        logObj(self, prefix, debug: debug)
    }
}

extension Int {
    /// 打印日志
    func log(_ prefix: String? = nil, _ debug: Bool = true) {
        logObj(self, prefix, debug: debug)
    }
}

/// 线程名
func threadName() -> String {
    var name = Thread.current.name
    let main = Thread.current.isMainThread

    if nilOrEmpty(name) {
        name = Thread.current.description
    }

    if main {
        return "[main]\(name!)"
    }

    return name!
}