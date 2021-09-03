//
// Created by wayto on 2021/8/3.
//

import Foundation
import UIKit

class BaseTabBarController: UITabBarController, INavigation {

    init() {
        super.init(nibName: nil, bundle: nil)
        initController()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initController()
    }

    //MARK: INavigation

    var showNavigationBar: Bool = false
    var showToolbar: Bool = false

    func initController() {
        L.i("->创建:\(self)")

        //init
        tabBar.isTranslucent = true // 半透明, 毛玻璃效果
        tabBar.backgroundColor = UIColor.white
        //tabBar.barTintColor = UIColor.green //背景着色器
        //tabBar.shadowImage //横向
        //tabBar.standardAppearance.shadowImage
        //tabBar.standardAppearance.shadowColor = nil //横向的颜色

        // 未选中时文本和图片的着色器
        ///tabBar.selectedImageTintColor = UIColor.red //废弃, 请使用tabBar.tintColor
        //tabBar.tintColor = Res.color.colorAccent //其他状态的着色
        //tabBar.unselectedItemTintColor = Res.color.iconColor //未选中时的着色
    }

    /// Swift 的ARC, 在创建对象之后, 没有被引用会立马被回收.
    /// https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
    deinit {
        L.w("->销毁:\(self)")
    }
}

extension UIViewController {

    /// 添加一个child
    func addChild(vc: UIViewController,
                  title: String,
                  image: UIImage?,
                  selectedImage: UIImage?) {
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = selectedImage
        vc.tabBarItem.title = title
        vc.tabBarItem.badgeColor = Res.color.colorAccent
        //vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.red], for: .selected) //文本颜色
        addChild(vc)
    }

    /// 更新徽章
    func updateBadge(_ value: String?) {
        tabBarItem.badgeValue = value
    }
}