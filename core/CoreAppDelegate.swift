//
// Created by wayto on 2021/7/31.
//

import Foundation
import UIKit
import Alamofire

/// 核心代理
class CoreAppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Core.shared.initCore() //优先初始化

        let screen = UIScreen.main
        L.d("启动程序:didFinishLaunchingWithOptions:\(launchOptions):\(screen.bounds):\(screen.nativeBounds):\(screen.scale)↓")

        Http.HOST = (Bundle.getPlist("ApiHost") as? String) ?? Http.HOST
        Http.headers.append(HTTPHeader(name: "source-of-request", value: "app"))

        L.i(Http.HOST)

        L.d(Bundle.main.infoDictionary)

        initApplicationAppearance()
        initApplication()

        //sleep(15)
        return true
    }

    /// init
    func initApplication() {
        //init

    }

    /// 外观init
    func initApplicationAppearance() {
        with(UINavigationBar.appearance()) {
            //$0.barTintColor = Res.color.colorAccent
            $0.tintColor = Res.color.colorAccent
            //$0.setTitleColor(Res.text.normal.color)
        }

        with(UIBarButtonItem.appearance()) {
            $0.tintColor = Res.color.colorAccent
            //$0.setTitleTextAttributes(<#T##attributes: [Key: Any]?##[Foundation.NSAttributedString.Key: Any]?#>, for: <#T##State##UIKit.UIControl.State#>)
        }

        with(UITabBar.appearance()) {
            $0.isTranslucent = false
            $0.tintColor = Res.color.colorAccent
            $0.barTintColor = Res.color.controllerBackgroundColor
            $0.unselectedItemTintColor = Res.color.iconColor
            with($0.standardAppearance) {
                //$0.backgroundEffect = UIBlurEffect(style: .dark)
                $0.backgroundEffect = nil //去掉模糊效果
                //$0.backgroundColor = .red
            }
        }

        with(UITabBarItem.appearance()) {
            $0.badgeColor
            //$0.setTitleTextAttributes(<#T##attributes: [Key: Any]?##[Foundation.NSAttributedString.Key: Any]?#>, for: <#T##State##UIKit.UIControl.State#>)
        }
    }

    // MARK: UIApplicationDelegate

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        L.i("applicationDidReceiveMemoryWarning")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        L.i("applicationWillTerminate")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        L.d("configurationForConnecting:\(connectingSceneSession)")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        L.d("didDiscardSceneSessions:\(sceneSessions)")
    }
}