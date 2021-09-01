//
// Created by wayto on 2021/7/31.
//

import Foundation
import Alamofire
import RxAlamofire

/// https://github.com/Alamofire/Alamofire
/// https://gitee.com/mirrors/alamofire/blob/master/Documentation/Usage.md
class Http {

    // MARK: 成员配置

    /// 请求的host
    var base: String? = HOST

    /// 请求的地址, 支持相对和绝对地址
    var url: String? = nil

    /// 请求方法
    var method: HTTPMethod = .get

    /// 查询参数, 请求体
    var param: Parameters? = nil

    /// 请求头
    var headers: [HTTPHeader] = []

    /// 请求拦截器
    var interceptor: [RequestInterceptor] = []

    var encoding: ParameterEncoding? = nil

    /// 添加请求头
    func addHeader(_ name: String, _ value: Any) {
        headers.append(HTTPHeader(name: name, value: "\(value)"))
    }

    func doIt() -> DataRequest {
        let _url = connectUrl(base, url: url)
        return httpSession.request(_url, method: method, parameters: param,
                encoding: Http.wrapEncoding(method: method, encoding: encoding),
                headers: Http.wrapHttpHeader(method: method, headers: HTTPHeaders(headers)),
                interceptor: Http.wrapInterceptor(interceptors: interceptor))
    }

    /// 上传数据
    func upload(_ data: Data) -> UploadRequest {
        let _url = connectUrl(base, url: url)
        return httpSession.upload(data,
                to: connectParam(_url, param),
                method: method,
                headers: Http.wrapHttpHeader(method: method, headers: HTTPHeaders(headers)),
                interceptor: Http.wrapInterceptor(interceptors: interceptor))
    }

    func upload(_ fileURL: URL) -> UploadRequest {
        let _url = connectUrl(base, url: url)
        return httpSession.upload(fileURL,
                to: connectParam(_url, param),
                method: method,
                headers: Http.wrapHttpHeader(method: method, headers: HTTPHeaders(headers)),
                interceptor: Http.wrapInterceptor(interceptors: interceptor))
    }

    func upload(_ stream: InputStream) -> UploadRequest {
        let _url = connectUrl(base, url: url)
        return httpSession.upload(stream,
                to: connectParam(_url, param),
                method: method,
                headers: Http.wrapHttpHeader(method: method, headers: HTTPHeaders(headers)),
                interceptor: Http.wrapInterceptor(interceptors: interceptor))
    }

    func upload(multipartFormData: MultipartFormData) -> UploadRequest {
        let _url = connectUrl(base, url: url)
        return httpSession.upload(multipartFormData: multipartFormData,
                to: connectParam(_url, param),
                method: method,
                headers: Http.wrapHttpHeader(method: method, headers: HTTPHeaders(headers)),
                interceptor: Http.wrapInterceptor(interceptors: interceptor))
    }

    /// Swift 的ARC, 在创建对象之后, 没有被引用会立马被回收.
    /// https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
    deinit {
        L.w("销毁:\(self)")
    }

    /// 发送一个请求
    static func request(_ url: String,
                        _ parameters: Parameters? = nil,
                        method: HTTPMethod = .get,
                        _ dsl: ((Http) -> Void)? = nil) -> DataRequest {
        let http = Http()
        http.url = url
        http.method = method
        http.param = parameters
        dsl?(http)
        return http.doIt()
    }

    /// 上传数据
    static func upload(_ url: String,
                       multipartFormData: MultipartFormData,
                       query: Parameters? = nil /*拼接在url后面的数据*/,
                       method: HTTPMethod = .post,
                       dsl: ((Http) -> Void)? = nil) -> UploadRequest {
        let http = Http()
        http.url = url
        http.method = method
        http.param = query
        dsl?(http)
        return http.upload(multipartFormData: multipartFormData)
    }
}

extension Http {

    /// 请求头包裹
    static func wrapHttpHeader(method: HTTPMethod, headers: HTTPHeaders? = nil) -> HTTPHeaders {
        var result = headers ?? HTTPHeaders()

        if method == .post || method == .put {
            let accept = "Accept"
            if result.value(for: accept) == nil {
                result.update(name: accept, value: "application/json; charset=utf-8")
            }

            let contentType = "Content-Type"
            if result.value(for: contentType) == nil {
                result.update(name: contentType, value: "application/json; charset=utf-8")
            }
        }

        //公共头
        Http.headers.forEach {
            result.update($0)
        }

        return result
    }

