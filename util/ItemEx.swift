//
// Created by angcyo on 21/09/07.
//

import Foundation
import UIKit

/// 作用于 [UINavigationBar]
extension UINavigationItem {

    //MARK: left

    @discardableResult
    func setLeftBarButton(title: String?, animated: Bool = true, _ action: @escaping (UIResponder) -> Void) -> UIBarButtonItem {
        setLeftBarButton(item: .item(title: title, action), animated: animated)
    }

    @discardableResult
    func setLeftBarButton(image: UIImage?, animated: Bool = true, _ action: @escaping (UIResponder) -> Void) -> UIBarButtonItem {
        setLeftBarButton(item: .item(image: image, action), animated: animated)
    }

    @discardableResult
    func setLeftBarButton(item: UIBarButtonItem, animated: Bool = true) -> UIBarButtonItem {
        setLeftBarButton(item, animated: animated)
        return item
    }

    //MARK: left append

    @discardableResult
    func appendLeftBarButton(title: String?, animated: Bool = true, _ action: @escaping (UIResponder) -> Void) -> UIBarButtonItem {
        appendLeftBarButton(.item(title: title, action), animated: animated)
    }

    @discardableResult
    func appendLeftBarButton(image: UIImage?, animated: Bool = true, _ action: @escaping (UIResponder) -> Void) -> UIBarButtonItem {
        appendLeftBarButton(.item(image: image, action), animated: animated)
    }

    @discardableResult
    func appendLeftBarButton(customView: UIView, animated: Bool = true) -> UIBarButtonItem {
        appendLeftBarButton(.item(customView: customView), animated: animated)
    }

    @discardableResult
    func appendLeftBarButton(_ item: UIBarButtonItem, animated: Bool = true) -> UIBarButtonItem {
        var items: [UIBarButtonItem] = leftBarButtonItems ?? []
        items.add(item)
        setLeftBarButtonItems(items, animated: animated)
        return item
    }

    //MARK: right

    @discardableResult
    func setRightBarButton(title: String?, animated: Bool = true, _ action: @escaping (UIResponder) -> Void) -> UIBarButtonItem {
        setRightBarButton(item: .item(title: title, action), animated: animated)
        //backBarButtonItem
    }

    @discardableResult
    func setRightBarButton(image: UIImage?, animated: Bool = true, _ action: @escaping (UIResponder) -> Void) -> UIBarButtonItem {
        setRightBarButton(item: .item(image: image, action), animated: animated)
    }

    @discardableResult
    func setRightBarButton(item: UIBarButtonItem, animated: Bool = true) -> UIBarButtonItem {
        setRightBarButton(item, animated: animated)
        return item
    }

    //MARK: right append

    @discardableResult
    func appendRightBarButton(title: String?, animated: Bool = true, _ action: @escaping (UIResponder) -> Void) -> UIBarButtonItem {
        appendRightBarButton(.item(title: title, action), animated: animated)
    }

    @discardableResult
    func appendRightBarButton(image: UIImage?, animated: Bool = true, _ action: @escaping (UIResponder) -> Void) -> UIBarButtonItem {
        appendRightBarButton(.item(image: image, action), animated: animated)
    }

    @discardableResult
    func appendRightBarButton(customView: UIView, animated: Bool = true) -> UIBarButtonItem {
        appendRightBarButton(.item(customView: customView), animated: animated)
    }

    @discardableResult
    func appendRightBarButton(_ item: UIBarButtonItem, animated: Bool = true) -> UIBarButtonItem {
        var items: [UIBarButtonItem] = rightBarButtonItems ?? []
        items.add(item)
        setRightBarButtonItems(items, animated: animated)
        return item
    }
}

/// parent
extension UIBarItem {
    static var KEY_ON_ACTION = "s_key_on_action"
}

/// 作用于[UINavigationItem]
extension UIBarButtonItem {

    static func item(title: String?, _ action: @escaping (UIResponder) -> Void) -> UIBarButtonItem {
        let observer = TargetObserver()
        observer.onAction = action
        let item = UIBarButtonItem(title: title, style: .plain,
                target: observer, action: #selector(TargetObserver.onActionInner(sender:)))
        //item.tintColor = Res.color.iconColorDark
        item.setObject(&UIBarItem.KEY_ON_ACTION, observer) //hold
        return item
    }

    static func item(image: UIImage?, _ action: @escaping (UIResponder) -> Void) -> UIBarButtonItem {
        let observer = TargetObserver()
        observer.onAction = action
        let item = UIBarButtonItem(image: image, style: .plain,
                target: observer, action: #selector(TargetObserver.onActionInner(sender:)))
        //item.tintColor = Res.color.iconColorDark
        item.setObject(&UIBarItem.KEY_ON_ACTION, observer) //hold
        return item
    }

    static func item(customView: UIView) -> UIBarButtonItem {
        let item = UIBarButtonItem(customView: customView)
        //item.tintColor = Res.color.iconColorDark
        return item
    }
}

/// 作用于 [UITabBar]
extension UITabBarItem {

}

