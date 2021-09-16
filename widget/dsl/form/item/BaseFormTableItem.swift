//
// Created by angcyo on 21/08/19.
//

import Foundation
import UIKit

/// 表单item基类
open class BaseFormTableItem: DslTableItem, IFormItem {

    /// Label, 需要手动使用
    var itemLabel: String? = nil {
        didSet {
            if let label = itemLabel {
                if self is FormWheelTableItem || self is FormAvatarTableItem {
                    formItemConfig.formVerifyErrorTip = "请选择\(label)"
                } else {
                    formItemConfig.formVerifyErrorTip = "请输入\(label)"
                }
            }
        }
    }
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

        //cell
        cell.cellOf(BaseFormTableCell.self) {
            //$0.formLine.visible(_itemShowLine) //Line
            $0.formLineVisible = _itemShowLine

            $0.formLabel.text = itemLabel //Label

            $0.formRequiredVisible = formItemConfig.formRequired //必填提示
            ///$0.formRequired.visible(formItemConfig.formRequired) //必填提示

            if let itemLabelMinWidth = itemLabelMinWidth {
                //label最小宽度
                $0.labelMinWidth = itemLabelMinWidth

                //$0.formLabel.wrap_content(minWidth: itemLabelMinWidth)
            }
        }

        //cell config
        cell.cellConfigOf(BaseFormItemCellConfig.self) {
            //$0.formLine.visible(_itemShowLine) //Line
            $0.formLineVisible = _itemShowLine

            $0.formLabel.text = itemLabel //Label

            $0.formRequiredVisible = formItemConfig.formRequired //必填提示
            ///$0.formRequired.visible(formItemConfig.formRequired) //必填提示

            if let itemLabelMinWidth = itemLabelMinWidth {
                //label最小宽度
                $0.labelMinWidth = itemLabelMinWidth

                //$0.formLabel.wrap_content(minWidth: itemLabelMinWidth)
            }
        }
    }
}

//MARK: 只能在UITableView中使用

class BaseFormTableCell: DslTableCell {

    /// 分割线, 自动add
    let formLine = lineView()

    var formLineVisible = true {
        didSet {
            setShowLine()
        }
    }

    /// Label, 手动add
    let formLabel = labelView(size: Res.text.label.size, color: Res.text.subTitle.color)

    var labelMinWidth = Res.size.itemMinLabelWidth {
        didSet {
            setLabelMinWidth()
        }
    }

    /// 箭头控件, 手动add
    var formArrow = icon(R.image.icon_arrow_right())

    /// 必填小星星, 自动add
    let formRequired = labelView("*", size: Res.text.label.size, color: UIColor.red)

    /// 偏移量
    var requiredOffsetLeft = Res.size.itemRequiredOffsetLeft
    var requiredOffsetTop = Res.size.itemRequiredOffsetTop

    var formRequiredVisible = false {
        didSet {
            setShowRequired()
        }
    }

    override func initCell() {
        super.initCell()

        initFormCell()
    }

    func initFormCell() {

        // 箭头控件
        formArrow.contentMode = .scaleAspectFit
        //formArrow.frame = cgRect(16, 16)

        setShowLine()
        setShowRequired()
    }

    /// MARK: change

    func setLabelMinWidth() {
        formLabel.makeWidth(minWidth: labelMinWidth)
    }

    func setShowLine() {
        formLine.setVisible(formLineVisible)
    }

    func setShowRequired() {
        formRequired.setVisible(formRequiredVisible)
    }
}

//MARK: cell 界面声明, 用于兼容UITableView和UICollectionView

/// 表单item的config基类
class BaseFormItemCellConfig: IDslCellConfig {

    /// 打底的布局
    let formRoot = frameLayout()

    /// 分割线, 自动add
    let formLine = lineView()

    var formLineVisible = true {
        didSet {
            setShowLine()
        }
    }

    /// Label, 手动add
    let formLabel = labelView(size: Res.text.label.size, color: Res.text.subTitle.color)

    var labelMinWidth = Res.size.itemMinLabelWidth {
        didSet {
            setLabelMinWidth()
        }
    }

    /// 箭头控件, 手动add
    var formArrow = icon(R.image.icon_arrow_right())

    /// 必填小星星, 自动add
    let formRequired = labelView("*", size: Res.text.label.size, color: UIColor.red)

    var formRequiredVisible = false {
        didSet {
            setShowRequired()
        }
    }

    /// 偏移量
    var requiredOffsetLeft = Res.size.itemRequiredOffsetLeft
    var requiredOffsetTop = Res.size.itemRequiredOffsetTop

    func getRootView(_ cell: UIView) -> UIView {
        formRoot
    }

    /// 初始化
    func initCellConfig(_ cell: UIView) {
        formRoot.cacheRect()

        formRoot.mWwH()
        formRoot.render(initCellContent())
        formRoot.render(formRequired) {
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

        setShowLine()
        setShowRequired()
    }

    /// 重写此方法, 实现布局
    func initCellContent() -> UIView {
        UIView()
    }

    /// MARK: change

    func setLabelMinWidth() {
        formLabel.wrap_content(minWidth: labelMinWidth)
    }

    func setShowLine() {
        formLine.visible(formLineVisible)
    }

    func setShowRequired() {
        formRequired.visible(formRequiredVisible)
    }
}