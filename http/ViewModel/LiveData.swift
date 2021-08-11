//
// Created by angcyo on 21/08/06.
//

import Foundation
import RxSwift
import SwiftyJSON

/// 用来判断对象是否为nil
protocol NilObject {
    var isNil: Bool { get }
}

extension BehaviorSubject {

    /// 获取可能为nil的值
    func valueOrNil() -> Element? {
        do {
            let value = try value()
            if let nilObj = value as? NilObject {
                if nilObj.isNil {
                    return nil
                }
            }
            return value
        } catch {
            debugPrint("error->\(error)")
            return nil
        }
    }
}

extension JSON: NilObject {
    var isNil: Bool {
        if null != nil || !exists() {
            return true
        }
        if let d = dictionary {
            return d.isEmpty
        }
        if let a = array {
            return a.isEmpty
        }
        return false
    }
}

/// 可以观察的数据对象
func liveData<Bean: NilObject>(_ value: Bean) -> BehaviorSubject<Bean> {
    BehaviorSubject<Bean>(value: value)
}