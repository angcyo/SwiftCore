//
// Created by wayto on 2021/7/28.
//

import Foundation

func logObj(_ obj: Any, _ prefix: String = "", _ debug: Bool = D.isBeingDebugged) {
    if debug {
        Swift.debugPrint(prefix, obj)
    } else {
        Swift.print(prefix, obj)
    }
}

extension NSObject {

    /// 打印日志
    func log(_ prefix: String = "", _ debug: Bool = true) {
        logObj(self, prefix, debug)
    }
}

/// 字典数据类型
extension Dictionary {
    /// 打印日志
    func log(_ prefix: String = "", _ debug: Bool = true) {
        logObj(self, prefix, debug)
    }
}

extension Int {
    /// 打印日志
    func log(_ prefix: String = "", _ debug: Bool = true) {
        logObj(self, prefix, debug)
    }
}

/// 线程名
func threadName() -> String {
    let name = Thread.current.name
    if name?.isEmpty == true {
        return Thread.current.description
    }
    return name!
}