//
// Created by angcyo on 21/08/31.
//

import Foundation
import UIKit
import SwiftMessages
import TangramKit

/// 对话框载体

class BaseDialogView: BaseView {

    var contentView: UIView? = nil

    func setContentView(_ contentView: UIView) {
        self.contentView = contentView
        render(contentView)
    }

    override func installContentView(_ contentView: UIView, insets: UIEdgeInsets = .zero) {
        super.installContentView(contentView, insets: insets)
        self.contentView = contentView
    }

    override func installBackgroundView(_ backgroundView: UIView, insets: UIEdgeInsets = .zero) {
        super.installBackgroundView(backgroundView, insets: insets)
    }
}


/// 对话框的内容
/// https://github.com/SwiftKickMobile/SwiftMessages
class BaseDialog: BaseUIView {

    override func initView() {
        super.initView()
        initDialog()
    }

    /// 初始化
    func initDialog() {

    }

    //MARK: Event

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        print("willMove toSuperview:\(self):\(newSuperview)")
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        print("willMove toWindow:\(self):\(newWindow)")

        if newWindow == nil {
            onDialogHideInner()
        } else {
            onDialogShowInner()
        }
    }

    /// 是否是取消
    var isCancel: Bool = true

    /// 回调
    var onDialogShow: (() -> Void)? = nil
    var onDialogHide: (() -> Void)? = nil

    /// show
    func onDialogShowInner() {
        L.i("\(self):\(bounds):\(safeAreaInsets):\(safeAreaLayoutGuide)")
        onDialogShow?()
    }

    /// hide
    func onDialogHideInner() {
        L.i("isCancel:\(isCancel):\(self):\(bounds):\(safeAreaInsets):\(safeAreaLayoutGuide)")
        onDialogHide?()
    }

    func onCancelClick() {
        hideDialog()
    }

    func onConfirmClick() {
        hideDialog()
    }

    //MARK: SwiftMessages

    /// 创建需要显示的UIView
    func createMessageView() -> BaseDialogView {
        let messageView = BaseDialogView()
        /*messageView.tapHandler = { _ in
            L.w("点击窗口外:\(self)")
        }*/

        //view.configureBackgroundView(width: <#T##CGFloat##CoreGraphics.CGFloat#>)
        messageView.backgroundHeight = nil
        //messageView.layoutMargins = .zero
        messageView.respectSafeArea = false //是否考虑安全区域

        let backgroundView = CornerRoundingView()
        backgroundView.cornerRadius = Res.size.roundCommon
        backgroundView.roundedCorners = [.topLeft, .topRight]
        backgroundView.layer.masksToBounds = true
        backgroundView.backgroundColor = UIColor.white
        //messageView.backgroundColor = UIColor.white
        messageView.installBackgroundView(backgroundView)

        //formDialog.pauseBetweenMessages
        //formDialog.defaultConfig.dimMode = .blur(style: .prominent, alpha: 0.5, interactive: true)
        messageView.backgroundView.layoutMargins = UIApplication.mainWindow?.safeAreaInsets ?? .zero

        //messageView.layoutMarginAdditions = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        messageView.configureDropShadow()

        //重点
        messageView.installContentView(self)
        return messageView
    }

    /// 点击窗口外, 是否隐藏对话框
    var hideOnOutside: Bool = true

    /// 是否拖拽返回
    var hideOnDrag: Bool = true

    /// 配置消息¬
    func configMessage(swiftMessage: SwiftMessages) {
        swiftMessage.defaultConfig.dimMode = .blur(style: .dark, alpha: 0.5, interactive: hideOnOutside) //interactive 控制是否点击内容外隐藏对话库
        //.gray(interactive: true)
        swiftMessage.defaultConfig.duration = .forever
        swiftMessage.defaultConfig.interactiveHide = hideOnDrag // 交互隐藏, 下拉隐藏
        swiftMessage.defaultConfig.presentationStyle = .bottom
        swiftMessage.defaultConfig.presentationContext = .automatic
        //.window(windowLevel: .statusBar)
        //.windowScene(CoreSceneDelegate.connectScene!, windowLevel: .statusBar)
        //swiftMessage.show(view: self)
    }
}

//MARK: SwiftMessages

fileprivate let dialog = SwiftMessages()

extension BaseDialog {

    /// 显示对话框
    func showDialog() {
        let messageView = createMessageView()
        configMessage(swiftMessage: dialog)
        //onDialogShow()
        dialog.show(view: messageView)
    }

    func hideDialog(cancel: Bool = false) {
        isCancel = cancel
        dialog.hide(animated: true)
    }
}

/// 隐藏对话框
func hideDialog(cancel: Bool = false) {
    //onDialogHide()
    if let baseDialogView: BaseDialogView = dialog.current() {
        if let baseDialog = baseDialogView.contentView as? BaseDialog {
            baseDialog.isCancel = cancel
        }
    }
    dialog.hide(animated: true)
}