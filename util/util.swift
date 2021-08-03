//
// Created by wayto on 2021/8/3.
//

import Foundation
import UIKit
import AdSupport

struct Util {
    /// 生成一个uuid AFFCC3DF-3D93-4E96-B749-187FF3F2B51A
    static func uuid() -> String {
        UUID().uuidString
    }
}

/// 转换成类名, 类似:"Wayto_GBSecurity_iOS.LoginController"
func toClassName(_ anyClass: AnyClass) -> String {
    NSStringFromClass(anyClass)
}

//// 类型转换成对象
func toViewController<T: NSObject>(_ type: AnyClass) -> T {
    (type as! NSObject.Type).init() as! T
}

/// 生成一个uuid
func uuid() -> String {
    UUID().uuidString
}

/// 广告 id IDFA
var adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString

var idfv = UIDevice.current.identifierForVendor?.uuidString