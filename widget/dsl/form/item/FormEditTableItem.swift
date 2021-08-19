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
        initEditItem(cell.formEditCellConfig.text)

        cell.formEditCellConfig.formLine.visible(itemShowLine) //Line
        cell.formEditCellConfig.formLabel.text = itemLabel //Label
        cell.formEditCellConfig.formRequired.visible(formItemConfig.formRequired) //必填提示

        cell.formEditCellConfig.rightTitle.text = itemRightTitle
    }
}

class FormEditTableCell: DslTableCell, IFormEditCell {

    var formEditCellConfig = FormEditCellConfig()

    override func initCell() {
        super.initCell()

        formEditCellConfig.initCellConfig(self)
        renderToCell(self, formEditCellConfig.formRoot)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        formEditCellConfig.formRoot.sizeThatFits(CGSize(width: targetSize.width - safeAreaInsets.left - safeAreaInsets.right, height: targetSize.height))
    }
}

protocol IFormEditCell: IDslCell {

    /// var formEditCellConfig = FormEditCellConfig()
    var formEditCellConfig: FormEditCellConfig { get set }
}

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