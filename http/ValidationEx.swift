//
// Created by angcyo on 21/08/21.
//

import Foundation
import Alamofire
import RxSwift

extension DataRequest {

    /// 验证接口是否401, 如果是, 跳转登录页面
    func validateAuth() -> DataRequest {
        validate { request, response, data in
            if response.statusCode == 401 {
                /// 授权失败
                return .failure(messageError("服务器授权失败"))
            } else {
                return .success(())
            }
        }
    }
}

extension ObservableType where Element == DataRequest {

    func validateAuth() -> Observable<Element> {
        validate { request, response, data in
            if response.statusCode == 401 {
                /// 授权失败
                return .failure(messageError("服务器授权失败"))
            } else {
                return .success(())
            }
        }
    }
}