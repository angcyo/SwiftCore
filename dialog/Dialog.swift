//
// Created by wayto on 2021/7/30.
//

import Foundation
import ProgressHUD
import PopupDialog

struct Dialog {

    static func initDialog() {
        //ProgressHUD.colorHUD = Res.Color.colorAccent
        //ProgressHUD.colorStatus = Res.Color.colorAccent //状态文本的颜色
        //ProgressHUD.colorProgress = Res.Color.colorAccent
        //ProgressHUD.colorBackground = Res.Color.colorAccent
        ProgressHUD.colorAnimation = Res.Color.colorAccent //动画的颜色
    }

    /// 显示一个成功提示
    static func succeed(_ status: String? = nil) {
        UIApplication.isUserInteractionEnabled(true)
        ProgressHUD.showSucceed(status)
    }

    /// 显示一个失败提示
    static func failed(_ status: String? = nil) {
        UIApplication.isUserInteractionEnabled(true)
        ProgressHUD.showFailed(status)
    }
}

/// 显示一个消息提示对话框
func messageDialog(title: String? = nil,
                   message: String? = nil,
                   image: UIImage? = nil,
                   confirm: String = "确定",
                   cancel: Bool = true,
                   _ confirmAction: ((PopupDialog) -> Void)? = nil) {

    // https://github.com/Orderella/PopupDialog
    let popup = PopupDialog(title: title,
            message: message,
            image: image,
            buttonAlignment: .horizontal,
            transitionStyle: .bounceUp)

    var buttons: [PopupDialogButton] = []

    // Create buttons
    if cancel {
        let cancelButton = CancelButton(title: "取消", action: nil)
        buttons.append(cancelButton)
    }
    let confirmButton = DefaultButton(title: confirm) {
        confirmAction?(popup)
    }
    buttons.append(confirmButton)

    // Add buttons to dialog
    // Alternatively, you can use popup.addButton(buttonOne)
    // to add a single button
    popup.addButtons(buttons)

    //popup.modalPresentationStyle = .none
    // Present dialog
    showViewController(popup)
}