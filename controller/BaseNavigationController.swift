//
// Created by angcyo on 21/08/04.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate, UINavigationBarDelegate {

    init() {
        super.init(nibName: nil, bundle: nil)
        initController()
    }

//     override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//         super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//         initController()
//     }
//
//    override init(rootViewController: UIViewController) {
//        super.init(rootViewController: rootViewController)
//        initController()
//    }
//
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// 初始化
    func initController() {
        delegate = self
        //init
        //tabBarItem = nil
        //setViewControllers(<#T##viewControllers: [UIViewController]##[UIKit.UIViewController]#>, animated: <#T##Bool##Swift.Bool#>)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //hidesBarsOnSwipe
        //hidesBarsOnTap
        //hidesBarsWhenKeyboardAppears
        //hidesBarsWhenVerticallyCompact
        //hidesBottomBarWhenPushed

        //barHideOnSwipeGestureRecognizer
        //barHideOnTapGestureRecognizer

        //toolbar 显示在界面底部的工具栏
        //setToolbarHidden(false, animated: true)

        //navigationBar 显示在界面顶部的导航栏
        //Cannot manually set the delegate on a UINavigationBar managed by a controller.
        //navigationBar.delegate = self
        //navigationBar.standardAppearance

        navigationBar.barStyle = .default
        //navigationBar.isTranslucent = true //透明

        //navigationBar.tintColor = UIColor.red //着色
        //navigationBar.backItem
        //navigationBar.items //navigationBar 管理所有vc的 navigationItem

        // 自定义导航栏
        //UINavigationBar.appearance()
        //左边按钮和默认的返回按钮同时存在
        //navigationItem.leftItemsSupplementBackButton = true
        //背景颜色
        //navigationBar.standardAppearance.backgroundColor = UIColor.yellow
        //中间文本的属性
        //navigationBar.standardAppearance.titleTextAttributes[.backgroundColor] = UIColor.red
        //中间文本的颜色
        //navigationBar.standardAppearance.titleTextAttributes[.foregroundColor] = UIColor.white
        //返回按钮文本的属性
        //navigationBar.standardAppearance.backButtonAppearance.normal.titleTextAttributes[.foregroundColor] = UIColor.red
        //改变字体大小, 通过改变字体大小, 达到隐藏返回文本的效果
        //navigationBar.standardAppearance.backButtonAppearance.normal.titleTextAttributes[.font] = Res.font.get(0.01)
        //设置返回图片
        //navigationBar.standardAppearance.setBackIndicatorImage(R.image.icon_password(), transitionMaskImage: R.image.icon_password())
        //阴影图片/颜色
        //navigationBar.standardAppearance.shadowImage = nil
        //navigationBar.standardAppearance.shadowColor = UIColor.clear
        //背景图片
        //navigationBar.setBackgroundImage(R.image.icon_password(), for: .default)
    }

    /// Swift 的ARC, 在创建对象之后, 没有被引用会立马被回收.
    /// https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
    deinit {
        debugPrint("\(threadName())->销毁:\(self)")
    }

    //MARK: 导航代理

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        debugPrint("即将显示VC:\(viewController):\(animated)")
        if let navigation = viewController as? Navigation {
            //navigationController.navigationBar.isHidden = !navigation.showNavigationBar
            //navigationController.isNavigationBarHidden = !navigation.showNavigationBar
            navigationController.setNavigationBarHidden(!navigation.showNavigationBar, animated: animated)
        }

        //在这里可以修改返回按钮
        //let backItem = UIBarButtonItem()
        //backItem.title = "Back"
        //backItem.tintColor = .red
        //viewController.navigationItem.backBarButtonItem = backItem
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        debugPrint("已经显示VC:\(viewController):\(animated)")
    }

    /// 支持的屏幕方向
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        debugPrint("navigationControllerSupportedInterfaceOrientations")
        return .portrait
    }

    /// 预选方向
    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        debugPrint("navigationControllerPreferredInterfaceOrientationForPresentation")
        return .portrait
    }

    /// 过渡东安湖
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        debugPrint("interactionControllerFor:\(animationController)")
        return nil
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        debugPrint("animationControllerFor:\(operation):fromVC:\(fromVC) :toVC:\(toVC)")
        return nil
    }

    //MARK: 导航栏代理

    func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        debugPrint("shouldPush:\(item)")
        return true
    }

    func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        debugPrint("didPush:\(item)")
    }

    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        debugPrint("shouldPop:\(item)")
        return true
    }

    func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        debugPrint("didPop:\(item)")
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        debugPrint("position:\(bar)")
        return bar.barPosition
    }
}
