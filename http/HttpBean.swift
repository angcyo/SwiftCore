//
// Created by wayto on 2021/8/3.
//

import Foundation

/// {"code":400,"msg":"验证码信息错误","data":""}
struct HttpBean<T: Codable>: Codable {
    var code: String? = nil
    var msg: String? = nil
    var data: T? = nil
}