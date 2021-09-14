//
// Created by wayto on 2021/8/3.
//

import Foundation

extension Locale {
    static var cn: Locale {
        Locale(identifier: "zh_Hans_CN")
    }
}

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

    /// 格式化时间
    func format(_ pattern: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pattern
        let dateStr = dateFormatter.string(from: Date())
        return dateStr
    }

    static func from(_ string: String, pattern: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pattern
        let date = dateFormatter.date(from: string)
        return date
    }
}

/// 当前时间秒 1627973675.1392469    //978307200
var nowTime: Double {
    Date().timeIntervalSince1970
}

func dayTimeString(_ pattern: String = "yyyy-MM-dd") -> String {
    Date().format(pattern)
}

func nowTimeString(_ pattern: String = "yyyy-MM-dd HH:mm:ss") -> String {
    Date().format(pattern)
}
