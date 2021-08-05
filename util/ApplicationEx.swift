//
// Created by wayto on 2021/7/29.
//

import Foundation
import UIKit

extension UIApplication {

    /**获取最主要的UIWindow*/
    static var mainWindow: UIWindow? {
        get {
            var _result: UIWindow?
            if #available(iOS 13.0, *) {
                _result = UIApplication.shared.windows.first {
                    $0.isKeyWindow
                }
            } else {
                _result = UIApplication.shared.keyWindow
            }
            if _result == nil {
                if let scene = CoreSceneDelegate.connectScene {
                    _result = scene.windows.first {
                        $0.isKeyWindow
                    } ?? scene.windows.last
                }
            }
            return _result
        }
    }

    /// 活跃的UIScene
    static var activeScene: UIScene? {
        UIApplication.shared
                .connectedScenes
                .filter {
            $0.activationState == .foregroundActive
        }.first
    }

    static var activeWindowScene: UIWindowScene? {
        activeScene as? UIWindowScene
    }

    /// 状态栏管理
    class func statusBarManager() -> UIStatusBarManager? {
        UIApplication.mainWindow?.windowScene?.statusBarManager
    }

    /// 是否开启交互, 接收touch事件
    static func isUserInteractionEnabled(_ enable: Bool = true) {
        mainWindow?.isUserInteractionEnabled = enable
    }

    /// 返回状态栏的frame
    static var statusBarFrame: CGRect? {
        statusBarManager()?.statusBarFrame
    }
}

/// 创建一个新的UIWindow, 返回对象需要hold,否则会被arc回收
func newWindow(_ action: ((UIWindow) -> Void)? = nil) -> UIWindow {
    let window = UIWindow(windowScene: UIApplication.activeWindowScene!)
    window.frame = UIScreen.main.bounds
    //window.windowLevel = UIWindow.Level.alert
    action?(window)
    window.makeKeyAndVisible()
    return window
}

/// 返回对象需要hold,否则会被arc回收
func newWindow(_ rootView: UIView, _ action: ((UIWindow) -> Void)? = nil) -> UIWindow {
    let vc = UIViewController()
    //    vc.view.setBackground(UIColor.red)
    //    vc.view.addSubview(rootView)
    vc.view = rootView
    return newWindow { (window: UIWindow) -> () in
        //window.setBackground(UIColor.clear)
        window.rootViewController = vc
        //window.addSubview(rootView)
        action?(window)
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
    if let nav = root as? UINavigationController {
        nav.pushViewController(viewControllerToPresent, animated: flag)
        completion?()
    } else {
        root.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

/// 隐藏一个[UIViewController]
func hideViewController(_ viewControllerToPresent: UIViewController,
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
    if let nav = root as? UINavigationController {
        nav.popViewController(animated: flag)
        completion?()
    } else {
        root.dismiss(animated: flag, completion: completion)
    }
}