//
// Created by angcyo on 21/08/27.
//

import Foundation
import SwiftyBeaver

///# 日志输出 https://github.com/SwiftyBeaver/SwiftyBeaver
///pod 'SwiftyBeaver' #1.9.5

/// 日志框架
/// https://docs.swiftybeaver.com/article/20-custom-format
let L = SwiftyBeaver.self

extension SwiftyBeaver {

    static func v(_ message: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        L.verbose(message ?? "null", file, function, line: line)
    }

    static func d(_ message: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        L.debug(message ?? "null", file, function, line: line)
    }

    static func i(_ message: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        L.info(message ?? "null", file, function, line: line)
    }

    static func w(_ message: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        L.warning(message ?? "null", file, function, line: line)
    }

    static func e(_ message: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        L.error(message ?? "null", file, function, line: line)
    }
}

struct SwiftyBeaverEx {

    /// https://docs.swiftybeaver.com/article/20-custom-format
    static func initSwiftyBeaver() {
        let format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c $N.$F:$l $T - $M"
        let file = FileDestination()  // log to Xcode Console
        file.format = "\(format) \n\n"
        //"$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
        // add the destinations to SwiftyBeaver
        file.minLevel = .info
        //https://docs.swiftybeaver.com/article/10-log-to-file
        file.logFileURL = URL(fileURLWithPath: "\(Core.CACHES)/log/\(nowTimeString("yyyy-MM-dd")).log")  // tmp is just possible for a macOS app

        if D.isDebug {
            let console = ConsoleDestination()  // log to Xcode Console
            console.format = format
            console.asynchronously = false //关闭异步
            L.addDestination(console)
        }
        L.addDestination(file)

        //连不上服务器 https://api.swiftybeaver.com/api/entries
        /*if D.isDebug {
            let cloud = SBPlatformDestination(appID: "PVnk9Z", appSecret: "3lslwkeektzknqmzoiCslhlmirpidzMh", encryptionKey: "QUA4tHfvlQtjx4hi2pwjtkmdnc0Sdnrf") // to cloud
            cloud.format = format
            L.addDestination(cloud)
        }*/
    }
}