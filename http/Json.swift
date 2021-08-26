//
// Created by angcyo on 21/08/10.
//

import Foundation
import UIKit
import SwiftyJSON

extension NSData {
    /// NSData 转换成 Dictionary
    func toDictionary() -> Dictionary<String, Any>? {
        (self as Data).toDictionary()
    }
}

extension Data {

    /// Data 转换成字符串
    func toString(_ encoding: String.Encoding = .utf8) -> String {
        String(data: self, encoding: encoding)!
        //String(decoding: self, as: UTF8.self)
    }
}

extension String {

    func toData() -> Data? {
        data(using: .utf8, allowLossyConversion: false)
    }

    /// 可解码
    func toBean<Bean>() -> Bean? where Bean: Decodable {
        let decoder = JSONDecoder()
        let decoded = try? decoder.decode(Bean.self, from: toData()!)
        return decoded
    }
}

/// 可编码
extension Encodable {
    func toJson() -> String? {
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(self)
        return encoded?.toString()
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

extension UIImage {

    func toData() -> Data? {
        //UIImagePNGRepresentation(self)
        pngData()
        //jpegData(compressionQuality: <#T##CGFloat##CoreGraphics.CGFloat#>)
    }

    func toJpegData(compressionQuality: CGFloat = 0.8) -> Data? {
        jpegData(compressionQuality: compressionQuality)
    }
}

/// https://github.com/SwiftyJSON/SwiftyJSON

extension JSON {

    /// 在当前key对应的数组上, 追加数据
    mutating func add(_ path: JSONSubscriptType..., value: JSON) {
        add(path.map {
            $0
        }, value: value)
    }

    mutating func add(_ path: [JSONSubscriptType], value: JSON) {
        let path = ensurePath(path)
        var array = self[path].arrayValue
        array.append(value)
        self[path] = JSON(array)
    }

    /// 补齐不存在的路径
    mutating func ensurePath(_ path: JSONSubscriptType...) -> [JSONSubscriptType] {
        ensurePath(path.map {
            $0
        })
    }

    /// 返回修正后的新路径. 处理了数组的索引
    mutating func ensurePath(_ path: [JSONSubscriptType]) -> [JSONSubscriptType] {
        var _p = [JSONSubscriptType]()
        for p in path {
            if p is String {
                var p2 = (p as! String)
                if p2.endWith("]") {
                    p2.removeLast()
                    _p.append(p2.toInt())
                } else if let index = Int(p2) {
                    //int类型, 要用数组的形式解析
                    _p.append(index)
                } else {
                    _p.append(p)
                }
            } else {
                _p.append(p)
            }
            if self[_p].exists() {
                //路径存在
            } else {
                //创建路径
                self[_p] = json()
            }
        }
        return _p
    }

    func rawStringOrNil() -> String? {
        if self.exists() {
            return rawString()
        }
        return nil
    }

    /// 枚举所有项
    mutating func each(action: (_ deepKey: String, _ value: JSON) -> Void) {
        each(parent: self, parentKey: nil, action: action)
    }

    func each(action: (_ deepKey: String, _ value: JSON) -> Void, end: (() -> Void)?) {
        each(parent: self, parentKey: nil, action: action)
        end?()
    }

    fileprivate func each(parent: JSON, parentKey: String?, action: (_ deepKey: String, _ value: JSON) -> Void) {
        parent.dictionaryValue.forEach { key, value in
            let deepKey: String
            if nilOrEmpty(parentKey) {
                deepKey = key
            } else {
                deepKey = "\(parentKey!).\(key)"
            }

            if let array = value.array {
                //如果是数组
                array.forEachIndex { json, index in
                    let arrayKey = "\(deepKey).\(index)"
                    each(parent: json, parentKey: arrayKey, action: action)
                }
            } else {
                action(deepKey, value)
                each(parent: value, parentKey: key, action: action)
            }
        }
    }


    /// - Parameters:
    ///   - key: 支持.号分割的路径, 如果key是]结尾, 则默认追加到数组中
    ///   - value: 支持JSON类型的数据
    ///   - putToArray: 是否将[value]追加到key对应的数组中
    mutating func put(_ key: String, _ value: Any?, putToArray: Bool = false) {
        var toArray = putToArray

        //数组判断
        var key = key
        if key.endWith("]") {
            toArray = true
            key.removeLast()
        }

        let keyList = key.splitString(separator: ".")
        let path = self.ensurePath(keyList)

        //空值不处理
        guard let value = value else {
            return
        }

        //value
        let _value: JSON
        if let value = value as? JSON {
            _value = value
        } else {
            _value = JSON(value)
        }

        if let error = _value.error {
            print("不支持的数据类型:", Swift.type(of: value), error)
        } else {
            //put
            if toArray {
                self.add(path, value: _value)
            } else {
                self[path] = _value
            }
        }
    }

    /// json为空
    func isJsonEmpty() -> Bool {
        var empty = null != nil

        if !empty {
            if let dictionary = dictionary {
                empty = dictionary.isEmpty
            }
        }

        if !empty {
            if let array = array {
                empty = array.isEmpty
            }
        }

        if !empty {
            if let string = string {
                empty = nilOrEmpty(string)
            }
        }

        return empty
    }
}

/// 快速创建JSON对象
func json() -> JSON {
    let json = JSON()
    return json
}

func jsonArray() -> JSON {
    let json = JSON([])
    return json
}