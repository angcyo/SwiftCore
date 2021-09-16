//
// Created by angcyo on 21/09/01.
//

import Foundation
import UIKit
import TangramKit

/// 支持多行编辑item, 左右结构
open class FormTextViewTableItem: BaseFormTableItem, ITextViewItem {

    /// 配置项
    var textViewItemConfig: TextViewItemConfig = TextViewItemConfig()

    /// 单位提示文本
    var itemRightTitle: String? = nil

    /// 输入框的高度, 负数表示 wrap_content
    var itemTextViewHeight: CGFloat = -1 //Res.size.minHeight

    public required init() {
        super.init()
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellConfigOf(FormTextViewCellConfig.self) {
            initTextViewItem($0.text)
            $0.rightTitle.text = itemRightTitle
            $0.setTextViewHeight(itemTextViewHeight)
        }
    }

    //MARK: 代理方法, 需要覆盖重写才会生效. 还需要重新设置delegate = self

    /// 文本内容改变后,保存值
    open func textViewDidChangeSelection(_ textView: UITextView) {
        //L.d("....textViewDidChangeSelection:\(textView.text)")
        textViewItemConfig.itemEditText = textView.text
        updateFormItemValue(textView.text)
    }

    /// 限制最大输入字符数
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText string: String) -> Bool {
        guard let text = textView.text else {
            return true
        }
        let textLength = text.count + string.count - range.length
        return textLength <= textViewItemConfig.itemEditMaxLength
    }
}

class FormTextViewTableCell: DslTableCell {

    fileprivate let cellConfig: FormTextViewCellConfig = FormTextViewCellConfig()

    override func getCellConfig() -> IDslCellConfig? {
        cellConfig
    }
}

//MARK: cell 界面声明, 用于兼容UITableView和UICollectionView

class FormTextViewCellConfig: BaseFormItemCellConfig {

    let text = placeholderTextView()

    let rightTitle = subTitleView(size: Res.text.label.size) //右边提示的文本

    override func getRootView(_ cell: UIView) -> UIView {
        cell.cellContentView
    }

    override func initCellConfig(_ cell: UIView) {
        //super.initCellConfig(cell)
        cell.cellContentView.render(formLabel)
        cell.cellContentView.render(text)
        cell.cellContentView.render(rightTitle)
        cell.cellContentView.render(formLine)
        cell.cellContentView.render(formRequired)

        formLabel.lowStretch()
        setLabelMinWidth()

        rightTitle.lowStretch()
        with(rightTitle) {
            //$0.backgroundColor = UIColor.green
            $0.makeGravityRight(offset: Res.size.x)
            $0.makeCenterY()
            //$0.sizeToFit()
        }

        //text
        text.highStretch()
        setTextViewHeight(-1)

        with(formLine) {
            //$0.makeTopToBottomOf(text, offset: Res.size.x)
            $0.makeGravityBottom()
            $0.makeGravityHorizontal(offset: Res.size.x)
            $0.makeHeight(Res.size.line)
        }

        with(formRequired) {
            $0.setVisible(formRequiredVisible)
            $0.makeGravityLeft(offset: requiredOffsetLeft)
            $0.makeGravityTop(formLabel, offset: requiredOffsetLeft)
            $0.sizeToFit()
        }

        setShowLine()
        setShowRequired()
    }

    /// 文本输入视图的高度, <=0 自适应
    func setTextViewHeight(_ height: CGFloat) {
        text.remakeView {
            //$0.backgroundColor = UIColor.red

            let offset = Res.size.x
            let offsetLeft = max(labelMinWidth, formLabel.sizeOf().width) + offset
            let offsetRight = rightTitle.sizeOf(offsetWidth: offset).width

            $0.makeGravityLeft(offset: offsetLeft)
            $0.makeGravityRight(offset: offsetRight)
            $0.makeGravityTop(offset: Res.size.x)
            $0.makeGravityBottom(offset: Res.size.x)

            if height > 0 {
                $0.makeHeight(height)
            }
        }
    }

    override func setLabelMinWidth() {
        formLabel.remakeView {
            $0.makeGravityLeft(offset: Res.size.x)
            $0.makeCenterY()
            $0.makeWidth(minWidth: labelMinWidth)
        }
    }

    override func setShowLine() {
        formLine.setVisible(formLineVisible)
    }

    override func setShowRequired() {
        formRequired.setVisible(formRequiredVisible)
    }
}