    /// 请求编码器
    static func wrapEncoding(method: HTTPMethod, encoding: ParameterEncoding? = nil) -> ParameterEncoding {
        if let encoding = encoding {
            return encoding
        }

        if method == .post || method == .put {
            return JSONEncoding.default
        }

        return URLEncoding.default
    }


    /// 将查询参数, 手动拼接到url中
    static func wrapUrlQuery(_ url: String,
                             method: HTTPMethod,
                             query: Parameters?) -> String {
        let _url: String
        if method == .post || method == .put {
            //手动拼接请求参数
            _url = connectParam(url, query)
        } else {
            _url = url
        }
        return _url
    }

    static func wrapParam(method: HTTPMethod,
                          param: Parameters? = nil,
                          query: Parameters? = nil) -> Parameters? {
        if method == .post || method == .put {
            return param
        } else {
            return query ?? param
        }
    }

    static func wrapInterceptor(interceptor: RequestInterceptor?) -> RequestInterceptor {
        if let _i = interceptor {
            return wrapInterceptor(interceptors: [_i])
        }
        return wrapInterceptor(interceptors: nil)
    }

    static func wrapInterceptor(interceptors: [RequestInterceptor]?) -> RequestInterceptor {
        //适配器
        let _adapters: [RequestAdapter] = []

        //重试器
        let _retriers: [RequestRetrier] = []

        //------------------------------拦截器----------------------------

        //拦截器
        var _interceptors: [RequestInterceptor] = []

        /*if D.isDebug {
            _interceptors.append(LogInterceptor())
        }*/

        //auth
        if let credential = Http.credential {

            // Create the interceptor
            let authenticator = OAuthAuthenticator()
            let interceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)

            _interceptors.append(interceptor)
        }

        interceptors?.forEach { interceptor in
            _interceptors.append((interceptor))
        }

        //------------------------------拦截器end----------------------------

        let interceptor = Interceptor(
                adapters: _adapters,
                retriers: _retriers,
                interceptors: _interceptors)
        return interceptor
    }
}

// MARK: 静态配置

extension Http {

    /// 单例配置
    static var HOST = ""

    /// 授权请求
    static var credential: OAuthCredential? = nil

    /// 固定的请求头
    static var headers: [HTTPHeader] = []

    /// {"msg":"身份认证失败","code":401,"data":null}
    static var PARSE_DATA_CODE = true

    static var KEY_CODE = "code"

    static var KEY_MSG = "msg"
}

extension String {

    /// 拼上host返回url
    func toUrl(_ fileId: Int? = nil, schema: String = "") -> String {
        let url = connectUrl(url: self, schema: schema)
        if let id = fileId {
            return connectParam(url, ["fileId": id])
        }
        return url
    }
}

func connectUrl(_ host: String? = Http.HOST, url: String?, schema: String = "") -> String {
    var _host = host ?? ""
    var _url = url ?? ""

    // 已经是http开头
    if _url.starts(with: "http") {
        return _url
    }

    // 去掉后面的/
    if _host.reversed().starts(with: "/") == true {
        _host.removeLast()
    }
    // 去掉前面的/
    if _url.starts(with: "/") == true {
        _url.removeFirst()
    }

    if schema.starts(with: "/") {
        return "\(_host)\(schema)/\(_url)"
    } else if schema.isEmpty {
        return "\(_host)/\(_url)"
    } else {
        return "\(_host)/\(schema)/\(_url)"
    }
}

extension URL {
    public var parametersFromQueryString: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            return nil
        }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

/// 在url上拼接参数 https://github.com/imgix/imgix-swift
func connectParam(_ url: String, _ parameters: [String: Any]?) -> String {

    guard let parameters = parameters else {
        return url
    }

    guard let url = URL(string: url) else {
        return url
    }

    var components: [(String, String)] = []

    // 解析旧参数
    let old = url.parametersFromQueryString ?? [:]
    old.forEach { (key: String, value: String) in
        components.append((key, value))
    }

    // 获取新参数
    for key in parameters.keys.sorted(by: <) {
        let value = parameters[key]!

        let drop = components.drop { (k, _) in
            k == key
        }

        //替换已存在的旧参数
        components.removeAll()
        drop.forEach { k, v in
            components += [(k, "\(v)")]
        }

        components += [(key, "\(value)")]
    }

    // 拼接参数
    let p = components.map {
        "\($0)=\($1)"
    }.joined(separator: "&")

    //组装url
    var scheme = ""
    if let s = url.scheme {
        scheme = s + "://"
    }
    return "\(scheme)\(url.host ?? "")\(url.path)?\(p)"
}
