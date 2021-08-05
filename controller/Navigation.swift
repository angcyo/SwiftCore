//
// Created by angcyo on 21/08/04.
//

import Foundation
import UIKit

/// 导航
protocol Navigation {

    /// 当前界面, 是否需要显示导航栏
    var showNavigationBar: Bool { get set }
}

/// 快速创建导航item
func imageBarItem(_ image: UIImage?, _ action: @escaping (UIResponder) -> Void) -> UIBarButtonItem {
    let observer = TargetObserver()
    observer.onAction = action
    let item = UIBarButtonItem(image: image,
            style: .plain,
            target: observer,
            action: #selector(TargetObserver.onActionInner(sender:)))
    var keyOnClick = "key_on_click"
    item.setObject(&keyOnClick, observer) //ARC
    return item
}