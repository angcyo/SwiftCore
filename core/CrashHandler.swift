//
// Created by angcyo on 21/09/06.
//

import Foundation

/// https://github.com/ChaselAn/DinergateBrain

struct CrashHandler {

    private static var oldAppExceptionHandler: (@convention(c) (NSException) -> Void)?

    /// 崩溃捕捉
    static func initCrashHandler() {
        oldAppExceptionHandler = NSGetUncaughtExceptionHandler()
        NSSetUncaughtExceptionHandler(CrashHandler.onUncaughtExceptionHandler)
    }

    private static let onUncaughtExceptionHandler: @convention(c) (NSException) -> Void = { exception in
        var error = "\(error)"

        L.e("异常:\(exception)")
        exception.callStackSymbols.forEach {
            L.w($0)
            error.append("\n")
            error.append($0)
        }

        //error.saveToFile(path: "crash".toPath(.userHome), name: "\(nowTimeString()).log")
        ///var/mobile/Containers/Data/Application/D1D29368-F11B-47D0-98E3-584D8363617B/Library/Caches
        error.saveToFile(path: .userCaches, name: "\(nowTimeString()).log")

        //old
        if let oldAppExceptionHandler = CrashHandler.oldAppExceptionHandler {
            oldAppExceptionHandler(exception)
        }
    }
}