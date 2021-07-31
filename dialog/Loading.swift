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

import DynamicBlurView

/// 底部加载
func showBottomLoading(_ status: String? = "正在操作...") {

    if let root = UIApplication.mainWindow {

        root.render(DynamicBlurView(frame: UIScreen.main.bounds)) { blurView in
            blurView.blurRadius = 0.5
            blurView.trackingMode = .none
            blurView.isDeepRendering = true
            blurView.tintColor = .clear
            blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            blurView.isUserInteractionEnabled = true //接收用户交互
        }

        root.render(v(Res.Color.bg)) { (view: UIView) in
            view.makeHeight(minHeight: 50)
            //maker.sizeToFit()
            view.makeBottomToBottomOf(nil, offset: -Float(root.safeAreaInsets.bottom) - Res.Size.xx)
            //maker.makeGravityBottom(offset: -10)
            view.makeGravityHorizontal(offset: Int(Res.Size.xxx))
            view.setRound(Res.Size.roundMax)
            view.setBorder(radii: Res.Size.roundMax)

            view.render(NVActivityIndicatorView(frame: cgRect(0, 0, 20, 20),
                    type: .lineSpinFadeLoader,
                    color: Res.Color.colorAccent,
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
        }
    }
}