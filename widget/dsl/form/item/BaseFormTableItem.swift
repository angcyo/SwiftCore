//
// Created by angcyo on 21/08/19.
//

import Foundation
import UIKit

class BaseFormTableItem: DslTableItem, IFormItem {

    /// Label
    var itemLabel: String? = nil

    var formItemConfig: FormItemConfig = FormItemConfig()

    override func bindCellOverride(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCellOverride(cell, indexPath)
    }
}

/// 表单item的config基类
class BaseFormItemCellConfig: IDslCellConfig {

    /// 打底的布局
    let formRoot = frameLayout()

    /// 分割线, 自动add
    let formLine = lineView()

    /// Label, 手动add
    let formLabel = labelView(size: Res.text.label.size, color: Res.text.subTitle.color)

    var labelMinWidth = Res.size.itemMinLabelWidth

    /// 箭头控件, 手动add
    var formArrow = icon(R.image.arrow_right())

    /// 必填小星星, 自动add
    let formRequired = labelView("*", size: Res.text.label.size, color: UIColor.red)

    /// 偏移量
    var requiredOffsetLeft = Res.size.itemRequiredOffsetLeft
    var requiredOffsetTop = Res.size.itemRequiredOffsetTop

    /// 初始化
    func initCellConfig(_ cell: UIView) {
        formRoot.cacheRect()

        formRoot.mWwH()
        formRoot.render(initCellContent())
        formRoot.render(formRequired) {
            $0.gone() //默认隐藏
            $0.wrap_content()
            $0.frameGravityLT(offsetLeft: self.requiredOffsetLeft, offsetTop: self.requiredOffsetTop)
        }
        formRoot.render(formLine) {
            $0.mWwH(height: Res.size.line)
            $0.setMarginHorizontal(Res.size.x)
            $0.frameGravityBottom()
        }
    }

    /// 重写此方法, 实现布局
    func initCellContent() -> UIView {
        UIView()
    }
}