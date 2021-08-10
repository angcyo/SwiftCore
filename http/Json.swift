//
// Created by angcyo on 21/08/10.
//

import Foundation
import SwiftyJSON

extension NSData {
    /// NSData 转换成 Dictionary
    func toDictionary() -> Dictionary<String, Any>? {
        (self as Data).toDictionary()
    }
}

extension String {
    func toData() -> Data? {
        data(using: .utf8, allowLossyConversion: false)
    }
}

extension Data {

    func toDictionary() -> Dictionary<String, Any>? {
        let json = try? JSON(data: self)
        return json?.dictionaryObject
    }

    func toUIImage() -> UIImage? {
        UIImage(data: self)
    }
}

extension JSON {

    /// 在当前key对应的数组上, 追加数据
    mutating func add(_ path: JSONSubscriptType..., value: JSON) {
        add(path.map {
            $0
        }, value: value)
    }

    mutating func add(_ path: [JSONSubscriptType], value: JSON) {
        ensurePath(path)
        var array = self[path].arrayValue
        array.append(value)
        self[path] = JSON(array)
    }

    /// 补齐不存在的路径
    mutating func ensurePath(_ path: JSONSubscriptType...) {
        ensurePath(path.map {
            $0
        })
    }

    mutating func ensurePath(_ path: [JSONSubscriptType]) {
        var _p = [JSONSubscriptType]()
        for p in path {
            _p.append(p)
            if self[_p].exists() {
                //路径存在
            } else {
                //创建路径
                self[_p] = JSON()
            }
        }
    }

    func rawStringOrNil() -> String? {
        if self.exists() {
            return rawString()
        }
        return nil
    }
}