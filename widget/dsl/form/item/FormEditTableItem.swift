//
// Created by angcyo on 21/08/18.
//

import Foundation
import UIKit
import TangramKit

/// 简单的编辑item
class FormEditTableItem: BaseFormTableItem, IEditItem {

    var editItemConfig: EditItemConfig = EditItemConfig()

    var itemRightTitle: String? = nil

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        guard let cell = cell as? FormEditTableCell else {
            return
        }

        editItemConfig.itemEditEnable = formItemConfig.formCanEdit
        initEditItem(cell.cellConfig.text)

        cell.cellConfig.formLine.visible(_itemShowLine) //Line
        cell.cellConfig.formLabel.text = itemLabel //Label
        cell.cellConfig.formRequired.visible(formItemConfig.formRequired) //必填提示

        cell.cellConfig.rightTitle.text = itemRightTitle
    }

    /// 文本内容改变后,保存值
    func textFieldDidChangeSelection(_ textField: UITextField) {
        editItemConfig.itemEditText = textField.text
        updateFormItemValue(textField.text)
    }

    /// 收起键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /// 限制最大输入字符数
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let textLength = text.count + string.count - range.length
        return textLength <= editItemConfig.itemEditMaxLength
    }
}

class FormEditTableCell: DslTableCell {

    let cellConfig: FormEditCellConfig = FormEditCellConfig()

    override func getCellConfig() -> IDslCellConfig? {
        cellConfig
    }
}

//MARK: cell 界面声明, 用于兼容UITableView和UICollectionView

class FormEditCellConfig: BaseFormItemCellConfig {

    let wrap = horizontal()
    let text = textFieldView(borderStyle: .none)
    let rightTitle = subTitleView(size: Res.text.label.size) //右边提示的文本

    override func initCellContent() -> UIView {
        wrap.setPadding(Res.size.x)
        wrap.mWwH(minHeight: Res.size.itemMinHeight)
        wrap.setGravity(TGGravity.vert.center)

        wrap.render(formLabel) {
            $0.wrap_content(minWidth: self.labelMinWidth)
        }

        wrap.render(text) {
            $0.mWwH(minHeight: Res.size.minHeight)
        }
        wrap.render(rightTitle) {
            $0.wrap_content()
        }

        return wrap
    }
}