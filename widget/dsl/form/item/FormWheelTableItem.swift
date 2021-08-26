//
// Created by angcyo on 21/08/18.
//

import Foundation
import UIKit
import TangramKit

/// wheel 滚动选择item
class FormWheelTableItem: BaseFormTableItem {

    var itemWheelValue: String? = nil

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        guard let cell = cell as? FormWheelTableCell else {
            return
        }

        cell.cellConfig.text.text = itemWheelValue
    }
}

class FormWheelTableCell: DslTableCell {

    let cellConfig = FormWheelCellConfig()

    override func getCellConfig() -> IDslCellConfig? {
        cellConfig
    }
}

//MARK: cell 界面声明, 用于兼容UITableView和UICollectionView

class FormWheelCellConfig: BaseFormItemCellConfig {

    let wrap = horizontal()
    let text = textFieldView(borderStyle: .none)

    override func initCellContent() -> UIView {
        wrap.setPadding(Res.size.x)
        wrap.mWwH(minHeight: Res.size.itemMinHeight)
        wrap.setGravity(TGGravity.vert.center)

        wrap.render(formLabel) {
            $0.wrap_content(minWidth: self.labelMinWidth)
        }

        text.placeholder = "请选择..."
        //text.textColor = Res.text.label.color
        text.isUserInteractionEnabled = false
        text.isEnabled = false
        wrap.render(text) {
            $0.mWwH(minHeight: Res.size.minHeight)
        }
        wrap.render(formArrow)
        return wrap
    }
}