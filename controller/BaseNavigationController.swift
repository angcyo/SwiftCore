//
// Created by angcyo on 21/08/04.
//

import Foundation
import UIKit

/// 导航控制器
class BaseNavigationController: UINavigationController,
        UINavigationControllerDelegate,
        UINavigationBarDelegate,
        UIGestureRecognizerDelegate {

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

        // 侧滑手势
        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self

        //toolbar 显示在界面底部的工具栏
        //setToolbarHidden(false, animated: true)

        //navigationBar 显示在界面顶部的导航栏
        //Cannot manually set the delegate on a UINavigationBar managed by a controller.
        //navigationBar.delegate = self
        //navigationBar.standardAppearance

        navigationBar.barStyle = .default
        //navigationBar.isTranslucent = true //透明
        //navigationBar.barTintColor = UIColor.red //背景着色

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
        L.w("\(threadName())->销毁:\(self)")
    }

    //MARK: 导航代理

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        L.i("即将显示VC:\(viewController):\(animated)")
        if let navigation = viewController as? INavigation {
            //navigationController.navigationBar.isHidden = !navigation.showNavigationBar
            //navigationController.isNavigationBarHidden = !navigation.showNavigationBar
            navigationController.setNavigationBarHidden(!navigation.showNavigationBar, animated: animated)
        } else {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }

        //viewController.navigationItem.standardAppearance?.shadowColor = UIColor.clear
        //navigationController.navigationBar.standardAppearance.shadowImage = viewController.navigationItem.standardAppearance?.shadowImage
        //navigationController.navigationBar.standardAppearance.shadowColor = viewController.navigationItem.standardAppearance?.shadowColor

        //在这里可以修改返回按钮
        //let backItem = UIBarButtonItem()
        //backItem.title = "Back"
        //backItem.tintColor = .red
        //viewController.navigationItem.backBarButtonItem = backItem
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        //"已经显示VC:<Wayto_GBSecurity_iOS.HomeController: 0x117d08390>:true:(0.0, 44.0, 375.0, 44.0)"
        print("已经显示VC:\(viewController):\(animated):\(navigationController.navigationBar.frame)")
    }

    /// 支持的屏幕方向
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        print("navigationControllerSupportedInterfaceOrientations")
        return .portrait
    }

    /// 预选方向
    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        print("navigationControllerPreferredInterfaceOrientationForPresentation")
        return .portrait
    }

    /// 过渡东安湖
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print("interactionControllerFor:\(animationController)")
        return nil
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("animationControllerFor:\(operation):fromVC:\(fromVC) :toVC:\(toVC)")
        return nil
    }

    //MARK: 导航栏代理

    func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        print("shouldPush:\(item)")
        return true
    }

    func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        print("didPush:\(item)")
    }

    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        print("shouldPop:\(item)")
        return true
    }

    func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        print("didPop:\(item)")
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        print("position:\(bar)")
        return bar.barPosition
    }

    //MARK: 侧滑手势代理

    /// 是否可以触摸
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count <= 1 {
            return false
        }
        return true
    }

    /// 是否需要双指触摸
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    /// 需要接收触摸的对象
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }

    /// 需要接收按下的对象
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return true
    }

    /// 需要接收对象
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        return true
    }
}
