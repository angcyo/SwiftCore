//
// Created by angcyo on 21/08/21.
//

import Foundation
import Alamofire
import RxSwift

fileprivate func _validateAuth(request: URLRequest?, response: HTTPURLResponse, data: Data?) -> Request.ValidationResult {
    if response.statusCode == 401 {
        /// 授权失败
        return .failure(messageError("服务器授权失败"))
    } else {
        return .success(())
    }
}

fileprivate func _log(request: URLRequest?, response: HTTPURLResponse, data: Data?) -> Request.ValidationResult {
    print("[\(threadName())] 请求返回↓ \(request?.method)")
    print(request, response, data)
    return .success(())
}

//MARK: request

extension DataRequest {

    /// 验证接口是否401, 如果是, 跳转登录页面
    func validateAuth() -> DataRequest {
        validate { request, response, data in
            _validateAuth(request: request, response: response, data: data)
        }
    }

    func validateCode(statusCode acceptableStatusCodes: ClosedRange<Int> = 200...299) -> DataRequest {
        validate(statusCode: acceptableStatusCodes)
    }

    /// 日志输出
    func log() -> DataRequest {
        validate { request, response, data in
            _log(request: request, response: response, data: data)
        }
    }
}

//MARK: Rx

extension ObservableType where Element == DataRequest {

    func validateAuth() -> Observable<Element> {
        validate { request, response, data in
            _validateAuth(request: request, response: response, data: data)
        }
    }

    func validateCode(statusCode acceptableStatusCodes: ClosedRange<Int> = 200...299) -> Observable<Element> {
        validate(statusCode: acceptableStatusCodes)
    }

    func log() -> Observable<Element> {
        validate { request, response, data in
            _log(request: request, response: response, data: data)
        }
    }
}