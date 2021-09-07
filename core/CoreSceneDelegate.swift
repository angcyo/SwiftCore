//
// Created by wayto on 2021/7/31.
//

import Foundation
import UIKit

/// 在plist文件中配置:
/// Custom iOS Target Properties -> Application Scene Manifest -> Scene Configuration -> Application Session Role -> Item 0 -> Delegate Class Name
/// https://www.jianshu.com/p/10df52dde8e5

/// 场景代理
class CoreSceneDelegate: UIResponder, UIWindowSceneDelegate {

    /// 弱引用保存
    static weak var connectScene: UIWindowScene? = nil

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else {
            return
        }
        CoreSceneDelegate.connectScene = scene

        L.d("场景连接:\(scene)")

        //UIEdgeInsets(top: 44.0, left: 0.0, bottom: 34.0, right: 0.0)
        //UIEdgeInsets(top: 52.0, left: 8.0, bottom: 42.0, right: 8.0)
        L.d("安全区域window:\(window?.safeAreaInsets):\(window?.layoutMargins)")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        L.d("场景断开:\(scene)")
    }

    //1.
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        L.d("场景即将进入前景:\(scene)")
        scene.activeSceneDelegate?.sceneWillEnterForeground?(scene)
    }

    //2.
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        L.d("场景活跃:\(scene)")
        scene.activeSceneDelegate?.sceneDidBecomeActive?(scene)
    }

    //3.
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        L.d("场景即将不活跃:\(scene)")
        scene.activeSceneDelegate?.sceneWillResignActive?(scene)
    }

    //4.
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        L.d("场景进入背景:\(scene)")
        scene.activeSceneDelegate?.sceneDidEnterBackground?(scene)
    }
}

extension UIScene {

    /// scene 中活跃的UIViewController
    var activeViewController: UIViewController? {
        get {
            if let windowScene = self as? UIWindowScene {
                if let window = windowScene.keyWindow {
                    if let root = window.rootViewController {
                        return root.findActiveViewController()
                    }
                }
            }
            return nil
        }
    }

    var activeSceneDelegate: UISceneDelegate? {
        get {
            activeViewController as? UISceneDelegate
        }
    }
}

extension UIViewController {

    func findActiveViewController() -> UIViewController {
        if let navViewController = self as? UINavigationController {
            return navViewController.topViewController?.findActiveViewController() ?? self
        } else if let tabViewController = self as? UITabBarController {
            return tabViewController.viewControllers?.get(tabViewController.selectedIndex)?.findActiveViewController() ?? self
        } else {
            return self
        }
    }
}