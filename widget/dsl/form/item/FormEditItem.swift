//
// Created by angcyo on 21/08/18.
//

import Foundation
import UIKit
import TangramKit

/// 简单的编辑item
class FormEditItem: DslTableItem, IEditItem, IFormItem {

    var editItemConfig: EditItemConfig = EditItemConfig()

    var formItemConfig: FormItemConfig = FormItemConfig()

    var itemLabel: String? = nil

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        guard let cell = cell as? FormEditCell else {
            return
        }

        initEditItem(cell.formEditCellConfig.text)
        cell.formEditCellConfig.label.text = itemLabel
    }
}

class FormEditCell: DslTableCell, IFormEditCell {

    var formEditCellConfig = FormEditCellConfig()

    override func initCell() {
        super.initCell()

        formEditCellConfig.initCellConfig(self)
        renderToCell(self, formEditCellConfig.root)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        formEditCellConfig.root.sizeThatFits(CGSize(width: targetSize.width - safeAreaInsets.left - safeAreaInsets.right, height: targetSize.height))
    }
}