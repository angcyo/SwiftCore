//
// Created by wayto on 2021/7/29.
//

import Foundation
import UIKit

extension UIApplication {

    /**获取最主要的UIWindow*/
    static var mainWindow: UIWindow? {
        get {
            let _result: UIWindow?
            if #available(iOS 13.0, *) {
                _result = UIApplication.shared.windows.first {
                    $0.isKeyWindow
                }
            } else {
                _result = UIApplication.shared.keyWindow
            }
            return _result
        }
    }

    /// 状态栏管理
    class func statusBarManager() -> UIStatusBarManager? {
        UIApplication.mainWindow?.windowScene?.statusBarManager
    }

    /// 是否开启交互, 接收touch事件
    static func isUserInteractionEnabled(_ enable: Bool = true) {
        mainWindow?.isUserInteractionEnabled = enable
    }
}

/// 隐藏键盘
func hideKeyboard() {
    UIApplication.mainWindow?.endEditing(true)
}

/// 显示一个[UIViewController]
func showViewController(_ viewControllerToPresent: UIViewController,
                        animated flag: Bool = true,
                        completion: (() -> Void)? = nil) {
    guard let window = UIApplication.mainWindow else {
        return
    }
    guard let root = window.rootViewController else {
        return
    }
    //https://www.jianshu.com/p/c7dc152724b2#comments
    //viewControllerToPresent.modalPresentationStyle = .fullScreen

    //root.show(<#T##vc: UIViewController##UIKit.UIViewController#>, sender: <#T##Any?##Any?#>)
    //root.showDetailViewController(<#T##vc: UIViewController##UIKit.UIViewController#>, sender: <#T##Any?##Any?#>)
    root.present(viewControllerToPresent, animated: flag, completion: completion)
}