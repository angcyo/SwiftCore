//
// Created by wayto on 2021/8/3.
//

import Foundation
import UIKit

class BaseTabBarController: UITabBarController, Navigation {

    init() {
        super.init(nibName: nil, bundle: nil)
        debugPrint("\(threadName())->创建:\(self)")
        initController()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    var showNavigationBar: Bool = false

    func initController() {
        //init
        //tabBarItem = nil
    }

    /// Swift 的ARC, 在创建对象之后, 没有被引用会立马被回收.
    /// https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
    deinit {
        debugPrint("\(threadName())->销毁:\(self)")
    }

}