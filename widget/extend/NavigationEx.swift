//
// Created by angcyo on 21/09/04.
//

import Foundation
import UIKit

/// 自定义导航栏
/// https://developer.apple.com/documentation/uikit/uinavigationcontroller/customizing_your_app_s_navigation_bar

extension UINavigationBar {

    /// 设置导航标题颜色
    func setTitleColor(_ color: UIColor = Res.text.normal.color) {
        var attributes = titleTextAttributes ?? [:]
        attributes[.foregroundColor] = color
        titleTextAttributes = attributes
    }

    /// 设置导航标题加粗
    func setTitleBold(_ bold: Bool = true) {
        var attributes = titleTextAttributes ?? [:]

        var font: UIFont = attributes[.font] as? UIFont ?? Res.font.normal

        if bold {
            font = font.bold()
        } else {
            font = font.normal()
        }

        attributes[.font] = font
        titleTextAttributes = attributes
    }

    /// 移除阴影图片/颜色
    func removeShadow() {
        standardAppearance.shadowImage = nil
        standardAppearance.shadowColor = UIColor.clear
    }

}

extension UINavigationItem {

    /// Prompt
    func setTooltip(_ prompt: String?) {
        self.prompt = prompt
    }
}

extension UIBarButtonItem {

    /// 菜单
    @available(iOS 14.0, *)
    func setMenu() {
        /*let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString("Copy", comment: ""), image: UIImage(systemName: "doc.on.doc"), handler: menuHandler),
            UIAction(title: NSLocalizedString("Rename", comment: ""), image: UIImage(systemName: "pencil"), handler: menuHandler),
            UIAction(title: NSLocalizedString("Duplicate", comment: ""), image: UIImage(systemName: "plus.square.on.square"), handler: menuHandler),
            UIAction(title: NSLocalizedString("Move", comment: ""), image: UIImage(systemName: "folder"), handler: menuHandler)
        ])
        menu = barButtonMenu*/
    }
}