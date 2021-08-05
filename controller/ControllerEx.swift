//
// Created by angcyo on 21/08/05.
//

import Foundation
import UIKit

extension UIViewController {

    static var HEIGHT: Float = 44

    var defaultNavWidth: Float {
        Float(UIScreen.width)
    }

    /// 默认的导航栏高度, 包含了状态栏和标题栏
    var defaultNavHeight: Float {
        //获取状态栏的rect
        let statusRect = UIApplication.statusBarFrame
        //print(statusRect) //Optional((0.0, 0.0, 375.0, 44.0))
        let height = (statusRect?.size.height ?? 0) + CGFloat(defaultTitleHeight)
        return max(Float(height), UIViewController.HEIGHT + UIViewController.HEIGHT)
    }

    /// 默认的标题栏高度
    var defaultTitleHeight: Float {
        //获取导航栏的rect
        let navRect = navigationController?.navigationBar.frame;
        let height = navRect?.size.height ?? 0
        return max(Float(height), UIViewController.HEIGHT)
    }
}