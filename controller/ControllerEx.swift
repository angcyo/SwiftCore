//
//  ControllerEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/27.
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

}
