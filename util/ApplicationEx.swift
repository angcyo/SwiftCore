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
}