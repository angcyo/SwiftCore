//
// Created by angcyo on 21/08/05.
//

import Foundation
import UIKit

extension UIViewController {

    var defaultNavWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    ///https://www.jianshu.com/p/7c826a792a6c
    /// 默认的导航栏高度, 包含了状态栏和标题栏
    var defaultNavHeight: CGFloat {
        //获取状态栏的rect
        let statusRect = UIApplication.statusBarFrame
        //print(statusRect) //Optional((0.0, 0.0, 375.0, 44.0))
        let height = (statusRect?.size.height ?? 0) + defaultTitleHeight
        return max(height, Res.size.navigationBarHeight)
    }

    /// 默认的标题栏高度
    var defaultTitleHeight: CGFloat {
        //获取导航栏的rect
        let navRect = UIApplication.findNavigationController()?.navigationBar.frame
        let height = navRect?.size.height ?? Res.size.navigationBarHeight
        return max(height, Res.size.navigationBarHeight)
    }
}