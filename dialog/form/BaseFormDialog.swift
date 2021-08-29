//
// Created by angcyo on 21/08/21.
//

import Foundation
import UIKit
import SwiftMessages
import TangramKit

/// form dialog基类
class BaseFormDialog: UIView {

    /// 标题的高度
    var titleLayoutHeight: CGFloat = 45

    let titleLayout = horizontal()
    let cancel = labelButton("取消")
    let title = titleView("", size: Res.text.normal.size)
    let confirm = labelButton("确定")

    let empty = labelView("暂无数据")

    let line = lineView()
    let contentLayout = TGFrameLayout()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initDialog()
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)
        initDialog()
    }

    func initDialog() {
        titleLayout.render(cancel) {
            $0.wWmH()
            $0.setPadding(padding: 10)
        }

        title.textAlignment = .center
        title.numberOfLines = 1
        titleLayout.render(title) {
            $0.match_parent()
        }

        confirm.isEnabled = true
        confirm.setTitleColor(Res.color.colorAccent, for: .normal)
        confirm.setTitleColor(Res.color.colorAccent, for: .highlighted)
        titleLayout.render(confirm) {
            $0.wWmH()
            $0.setPadding(padding: 10)
        }

        cancel.onClick { _ in
            self.onCancelClick()
        }
        confirm.onClick { _ in
            self.onConfirmClick()
        }

        //titleLayout.mWwH(height: 200)
        titleLayout.mWwH(height: titleLayoutHeight)
        render(titleLayout)

        render(line) {
            $0.makeGravityLeft()
            $0.makeGravityRight()
            $0.makeBottomToBottomOf(self.titleLayout)
            $0.makeHeight(Res.size.line)
        }

        render(contentLayout) {
            $0.makeTopToBottomOf(self.titleLayout)
            $0.makeFullWidth()
            $0.makeGravityBottom()
            //$0.makeHeight(80)
            //$0.backgroundColor = UIColor.red
        }

        initContentLayout(contentLayout)

        //backgroundColor = UIColor.yellow
        //titleLayout.backgroundColor = UIColor.red

        //frame = rect(0, 0, 100, 100)

        //print("test:::\(safeAreaInsets) \(UIApplication.mainWindow?.safeAreaInsets)")
        //layoutMargins = insets(bottom: 100)
    }

    /// 配置内容视图
    func initContentLayout(_ content: UIView) {

    }

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

private let formDialog = SwiftMessages()

extension BaseFormDialog {

    /// 显示对话框
    func show() {
        let messageView = createMessageView()
        configMessage(swiftMessage: formDialog)
        //onDialogShow()
        formDialog.show(view: messageView)
    }

    func hide() {
        //onDialogHide()
        formDialog.hide(animated: true)
    }
}