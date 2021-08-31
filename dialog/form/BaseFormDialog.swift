//
// Created by angcyo on 21/08/21.
//

import Foundation
import UIKit
import SwiftMessages
import TangramKit

/// form dialog基类
class BaseFormDialog: BaseDialog {

    /// 标题的高度
    var titleLayoutHeight: CGFloat = 45

    let titleLayout = horizontal()
    let cancel = labelButton("取消")
    let title = titleView("", size: Res.text.normal.size)
    let confirm = labelButton("确定")

    let empty = labelView("暂无数据")

    let line = lineView()
    let contentLayout = TGFrameLayout()

    override func initDialog() {

        titleLayout.render(cancel) {
            $0.wWmH()
            $0.setPadding(10)
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
            $0.setPadding(10)
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
}