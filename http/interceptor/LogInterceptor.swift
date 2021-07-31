//
// Created by wayto on 2021/7/31.
//

import Foundation
import Alamofire

///https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md
class LogInterceptor: RequestInterceptor {

    /// 适应请求
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> ()) {
        debugPrint("[\(threadName())] 请求:\(String(describing: urlRequest.url))")
        completion(.success(urlRequest))
    }

    /*func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> ()) {
        debugPrint("[\(threadName())] 请求重试:\(String(describing: request.request?.url))")
        completion(.doNotRetry)
    }*/
}