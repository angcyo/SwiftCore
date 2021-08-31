//
// Created by wayto on 2021/7/31.
//

import Foundation
import Alamofire
import AlamofireImage
import RxSwift
import RxAlamofire
import SwiftyJSON

struct Api {

    /// 请求保存, 否则会被ARC回收
    static var requestHold: [DataRequest] = []

    /// 创建一个请求
    @discardableResult
    static func create(_ url: String,
                       _ param: Parameters? = nil, //请求参数, 可以是body, form等
                       query: Parameters? = nil, //拼接在url后面的参数
                       method: HTTPMethod = .get,
                       config: ((Http) -> Void)? = nil) -> DataRequest {
        let _url = Http.wrapUrlQuery(url, method: method, query: query)
        let _param = Http.wrapParam(method: method, param: param, query: query)
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return Http.request(_url, _param, method: method, config)
                //.log()
                .validateAuth()
                .validateCode()
        /*.response { response in
            print("[\(threadName())] 请求结束:↓")
            print(response)
        }*/
    }

    @discardableResult
    static func upload(_ url: String,
                       _ param: Parameters? = nil, //请求参数, 可以是body, form等
                       query: Parameters? = nil,
                       method: HTTPMethod = .get,
                       config: ((Http) -> Void)? = nil) -> DataRequest {
        let _url = Http.wrapUrlQuery(url, method: method, query: query)
        let _param = Http.wrapParam(method: method, param: param, query: query)
        return Http.request(_url, _param, method: method, config)
                .validateAuth()
                .validateCode()
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

    @discardableResult
    func requestString(_ onResult: @escaping (String?, Error?) -> Void) -> DataRequest {
        let request: DataRequest = self
        responseString { response in
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
    func requestBean<T: Decodable>(_ onResult: @escaping (T?, Error?) -> Void) -> DataRequest {
        requestDecodable(onResult)
    }

    @discardableResult
    func requestDecodable<T: Decodable>(_ onResult: @escaping (T?, Error?) -> Void) -> DataRequest {
        let request: DataRequest = self
        responseDecodable { (response: AFDataResponse<T>) in
            Api.requestHold.remove(request)
            switch response.result {
            case .success(let value):

                // 默认处理
                var defHandle = true

                if Http.PARSE_DATA_CODE, let data = value as? HttpCodeProtocol {
                    let code = data.code ?? 0
                    if code >= 200 && code <= 299 {
                        //成功
                    } else {
                        let msg = data.msg ?? "接口异常"
                        onResult(nil, apiError(msg))
                        defHandle = false
                    }
                }

                if (defHandle) {
                    switch response.result {
                    case .success(let value):
                        onResult(value, nil)
                    case .failure(let error):
                        onResult(nil, error)
                    }
                }

            case .failure(let error):
                onResult(nil, error)
            }
        }
        Api.requestHold.append(request)
        return request
    }

    func requestBeanRes<T: Decodable>(_ onResult: @escaping (AFDataResponse<T>, Error?) -> Void) -> DataRequest {
        requestDecodableRes(onResult)
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

    /// 获取json 对象, Pods/SwiftyJSON/Source/SwiftyJSON/SwiftyJSON.swift:82
    /// parseDataCode 解析数据code码
    @discardableResult
    func requestJson(_ onResult: @escaping (JSON?, Error?) -> Void) -> DataRequest {
        let request: DataRequest = self
        response { response in
            Api.requestHold.remove(request)

            // 默认处理
            var defHandle = true

            if Http.PARSE_DATA_CODE, let data = response.data {
                if let json = try? JSON(data: data) {
                    let code = json[Http.KEY_CODE].intValue
                    if code >= 200 && code <= 299 {
                        //成功
                    } else {
                        let msg = json[Http.KEY_MSG].string ?? "接口异常"
                        onResult(nil, apiError(msg))
                        defHandle = false
                    }
                }
            }

            if (defHandle) {
                switch response.result {
                case .success(let value):
                    onResult(JSON(value), nil)
                case .failure(let error):
                    onResult(nil, error)
                }
            }
        }
        Api.requestHold.append(request)
        return request
    }
}

//MARK: - 使用RxAlamofire扩展

extension Api {

    static func request(_ url: String,
                        _ param: Parameters? = nil, //请求参数, 可以是body, form等
                        query: Parameters? = nil,
                        method: HTTPMethod = .get,
                        encoding: ParameterEncoding? = nil /*URLEncoding.default*/,
                        headers: HTTPHeaders? = nil,
                        interceptor: RequestInterceptor? = nil) -> Observable<DataRequest> {
        let _url = Http.wrapUrlQuery(url, method: method, query: query)
        let _param = Http.wrapParam(method: method, param: param, query: query)
        return httpSession.rx.request(method, connectUrl(url: _url),
                        parameters: _param,
                        encoding: Http.wrapEncoding(method: method, encoding: encoding),
                        headers: Http.wrapHttpHeader(method: method, headers: headers),
                        interceptor: Http.wrapInterceptor(interceptor: interceptor))
                //.log()
                .validateAuth()
                .validateCode()
    }

    /// 获取JSON对象
    static func requestJson(_ url: String,
                            _ param: Parameters? = nil, //请求参数, 可以是body, form等
                            query: Parameters? = nil,
                            method: HTTPMethod = .post,
                            encoding: ParameterEncoding? = nil,
                            headers: HTTPHeaders? = nil,
                            interceptor: RequestInterceptor? = nil) -> Observable<JSON> {
        request(url, param, query: query, method: method, encoding: encoding, headers: headers, interceptor: interceptor)
                .flatMap {
                    $0.rx.swiftyJSON()
                }
    }

    /// 获取JSON对象
    static func json(_ url: String,
                     _ param: Parameters? = nil, //请求参数, 可以是body, form等
                     query: Parameters? = nil,
                     method: HTTPMethod = .post,
                     encoding: ParameterEncoding? = nil,
                     headers: HTTPHeaders? = nil,
                     interceptor: RequestInterceptor? = nil,
                     _ onResult: @escaping (JSON?, Error?) -> Void) -> Disposable {
        request(url, param, query: query, method: method, encoding: encoding, headers: headers, interceptor: interceptor)
                .flatMap {
                    $0.rx.swiftyJSON()
                }
                .subscribe(onNext: { data in
                    //debugPrint(data)
                    if Http.PARSE_DATA_CODE {
                        let json = data
                        let code = json[Http.KEY_CODE].intValue
                        if code >= 200 && code <= 299 {
                            //成功
                            onResult(data, nil)
                        } else {
                            let msg = json[Http.KEY_MSG].string ?? "接口异常"
                            onResult(nil, apiError(msg))
                        }
                    } else {
                        onResult(data, nil)
                    }
                }, onError: { error in
                    //debugPrint(error)
                    onResult(nil, error)
                })
    }

    static func requestResponseJson(_ url: String,
                                    _ param: Parameters? = nil, //请求参数, 可以是body, form等
                                    query: Parameters? = nil,
                                    method: HTTPMethod = .post,
                                    encoding: ParameterEncoding? = nil,
                                    headers: HTTPHeaders? = nil,
                                    interceptor: RequestInterceptor? = nil) -> Observable<(HTTPURLResponse, JSON)> {
        request(url, param, query: query, method: method, encoding: encoding, headers: headers, interceptor: interceptor)
                .flatMap {
                    $0.rx.responseSwiftyJSON()
                }
    }

    /// 获取bean
    static func requestBean<T: Decodable>(_ url: String,
                                          _ param: Parameters? = nil, //请求参数, 可以是body, form等
                                          query: Parameters? = nil,
                                          method: HTTPMethod = .post,
                                          encoding: ParameterEncoding? = nil,
                                          headers: HTTPHeaders? = nil,
                                          interceptor: RequestInterceptor? = nil) -> Observable<T> {
        request(url, param, query: query, method: method, encoding: encoding, headers: headers, interceptor: interceptor)
                .flatMap {
                    $0.rx.decodable()
                }
    }

    static func bean<T: Decodable>(_ url: String,
                                   _ param: Parameters? = nil, //请求参数, 可以是body, form等
                                   query: Parameters? = nil,
                                   method: HTTPMethod = .post,
                                   encoding: ParameterEncoding? = nil,
                                   headers: HTTPHeaders? = nil,
                                   interceptor: RequestInterceptor? = nil,
                                   _ onResult: @escaping (T?, Error?) -> Void) -> Disposable {
        request(url, param, query: query, method: method, encoding: encoding, headers: headers, interceptor: interceptor)
                .flatMap {
                    $0.rx.decodable()
                }
                .subscribe(onNext: { (data: T) in
                    //debugPrint(data)
                    if Http.PARSE_DATA_CODE, let bean = data as? HttpCodeProtocol {
                        let code = bean.code ?? 0
                        if code >= 200 && code <= 299 {
                            //成功
                            onResult(data, nil)
                        } else {
                            let msg = bean.msg ?? "接口异常"
                            onResult(nil, apiError(msg))
                        }
                    } else {
                        onResult(data, nil)
                    }
                }, onError: { error in
                    //debugPrint(error)
                    onResult(nil, error)
                })
    }

    static func requestResponseBean<T: Decodable>(_ url: String,
                                                  _ param: Parameters? = nil, //请求参数, 可以是body, form等
                                                  query: Parameters? = nil,
                                                  method: HTTPMethod = .post,
                                                  encoding: ParameterEncoding? = nil,
                                                  headers: HTTPHeaders? = nil,
                                                  interceptor: RequestInterceptor? = nil) -> Observable<(HTTPURLResponse, T)> {
        request(url, param, query: query, method: method, encoding: encoding, headers: headers, interceptor: interceptor)
                .flatMap {
                    $0.rx.responseDecodable()
                }
    }
}

extension Reactive where Base: DataRequest {

    func responseSwiftyJSON() -> Observable<(HTTPURLResponse, JSON)> {
        return responseResult(responseSerializer: JSONResponseSerializer())
    }

    func swiftyJSON() -> Observable<JSON> {
        return result(responseSerializer: JSONResponseSerializer())
    }
}

/// [JSON]
class JSONResponseSerializer: ResponseSerializer {

    public let dataPreprocessor: DataPreprocessor
    public let emptyResponseCodes: Set<Int>
    public let emptyRequestMethods: Set<HTTPMethod>
    /// `JSONSerialization.ReadingOptions` used when serializing a response.
    public let options: JSONSerialization.ReadingOptions

    /// Creates an instance with the provided values.
    ///
    /// - Parameters:
    ///   - dataPreprocessor:    `DataPreprocessor` used to prepare the received `Data` for serialization.
    ///   - emptyResponseCodes:  The HTTP response codes for which empty responses are allowed. `[204, 205]` by default.
    ///   - emptyRequestMethods: The HTTP request methods for which empty responses are allowed. `[.head]` by default.
    ///   - options:             The options to use. `.allowFragments` by default.
    public init(dataPreprocessor: DataPreprocessor = JSONResponseSerializer.defaultDataPreprocessor,
                emptyResponseCodes: Set<Int> = JSONResponseSerializer.defaultEmptyResponseCodes,
                emptyRequestMethods: Set<HTTPMethod> = JSONResponseSerializer.defaultEmptyRequestMethods,
                options: JSONSerialization.ReadingOptions = .allowFragments) {
        self.dataPreprocessor = dataPreprocessor
        self.emptyResponseCodes = emptyResponseCodes
        self.emptyRequestMethods = emptyRequestMethods
        self.options = options
    }

    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> JSON {
        guard error == nil else {
            throw error!
        }

        guard var data = data, !data.isEmpty else {
            guard emptyResponseAllowed(forRequest: request, response: response) else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }

            return JSON()
        }

        data = try dataPreprocessor.preprocess(data)

        do {
            return try JSON(data: data)
        } catch {
            throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
        }
    }
}