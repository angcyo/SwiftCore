//
// Created by wayto on 2021/7/31.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

struct Api {

    /// 请求保存, 否则会被ARC回收
    static var requestHold: [DataRequest] = []

    /// 创建一个请求
    @discardableResult
    static func create(_ url: String,
                       _ param: Parameters? = nil, //请求参数, 可以是body, form等
                       query: Parameters? = nil,
                       method: HTTPMethod = .get,
                       config: ((Http) -> Void)? = nil) -> DataRequest {
        let _url: String
        if method == .post || method == .put {
            //手动拼接请求参数
            _url = connectParam(url, query)
        } else {
            _url = url
        }
        return Http.request(_url, param, method: method) { http in
                    if method == .post || method == .put {
                        http.encoding = JSONEncoding.default

                        http.headers.append(HTTPHeader(name: "Accept", value: "application/json; charset=utf-8"))
                        //http.headers.append(HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"))
                    } else {
                        http.encoding = URLEncoding.default
                    }
                    config?(http)
                }.validate(statusCode: 200...299)
                .response { response in
                    debugPrint("[\(threadName())] 请求结束:↓")
                    debugPrint(response)
                }
    }
}

extension Api {

    static func get(_ url: String,
                    _ param: Parameters? = nil, //请求参数, 可以是body, form等
                    config: ((Http) -> Void)? = nil) -> DataRequest {
        Api.create(url, param, method: .get, config: config)
    }

    static func post(_ url: String,
                     _ param: Parameters? = nil, //请求参数, 可以是body, form等
                     query: Parameters? = nil,
                     config: ((Http) -> Void)? = nil) -> DataRequest {
        Api.create(url, param, query: query, method: .post, config: config)
    }

    static func put(_ url: String,
                    _ param: Parameters? = nil, //请求参数, 可以是body, form等
                    query: Parameters? = nil,
                    config: ((Http) -> Void)? = nil) -> DataRequest {
        Api.create(url, param, query: query, method: .put, config: config)
    }
}

extension DataRequest {

    /// 发送一个请求, 拿到最原始的数据, 请优先判断error
    @discardableResult
    func request(_ onResult: @escaping (AFDataResponse<Data?>, Error?) -> Void) -> DataRequest {
        let request: DataRequest = self
        response { response in
            Api.requestHold.remove(request)
            switch response.result {
            case .success(_):
                //let json = JSON(value) //获取json对象
                onResult(response, nil)
            case .failure(let error):
                onResult(response, error)
            }
        }
        Api.requestHold.append(request)
        return request
    }

    @discardableResult
    func requestData(_ onResult: @escaping (Data?, Error?) -> Void) -> DataRequest {
        let request: DataRequest = self
        responseData { response in
            Api.requestHold.remove(request)
            switch response.result {
            case .success(let value):
                onResult(value, nil)
            case .failure(let error):
                onResult(nil, error)
            }
        }
        Api.requestHold.append(request)
        return request
    }

    @discardableResult
    func requestImage(_ onResult: @escaping (Image?, Error?) -> Void) -> DataRequest {
        let request: DataRequest = self
        responseImage { response in
            Api.requestHold.remove(request)
            switch response.result {
            case .success(let value):
                onResult(value, nil)
            case .failure(let error):
                onResult(nil, error)
            }
        }
        Api.requestHold.append(request)
        return request
    }

    /// 获取bean of type: T.Type = T.self,
    @discardableResult
    func requestDecodable<T: Decodable>(_ onResult: @escaping (T?, Error?) -> Void) -> DataRequest {
        let request: DataRequest = self
        responseDecodable { (response: AFDataResponse<T>) in
            Api.requestHold.remove(request)
            switch response.result {
            case .success(let value):
                onResult(value, nil)
            case .failure(let error):
                onResult(nil, error)
            }
        }
        Api.requestHold.append(request)
        return request
    }

    @discardableResult
    func requestDecodableRes<T: Decodable>(_ onResult: @escaping (AFDataResponse<T>, Error?) -> Void) -> DataRequest {
        let request: DataRequest = self
        responseDecodable { (response: AFDataResponse<T>) in
            Api.requestHold.remove(request)
            switch response.result {
            case .success(_):
                onResult(response, nil)
            case .failure(let error):
                onResult(response, error)
            }
        }
        Api.requestHold.append(request)
        return request
    }

    /// 获取json 字典
    @discardableResult
    func requestJSON(_ onResult: @escaping (Any?, Error?) -> Void) -> DataRequest {
        let request: DataRequest = self

        responseJSON { response in
            Api.requestHold.remove(request)
            switch response.result {
            case .success(let value):
                onResult(value, nil)
            case .failure(let error):
                onResult(nil, error)
            }
        }
        Api.requestHold.append(request)
        return request
    }

    /// 获取json 对象
    @discardableResult
    func requestJson(_ onResult: @escaping (JSON?, Error?) -> Void) -> DataRequest {
        let request: DataRequest = self
        response { response in
            Api.requestHold.remove(request)
            switch response.result {
            case .success(let value):
                onResult(JSON(value), nil)
            case .failure(let error):
                onResult(nil, error)
            }
        }
        Api.requestHold.append(request)
        return request
    }
}