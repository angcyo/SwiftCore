//
// Created by angcyo on 21/09/16.
//

import Foundation
import UIKit

/// 多行编辑item, 上下结构

class FormTextViewMultiTableItem: BaseFormTableItem, ITextViewItem {

    /// 配置项
    var textViewItemConfig: TextViewItemConfig = TextViewItemConfig()

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellOf(FormTextViewMultiTableCell.self) {
            initTextViewItem($0.text)
        }
    }

    //MARK: 代理方法, 需要覆盖重写才会生效. 还需要重新设置delegate = self

    /// 文本内容改变后,保存值
    func textViewDidChangeSelection(_ textView: UITextView) {
        //L.d("....textViewDidChangeSelection:\(textView.text)")
        textViewItemConfig.itemEditText = textView.text
        updateFormItemValue(textView.text)
    }

    /// 限制最大输入字符数
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText string: String) -> Bool {
        guard let text = textView.text else {
            return true
        }
        let textLength = text.count + string.count - range.length
        return textLength <= textViewItemConfig.itemEditMaxLength
    }

}

class FormTextViewMultiTableCell: BaseFormTableCell {

    let text = placeholderTextView()

    override func initFormCell() {
        super.initFormCell()
        renderCell(text) {
            //$0.backgroundColor = .red
            $0.makeGravityLeft(offset: Res.size.x)
            $0.makeGravityRight(offset: Res.size.x)
            $0.makeGravityBottom(offset: Res.size.x, priority: .high)
            $0.makeTopToBottomOf(self.formLabel, offset: Res.size.x)
            $0.makeHeight(110)
        }
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
}