//
// Created by wayto on 2021/7/30.
//

import Foundation
import UIKit

extension UIAlertController {

    //获取输入的文本字符串
    func getFirstText() -> String? {
        textFields?.first?.text
    }
}

/// UIAlertAction
func alertAction(_ title: String?,
                 style: UIAlertAction.Style = .default,
                 _ handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
    let action = UIAlertAction(title: title, style: style, handler: handler)
    return action
}

/// 快速显示一个需要用户确定的对话框
@discardableResult
func showAlert(title: String? = nil,
               message: String? = nil,
               confirm: String = "确定",
               cancel: Bool = true,
               _ confirmAction: ((UIAlertController) -> Void)? = nil) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: confirm, style: .default) { action in
        confirmAction?(alert)
    })
    if cancel {
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
    }
    showViewController(alert)
    return alert
}

/// 显示一个带输入框的Alert
@discardableResult
func showInputAlert(title: String? = nil,
                    message: String? = nil,
                    confirm: String = "确定",
                    cancel: Bool = true,
                    placeholder: String? = "请输入...",
                    configTextField: ((UITextField) -> Void)? = nil,
                    _ confirmAction: ((String?) -> Void)? = nil) -> UIAlertController {
    let alert = showAlert(title: title, message: message, confirm: confirm, cancel: cancel) { alert in
        confirmAction?(alert.getFirstText())
    }
    alert.addTextField { field in
        field.placeholder = placeholder
        configTextField?(field)
    }
    return alert
}

/// 显示一个sheet, 多用于显示 男/女 选择, 等选择对话框
@discardableResult
func showSheet(title: String? = nil,
               message: String? = nil,
               cancel: Bool = true,
               actions: [UIAlertAction] = []) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    actions.forEach { action in
        alert.addAction(action)
    }
    if cancel {
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
    }
    showViewController(alert)
    return alert
}
