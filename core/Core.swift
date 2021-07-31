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

    /// 存储
    var holdObjs: Set<NSObject> = []

    /// 初始化入口
    class func initCore() {
        Dialog.initDialog()
    }

}

func hold(_ obj: NSObject) {
    Core.shared.holdObjs.insert(obj)
}

func holdRemove(_ obj: NSObject) {
    Core.shared.holdObjs.remove(obj)
}