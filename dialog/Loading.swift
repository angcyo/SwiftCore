//
// Created by wayto on 2021/7/30.
//

import Foundation
import ProgressHUD
import PopupDialog
import NVActivityIndicatorView

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

/// 底部加载
func showBottomLoading(_ status: String? = "正在操作...") {
    let view = v(Res.Color.colorAccent)

    view.render(NVActivityIndicatorView(frame: cgRect(0, 0, 20, 20),
            type: .lineSpinFadeLoader,
            color: UIColor.white,
            padding: 0)) { (view: NVActivityIndicatorView) in
        view.startAnimating()
        view.makeCenterY()
        view.makeGravityLeft(offset: Res.Size.x)
    }

    view.render(labelView(status)) { label in
        //label.setBackground(UIColor.green)
        label.sizeToFit()
        label.makeLeftToRightOf(offset: Res.Size.x)
        label.makeCenterY()
    }

    if let root = UIApplication.mainWindow {
        root.render(view) { maker in
            maker.makeHeight(minHeight: 40)
            //maker.sizeToFit()
            maker.makeBottomToBottomOf(nil, offset: -Float(root.safeAreaInsets.bottom) - Res.Size.xx)
            //maker.makeGravityBottom(offset: -10)
            maker.makeGravityHorizontal(offset: Int(Res.Size.xxx))

            maker.setRound(CGFloat(Res.Size.roundMax))
        }
    }
}