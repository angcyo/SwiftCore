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
                _result = sceneWindow
            }
            return _result
        }
    }

    static var sceneWindow: UIWindow? {
        get {
            var _result: UIWindow?
            if _result == nil {
                if let scene = CoreSceneDelegate.connectScene {
                    _result = scene.keyWindow ?? scene.windows.last
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
        //UIApplication.shared.isIgnoringInteractionEvents
        mainWindow?.isUserInteractionEnabled = enable
    }

    /// 返回状态栏的frame
    static var statusBarFrame: CGRect? {
        statusBarManager()?.statusBarFrame
    }

    static var bottomSafeInsets: CGFloat {
        UIApplication.mainWindow?.safeAreaInsets.bottom ?? 0
    }

    static var topSafeInsets: CGFloat {
        UIApplication.mainWindow?.safeAreaInsets.top ?? 0
    }

    static func findNavigationController() -> UINavigationController? {
        if let root = mainWindow?.rootViewController {
            if let nav = root as? UINavigationController {
                //nav.topViewController
                return nav
            }
            return root.navigationController
        }
        return nil
    }
}

extension UIWindowScene {

    /**获取最主要的UIWindow*/
    var keyWindow: UIWindow? {
        get {
            windows.first {
                $0.isKeyWindow
            }
        }
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

/// 显示根vc
func showRootViewController(_ rootViewController: UIViewController) {
    UIApplication.sceneWindow?.rootViewController = rootViewController
}

/// 使用导航控制器包裹vc
func navWrap(_ viewController: UIViewController) -> UINavigationController {
    if let mainNav = LoginController.mainNavigationController() {
        mainNav.setViewControllers([viewController], animated: false)
        return mainNav
    } else {
        L.w("请先配置:MAIN_NAVIGATION_CONTROLLER")
        let nav: UINavigationController = toViewController(BaseNavigationController.self)
        nav.setViewControllers([viewController], animated: false)
        return nav
    }
}

/// 使用导航控制器包裹, 优先push, 否则show
func push(_ viewControllerToPresent: UIViewController,
          animated flag: Bool = true,
          root: Bool = false) {
    guard let window = UIApplication.mainWindow else {
        return
    }

    if root {
        window.rootViewController = viewControllerToPresent
    } else if let root = window.rootViewController {
        if let nav = root as? UINavigationController {
            //nav.show(viewControllerToPresent, sender: nav)
            nav.pushViewController(viewControllerToPresent, animated: flag)
        } else if let mainNav = LoginController.mainNavigationController() {
            mainNav.setViewControllers([viewControllerToPresent], animated: false)
            window.rootViewController = mainNav
        } else {
            show(viewControllerToPresent, animated: flag)
        }
    }
}

/// show
func show(_ viewControllerToPresent: UIViewController,
          animated flag: Bool = true,
          completion: (() -> Void)? = nil) {
    guard let window = UIApplication.mainWindow else {
        return
    }
    guard let root = window.rootViewController else {
        return
    }
    root.present(viewControllerToPresent, animated: flag, completion: completion)
}

/// 显示一个[UIViewController]
func showViewController(_ viewControllerToPresent: UIViewController,
                        animated flag: Bool = true,
                        completion: (() -> Void)? = nil) {
    show(viewControllerToPresent, animated: flag, completion: completion)
}

/// 弹出上层的vc
func pop(_ viewController: UIViewController,
         animated flag: Bool = true) {
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
    } else {
        hide(viewController, animated: flag)
    }
}

/// 弹出到指定的vc
func popTo(_ type: AnyClass?, animated flag: Bool = true) {
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

        var target: UIViewController? = nil
        for vc in nav.viewControllers {
            if vc.isEqualClassName(type) {
                target = vc
                break
            }
        }

        if let target = target {
            nav.popToViewController(target, animated: flag)
        } else {
            L.w("未找到目标VC:\(classNameOf(type))")
        }
    } else {
        //暂不支持
        //hide(viewController, animated: flag)
    }
}

func hide(_ viewController: UIViewController,
          animated flag: Bool = true,
          completion: (() -> Void)? = nil) {
    viewController.dismiss(animated: flag, completion: completion)
}

/// 隐藏一个[UIViewController]
func hideViewController(_ viewController: UIViewController,
                        animated flag: Bool = true,
                        completion: (() -> Void)? = nil) {
    hide(viewController, animated: flag, completion: completion)
}

//MARK: exit

///带动画退出app https://www.jianshu.com/p/1fa06d7006cc
func exitApp() {
    abort()
}

///https://github.com/SwiftStudioIst/DinergateBrain/blob/main/Demo/DinergateBrain/CrashMonitor.swift
func killApp() {
    kill(getpid(), SIGKILL)
}