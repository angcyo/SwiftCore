//
// Created by wayto on 2021/8/3.
//

import Foundation

protocol HttpCodeProtocol: Codable {
    var code: Int? { get set }
    var msg: String? { get set }
}

/// {"code":400,"msg":"验证码信息错误","data":""}
struct HttpBean<T: Codable>: Codable, HttpCodeProtocol {
    var code: Int? = nil
    var msg: String? = nil
    var data: T? = nil
}

struct HttpListBean<T: Codable>: Codable, HttpCodeProtocol {
    var code: Int? = nil
    var msg: String? = nil
    var data: Array<T>? = nil
}