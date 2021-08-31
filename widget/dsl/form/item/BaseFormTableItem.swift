//
// Created by angcyo on 21/08/19.
//

import Foundation
import UIKit

/// 表单item基类
open class BaseFormTableItem: DslTableItem, IFormItem {

    /// Label, 需要手动使用
    var itemLabel: String? = nil
    var itemLabelMinWidth: CGFloat? = nil

    /// 显示底部横线, 需要手动使用, nil 智能设置
    var itemShowLine: Bool? = nil
    /// 智能控制
    var _itemShowLine: Bool {
        get {
            if let show = itemShowLine {
                return show
            } else {
                return !isSectionLast()
            }
        }
    }

    override var itemChange: Bool {
        get {
            super.itemChange
        }
        set {
            super.itemChange = newValue
            if newValue {
                //表单的值改变之后, 关闭忽略
                formItemConfig.formIgnore = false
            }
        }
    }

    /// 表单item的配置项
    var formItemConfig: FormItemConfig = FormItemConfig()

    public required init() {
        super.init()
    }

    /// bind cell
    override func bindCellOverride(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCellOverride(cell, indexPath)

        if let cell = cell as? DslTableCell {
            if let cellConfig = cell.getCellConfig() as? BaseFormItemCellConfig {

                cellConfig.formLine.visible(_itemShowLine) //Line
                cellConfig.formLabel.text = itemLabel //Label
                cellConfig.formRequired.visible(formItemConfig.formRequired) //必填提示

                if let itemLabelMinWidth = itemLabelMinWidth {
                    //label最小宽度
                    cellConfig.labelMinWidth = itemLabelMinWidth
                    cellConfig.formLabel.wrap_content(minWidth: itemLabelMinWidth)
                }
            }
        }
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

    func getRootView() -> UIView {
        formRoot
    }

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

        // 箭头控件
        formArrow.contentMode = .scaleAspectFit
        formArrow.wh(width: 16, height: 16)
    }

    /// 重写此方法, 实现布局
    func initCellContent() -> UIView {
        UIView()
    }
}