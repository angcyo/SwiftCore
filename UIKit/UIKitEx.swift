//
// Created by wayto on 2021/7/28.
//

import Foundation
import UIKit

extension UIStoryboard {

    ///
    /// 创建UIStoryboard
    /// - Parameters:
    ///   - name: LaunchScreen 区分大小写, 不需要后缀
    ///   - storyboardBundleOrNil:
    /// - Returns:
    static func from(_ name: String, _ storyboardBundleOrNil: Bundle? = nil) -> UIStoryboard {
        UIStoryboard(name: name, bundle: storyboardBundleOrNil)
    }

    /// 转换成UIVIew
    static func toView(_ name: String, _ storyboardBundleOrNil: Bundle? = nil) -> UIView? {
        UIViewController.loadFrom(name, storyboardBundleOrNil)?.view
    }
}

extension UIViewController {

    /// dsl 需要在storyboard中指定controller
    static func loadFrom(_ name: String, _ storyboardBundleOrNil: Bundle? = nil) -> Self? {
        UIStoryboard.from(name, storyboardBundleOrNil).instantiateInitialViewController() as? Self
    }
}

extension UIView {

    /// dsl
    static func loadFromNib(_ nibName: String? = nil,
                            _ owner: Any? = nil,
                            options: [UINib.OptionsKey: Any]? = nil) -> Self {
        let loadName = nibName ?? "\(self)"
        return Bundle.main.loadNibNamed(loadName, owner: owner, options: options)?.first as! Self
    }
}

func cgRect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    CGRect(x: x, y: y, width: width, height: height)
}

func indexPath(row: Int, section: Int = 0) -> IndexPath {
    IndexPath(row: row, section: section)
}