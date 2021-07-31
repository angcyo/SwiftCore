//
// Created by wayto on 2021/7/31.
//

import Foundation

class ViewModelStore {

    /// 单例
    static let shared: ViewModelStore = {
        let instance = ViewModelStore()
        return instance
    }()

    /// 存储
    var viewModels: [ViewModel] = []
}

/// 获取指定类型的[ViewModel]
func vm<T: ViewModel>(_ cls: T.Type) -> T {
    var result: T? = nil
    for item in ViewModelStore.shared.viewModels {
        if item is T {
            result = item as! T
            break
        }
    }
    if result == nil {
        result = cls.init()
        ViewModelStore.shared.viewModels.append(result!)
    }
    return result!
}