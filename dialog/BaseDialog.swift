//
// Created by angcyo on 21/08/31.
//

import Foundation
import UIKit
import SwiftMessages
import TangramKit

class BaseDialog: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initDialog()
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)
        initDialog()
    }

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
            onDialogHide()
        } else {
            onDialogShow()
        }
    }

    /// show
    func onDialogShow() {
        print("onDialogShow:\(bounds):\(safeAreaInsets):\(safeAreaLayoutGuide)")
    }

    /// hide
    func onDialogHide() {
        print("onDialogHide:\(bounds):\(safeAreaInsets):\(safeAreaLayoutGuide)")
    }

    func onCancelClick() {
        hide()
    }

    func onConfirmClick() {
        hide()
    }
}

//MARK: SwiftMessages

private let dialog = SwiftMessages()

extension BaseDialog {

    /// 创建需要显示的UIView
    func createMessageView() -> UIView {
        let messageView = BaseView()
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

        messageView.installContentView(self)
        return messageView
    }

    /// 配置消息¬
    func configMessage(swiftMessage: SwiftMessages) {
        swiftMessage.defaultConfig.dimMode = .blur(style: .dark, alpha: 0.5, interactive: true) //interactive 控制是否点击内容外隐藏对话库
        //.gray(interactive: true)
        swiftMessage.defaultConfig.duration = .forever
        swiftMessage.defaultConfig.interactiveHide = true // 交互隐藏, 下拉隐藏
        swiftMessage.defaultConfig.presentationStyle = .bottom
        swiftMessage.defaultConfig.presentationContext = .automatic
        //.window(windowLevel: .statusBar)
        //.windowScene(CoreSceneDelegate.connectScene!, windowLevel: .statusBar)
        //swiftMessage.show(view: self)
    }

    /// 显示对话框
    func show() {
        let messageView = createMessageView()
        configMessage(swiftMessage: dialog)
        //onDialogShow()
        dialog.show(view: messageView)
    }

    func hide() {
        //onDialogHide()
        dialog.hide(animated: true)
    }
}