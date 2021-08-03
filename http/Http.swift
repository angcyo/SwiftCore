//
// Created by wayto on 2021/7/31.
//

import Foundation
import Alamofire
import RxAlamofire

/// https://gitee.com/mirrors/alamofire/blob/master/Documentation/Usage.md
class Http {

    // MARK: 静态配置

    /// 单例配置
    static var HOST = ""

    /// 授权请求
    static var credential: OAuthCredential? = nil

    /// 固定的请求头
    static var headers: [HTTPHeader] = []

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

    var encoding: ParameterEncoding = URLEncoding.default

    /// 添加请求头
    func addHeader(_ name: String, _ value: Any) {
        headers.append(HTTPHeader(name: name, value: "\(value)"))
    }

    func doIt() -> DataRequest {
        var _url = url
        if url?.starts(with: "http") == true {
            _url = url
        } else {
            _url = connectUrl(base, url: url)
        }

        //适配器
        let adapters: [RequestAdapter] = []

        //重试器
        let retriers: [RequestRetrier] = []

        //------------------------------拦截器----------------------------

        //拦截器
        var interceptors: [RequestInterceptor] = []

        if D.isDebug {
            interceptors.append(LogInterceptor())
        }

        //auth
        if let credential = Http.credential {

            // Create the interceptor
            let authenticator = OAuthAuthenticator()
            let interceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)

            interceptors.append(interceptor)
        }

        interceptor.forEach { interceptor in
            interceptors.append((interceptor))
        }

        //------------------------------拦截器end----------------------------

        let interceptor = Interceptor(
                adapters: adapters,
                retriers: retriers,
                interceptors: interceptors)

        //-----------------------请求头---------------------------
        let h: HTTPHeaders = HTTPHeaders(Http.headers + headers)

        return httpSession.request(_url!, method: method, parameters: param,
                encoding: encoding, headers: h,
                interceptor: interceptor)
    }

    /// Swift 的ARC, 在创建对象之后, 没有被引用会立马被回收.
    /// https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
    deinit {
        debugPrint("销毁:\(self)")
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
}

func connectUrl(_ host: String? = Http.HOST, url: String?) -> String {
    var _host = host ?? ""
    var _url = url ?? ""
    if _host.reversed().starts(with: "/") == true {
        _host.removeLast()
    }
    if _url.starts(with: "/") == true {
        _url.removeFirst()
    }
    return "\(_host)/\(_url)"
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

extension Data {

    /// Dta 转换成字符串
    func toString() -> String {
        String(decoding: self, as: UTF8.self)
    }
}

/// 在url上拼接参数
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
