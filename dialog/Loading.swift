//
// Created by wayto on 2021/7/30.
//

import Foundation
import ProgressHUD
import PopupDialog

struct Loading {

    /// 在屏幕中心, 显示一个加载动画
    static func show(_ status: String? = nil) {
        UIApplication.isUserInteractionEnabled(false)
        ProgressHUD.show(status, interaction: true)
    }

    /// 隐藏对话框
    static func hide() {
        UIApplication.isUserInteractionEnabled(true)
        ProgressHUD.dismiss()
    }
}

/// 快速显示加载框
func showLoading(_ status: String? = nil) {
    Loading.show(status)
}

/// 隐藏
func hideLoading() {
    Loading.hide()
}