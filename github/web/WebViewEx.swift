//
// Created by angcyo on 21/08/30.
//

import Foundation
import UIKit

/// 显示浏览器, 并打开url
@discardableResult
func showUrl(_ url: String?) -> WebViewController {
    let vc = WebViewController()

    //底部工具栏item
    vc.toolbarItemTypes = [.back, .forward, .reload, .activity]

    if let url = url {
        vc.url = url.toURL()

        push(vc)
    } else {
        L.e("无效的url:\(url)")
    }
    return vc
}

/// 调用系统浏览器
func openUrl(_ url: String) {
    if let url = url.toURL() {
        let application = UIApplication.shared
        if application.canOpenURL(url) {
            application.open(url)
        } else {
            L.e("无法打开的url:\(url)")
        }
    } else {
        L.e("无效的url:\(url)")
    }
}
