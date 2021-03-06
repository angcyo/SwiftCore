//
// Created by angcyo on 21/08/18.
//

import Foundation
import UIKit
import TangramKit

/// 简单的编辑item
open class FormTextFieldTableItem: BaseFormTableItem, ITextFieldItem {

    /// 配置项
    var textFieldItemConfig: TextFieldItemConfig = TextFieldItemConfig()

    /// 单位提示文本
    var itemRightTitle: String? = nil

    public required init() {
        super.init()
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellConfigOf(FormTextFieldCellConfig.self) {
            initTextFieldItem($0.text)
            $0.rightTitle.text = itemRightTitle
        }
    }

    //MARK: 代理方法, 需要覆盖重写才会生效. 还需要重新设置delegate = self

    /// 文本内容改变后,保存值
    open func textFieldDidChangeSelection(_ textField: UITextField) {
        textFieldItemConfig.itemEditText = textField.text
        updateFormItemValue(textField.text)
    }

    /// 收起键盘
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /// 限制最大输入字符数
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let textLength = text.count + string.count - range.length
        return textLength <= textFieldItemConfig.itemEditMaxLength
    }
}

class FormTextFieldTableCell: DslTableCell {

    fileprivate let cellConfig: FormTextFieldCellConfig = FormTextFieldCellConfig()

    override func getCellConfig() -> IDslCellConfig? {
        cellConfig
    }
}

//MARK: cell 界面声明, 用于兼容UITableView和UICollectionView

class FormTextFieldCellConfig: BaseFormItemCellConfig {

    let wrap = horizontal()
    let text = textFieldView(borderStyle: .none)
    let rightTitle = subTitleView(size: Res.text.label.size) //右边提示的文本

    override func initCellContent() -> UIView {
        wrap.setPadding(Res.size.x)
        wrap.mWwH(minHeight: Res.size.itemMinHeight)
        wrap.setGravity(TGGravity.vert.center)
        //wrap.tg_gravity = [TGGravity.horz.center, TGGravity.vert.baseline]
        //wrap.backgroundColor = UIColor.red

        wrap.render(formLabel) {
            //$0.backgroundColor = UIColor.yellow
            $0.wrap_content(minWidth: self.labelMinWidth)
        }

        wrap.render(text) {
            //$0.backgroundColor = UIColor.green
            $0.mWwH(minHeight: Res.size.minHeight)
        }
        wrap.render(rightTitle) {
            $0.wrap_content()
        }

        return wrap
    }
}