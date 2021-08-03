//
// Created by wayto on 2021/8/3.
//

import Foundation

extension Date {

    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval * 1000))
        return "\(millisecond)"
    }
}

/// 当前时间秒 1627973675.1392469 978307200
var nowTime: Double {
    Date().timeIntervalSince1970
}
