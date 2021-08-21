//
// Created by wayto on 2021/7/30.
//

import Foundation

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

    /// 初始化入口
    class func initCore() {
        Dialog.initDialog()
    }

    static var DEF_NIL_STRING = "--"

}

func hold(_ obj: NSObject) {
    Core.shared.holdObjs.insert(obj)
}

func holdRemove(_ obj: NSObject) {
    Core.shared.holdObjs.remove(obj)
}