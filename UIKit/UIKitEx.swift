//
// Created by wayto on 2021/7/28.
//

import Foundation
import UIKit

class TargetObserver {
    /// dsl
    var onAction: ((UIView) -> Void)? = nil
    
    /// 回调
    @objc func onActionInner(sender: UIView) {
        onAction?(sender)
    }
}

extension UIView {
    
    /// 快速监听事件
    func onClick(_ controlEvents: UIControl.Event = .touchUpInside, _ action: @escaping (UIView) -> Void) -> Any {
        let observer = TargetObserver()
        observer.onAction = action
        
        if self is UIControl {
            (self as! UIControl).addTarget(observer,
                                           action: #selector(TargetObserver.onActionInner(sender:)),
                                           for: controlEvents)
            return observer
        } else {
            let gesture = UITapGestureRecognizer(target: observer,
                                                 action: #selector(TargetObserver.onActionInner(sender:)))
            
            // 点击一次
            gesture.numberOfTapsRequired = 1
            // 一个手指
            gesture.numberOfTouchesRequired = 1
            
            //需要交互
            isUserInteractionEnabled = true
            //添加手势
            addGestureRecognizer(gesture)
            
            return gesture
        }
    }
}

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
