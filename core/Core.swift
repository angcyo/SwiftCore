//
// Created by wayto on 2021/7/30.
//

import Foundation
import AlamofireEasyLogger

class Core {

    /// 单例
    static let shared: Core = {
        let instance = Core()
        return instance
    }()

    /// 维持对象, 逃避ARC
    var holdObjs: Set<NSObject> = []

    ///
    var uuid: String = Util.uuid()

    //网络日志
    let alamofireLogger = FancyAppAlamofireLogger(prettyPrint: true) {
        print()
        L.i($0, #file, #function, #line)
    }

    /// 初始化入口
    func initCore() {
        uuid = UIDevice.current.identifierForVendor?.uuidString ?? Util.uuid()

        CrashHandler.initCrashHandler()
        Dialog.initDialog()
        SwiftyBeaverEx.initSwiftyBeaver()

        // 全屏侧滑手势, 启用
        SHFullscreenPopGesture.configure()
    }

    /// 空字符时的占位字符
    static var DEF_NIL_STRING = "--"

    /// /var/mobile/Containers/Data/Application/D1D29368-F11B-47D0-98E3-584D8363617B
    static var HOME = NSHomeDirectory()

    /// /var/mobile/Containers/Data/Application/D1D29368-F11B-47D0-98E3-584D8363617B/Library/Caches
    static var CACHES = Path.userCaches
}

///单例保持对象, 防止ARC
func hold(_ obj: NSObject) {
    Core.shared.holdObjs.insert(obj)
}

///移除
func holdRemove(_ obj: NSObject) {
    Core.shared.holdObjs.remove(obj)
}