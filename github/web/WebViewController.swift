//
// Created by angcyo on 21/08/30.
//

import Foundation
import WKWebViewJavascriptBridge

/// https://github.com/kf99916/ProgressWebViewController
/// https://github.com/Lision/WKWebViewJavascriptBridge
/// https://github.com/Lision/WKWebViewJavascriptBridge/blob/master/README_ZH-CN.md

class WebViewController: ProgressWebViewController, INavigation {

    //MARK: INavigation

    var showNavigationBar: Bool = true
    var showToolbar: Bool = true

    /// https://github.com/Lision/WKWebViewJavascriptBridge/blob/master/README_ZH-CN.md
    var bridge: WKWebViewJavascriptBridge? = nil

    override open func loadView() {
        super.loadView()

        showToolbar = true

        tintColor = Res.color.colorPrimary //着色
        pullToRefresh = true //激活下拉刷新

        //https://angcyo.gitee.io/ua
        //userAgent //Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148
        //disableZoom

        //defaultHeaders //设置请求头
        //url //请求的地址

        //load(<#T##url: URL##Foundation.URL#>)
        // set up webview, including cookies, headers, user agent, and so on.

        //webView?.scrollView.contentInsetAdjustmentBehavior = .never //

        bridge = WKWebViewJavascriptBridge(webView: webView)
        initBridge()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: bridge https://github.com/Lision/WKWebViewJavascriptBridge/blob/master/README_ZH-CN.md

    /*
        bridge.call(handlerName: "testJavascriptHandler", data: ["foo": "before ready"], callback: nil)
      */

    /// 初始化桥梁
    func initBridge() {
        //注册一个方法
        bridge?.register(handlerName: "testiOSCallback") { (parameters, callback) in
            print("testiOSCallback called: \(String(describing: parameters))")
            callback?("Response from testiOSCallback")
        }
    }

    //MARK: Other methods

    override func openURLWithApp(_ url: URL) -> Bool {
        super.openURLWithApp(_: url)
    }

    override func pushWebViewController(url: URL) {
        let progressWebViewController = delegate?.initPushedProgressWebViewController?(url: url) ?? WebViewController(self)
        progressWebViewController.url = url
        push(progressWebViewController)
        setUpState()
    }
}