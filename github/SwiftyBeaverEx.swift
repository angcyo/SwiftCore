//
// Created by angcyo on 21/08/27.
//

import Foundation
import SwiftyBeaver

///# 日志输出 https://github.com/SwiftyBeaver/SwiftyBeaver
///pod 'SwiftyBeaver' #1.9.5

/// 日志框架
let L = SwiftyBeaver.self

extension SwiftyBeaver {

    static func v(_ message: Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        L.verbose(message, file, function, line: line)
    }

    static func d(_ message: Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        L.debug(message, file, function, line: line)
    }

    static func i(_ message: Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        L.info(message, file, function, line: line)
    }

    static func w(_ message: Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        L.warning(message, file, function, line: line)
    }

    static func e(_ message: Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        L.error(message, file, function, line: line)
    }
}

struct SwiftyBeaverEx {

    static func initSwiftyBeaver() {

        let format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c $N.$F:$l $T - $M"
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()  // log to Xcode Console

        console.format = format
        file.format = format
        //"$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
        // add the destinations to SwiftyBeaver

        console.asynchronously = false //关闭异步
        file.minLevel = .info
        //https://docs.swiftybeaver.com/article/10-log-to-file
        //file.logFileURL = URL(fileURLWithPath: "/tmp/app_info.log")  // tmp is just possible for a macOS app

        L.addDestination(console)
        L.addDestination(file)

        if D.isDebug {
            let cloud = SBPlatformDestination(appID: "PVnk9Z", appSecret: "3lslwkeektzknqmzoiCslhlmirpidzMh", encryptionKey: "QUA4tHfvlQtjx4hi2pwjtkmdnc0Sdnrf") // to cloud
            cloud.format = format
            L.addDestination(cloud)
        }
    }
}