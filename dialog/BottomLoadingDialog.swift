//
// Created by angcyo on 21/09/04.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SwiftMessages

/// 底部加载动画对话框

class BottomLoadingDialog: BaseDialog {

    /// 进度指示器
    let indicator = NVActivityIndicatorView(frame: .zero,
            type: .lineSpinFadeLoader,
            color: Res.color.colorAccent,
            padding: 0)

    /// 提示文本
    let text = subTitleView()

    /// x按钮
    let icon = iconView(sfXCircleFill())

    override func initDialog() {
        super.initDialog()

        render(indicator)
        render(text)
        render(icon)

        with(indicator) {
            $0.makeLeftIn(offsetLeft: Res.size.x2,
                    offsetTop: Res.size.x2,
                    offsetBottom: Res.size.x2)
            $0.makeWidthHeight(size: 20)

            $0.startAnimating()
        }

        with(text) {
            $0.makeLeftToRightOf(indicator, offset: Res.size.x)
            $0.makeCenterY()
        }

        with(icon) {
            $0.makeGravityRight(offset: Res.size.x2)
            $0.makeCenterY()
            $0.makeWidthHeight(size: 20)
        }

        // 取消对话框
        icon.onClick { _ in
            self.hideDialog(cancel: true)
        }
    }

    override func createMessageView() -> BaseDialogView {
        let messageView = BaseDialogView()

        messageView.backgroundHeight = nil
        messageView.respectSafeArea = true //是否考虑安全区域

        let backgroundView = CornerRoundingView()
        backgroundView.cornerRadius = Res.size.roundMax
        backgroundView.roundedCorners = [.allCorners]
        backgroundView.layer.masksToBounds = true
        backgroundView.backgroundColor = Res.color.bg
        messageView.installBackgroundView(backgroundView,
                insets: insets(left: Res.size.xx, right: Res.size.xx))

        //messageView.backgroundColor = Res.color.warning //Res.color.bg
        //messageView.backgroundView.layoutMargins = insets(size: 40) //

        messageView.configureDropShadow()

        messageView.installContentView(self)
        return messageView
    }
}

/// 底部加载
func showBottomLoading(_ text: String? = "处理中...", _ dsl: ((BottomLoadingDialog) -> Void)? = nil) {
    let dialog = BottomLoadingDialog()
    dialog.hideOnOutside = false
    dialog.hideOnDrag = false
    dialog.text.text = text
    dialog.onDialogHide = {
        dsl?(dialog)
    }
    dsl?(dialog)
    dialog.showDialog()
}