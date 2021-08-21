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