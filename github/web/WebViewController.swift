//
// Created by angcyo on 21/08/30.
//

import Foundation

/// https://github.com/kf99916/ProgressWebViewController

class WebViewController: ProgressWebViewController, INavigation {

    //MARK: INavigation

    var showNavigationBar: Bool = true
    var showToolbar: Bool = true

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // Other methods

    override func openURLWithApp(_ url: URL) -> Bool {
        super.openURLWithApp(_: url)
    }
}