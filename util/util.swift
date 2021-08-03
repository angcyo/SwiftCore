//
// Created by wayto on 2021/8/3.
//

import Foundation
import UIKit

/// 转换成类名, 类似:"Wayto_GBSecurity_iOS.LoginController"
func toClassName(_ anyClass: AnyClass) -> String {
    NSStringFromClass(anyClass)
}

//// 类型转换成对象
func toViewController<T: NSObject>(_ type: T.Type = T.self) -> T {
    type.init()
}

