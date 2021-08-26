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

/// 数据包裹
class LiveData: NilObject {
    var isNil: Bool {
        data == nil
    }
    var data: Any? = nil

    init(_ data: Any?) {
        self.data = data
    }
}

extension String: NilObject {
    var isNil: Bool {
        isEmpty
    }
}

extension BehaviorSubject where Element: LiveData {

    /// 获取可能为nil的值
    func valueOrNil() -> Any? {
        do {
            let value = try value()
            if let liveData = value as? LiveData {
                if liveData.isNil {
                    return nil
                }
                return liveData.data
            }
            return nil
        } catch {
            print("error->\(error)")
            return nil
        }
    }

    func bean<Bean>() -> Bean? {
        valueOrNil() as? Bean
    }

    func data<Bean>() -> Bean? {
        valueOrNil() as? Bean
    }

    func beanOrNil<Bean>() -> Bean? {
        valueOrNil() as? Bean
    }

    /// 设置值
    func setValue(_ value: Any?) {
        onNext(LiveData(value) as! BehaviorSubject<Element>.Element)
    }

    /// 观察value or nil
    func observe(_ on: @escaping (Any?) -> Void) -> Disposable {
        subscribe(onNext: { value in
            if let liveData = value as? LiveData {
                if liveData.isNil {
                    on(nil)
                } else {
                    on(liveData.data)
                }
            } else {
                on(nil)
            }
        })
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

func liveData(_ type: Any /*类型提示*/) -> BehaviorSubject<LiveData> {
    liveData(value: nil)
}

/// 可以观察的数据对象
func liveData(value: Any? = nil) -> BehaviorSubject<LiveData> {
    let data = LiveData(value)
    return BehaviorSubject(value: data)
}