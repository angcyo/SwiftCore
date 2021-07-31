//
// Created by wayto on 2021/7/31.
//

import Foundation
import Alamofire

struct Api {

    /// 弱引用保存
    static var requestHold: [DataRequest] = []

    @discardableResult
    static func request(_ url: String,
                        _ parameters: Parameters? = nil,
                        method: HTTPMethod = .get,
                        config: ((Http) -> Void)? = nil,
                        _ onResult: @escaping (Dictionary<String, Any>?, Error?) -> Void) -> DataRequest {
        var request: DataRequest? = nil
        request = Http.request(url, parameters, method: method) { http in
                    http.encoding = URLEncoding.default
                    config?(http)
                }.validate(statusCode: 200...299)
                .responseJSON { response in
                    requestHold.remove(request!)
                    debugPrint("[\(threadName())] 请求结束:↓")
                    debugPrint(response)
                    switch response.result {
                    case .success:
                        onResult(response.value as? Dictionary, nil)
                    case let .failure(error):
                        onResult(nil, error)
                    }
                }
        requestHold.append(request!)
        return request!
    }

    @discardableResult
    static func get(_ url: String,
                    _ parameters: Parameters? = nil,
                    config: ((Http) -> Void)? = nil,
                    _ onResult: @escaping (Dictionary<String, Any>?, Error?) -> Void) -> DataRequest {
        request(url, parameters, method: .get, config: config, onResult)
    }

    @discardableResult
    static func post(_ url: String,
                     _ body: Parameters? = nil,
                     query: Parameters? = nil,
                     config: ((Http) -> Void)? = nil,
                     _ onResult: @escaping (Dictionary<String, Any>?, Error?) -> Void) -> DataRequest {
        let _url = connectParam(url, query)
        return request(_url, body, method: .post, config: { http in
            http.encoding = JSONEncoding.default
            http.headers.append(HTTPHeader(name: "Accept", value: "application/json; charset=utf-8"))
            //http.headers.append(HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"))
            config?(http)
        }, onResult)
    }

    @discardableResult
    static func put(_ url: String,
                    _ body: Parameters? = nil,
                    query: Parameters? = nil,
                    config: ((Http) -> Void)? = nil,
                    _ onResult: @escaping (Dictionary<String, Any>?, Error?) -> Void) -> DataRequest {
        let _url = connectParam(url, query)
        return request(_url, body, method: .put, config: { http in
            http.encoding = JSONEncoding.default
            http.headers.append(HTTPHeader(name: "Accept", value: "application/json; charset=utf-8"))
            //http.headers.append(HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"))
            config?(http)
        }, onResult)
    }
}