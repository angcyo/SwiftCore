//
// Created by angcyo on 21/08/10.
//

import Foundation
import DefaultsKit

/// https://github.com/nmdias/DefaultsKit
/// https://github.com/nmdias/DefaultsKit/blob/master/README.zh-CN.md

extension Key {
    func defGet() -> ValueType? {
        let defaults = Defaults.shared
        return defaults.get(for: self)
    }

    func defSet(_ value: ValueType?) {
        let defaults = Defaults.shared
        if let value = value {
            defaults.set(value, for: self)
        } else {
            defaults.clear(self)
        }
    }

    func defHas() -> Bool {
        let defaults = Defaults.shared
        return defaults.has(self)
    }

    func defClear() {
        let defaults = Defaults.shared
        defaults.clear(self)
    }
}

/// 快速通过字符串对应的key, 获取保存的value
extension String {

    /// 获取值
    func defGet<ValueType: Codable>() -> ValueType? {
        let defaults = Defaults.shared
        let key = Key<ValueType>(self)
        return defaults.get(for: key)
    }

    /// 设置值
    func defSet<ValueType: Codable>(_ value: ValueType?) {
        let defaults = Defaults.shared
        let key = Key<ValueType>(self)
        if let value = value {
            defaults.set(value, for: key)
        } else {
            defaults.clear(key)
        }
    }

    /// 是否有值
    func defHas() -> Bool {
        let defaults = Defaults.shared
        let key = Key<String>(self)
        return defaults.has(key)
    }
}

