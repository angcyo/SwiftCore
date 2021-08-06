//
// Created by angcyo on 21/08/06.
//

import Foundation
import RxSwift

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

///
func liveData<Element: NilObject>(_ value: Element) -> BehaviorSubject<Element> {
    BehaviorSubject<Element>(value: value)
}