//
// Created by angcyo on 21/08/06.
//

import Foundation
import UIKit

/// 单独一个按钮的item
class DslButtonTableItem: DslTableItem {

    var itemButtonText: String? = "保存"

    override func initItem() {
        super.initItem()
        itemHeight = 45
        itemCanHighlight = false
        itemCanSelect = false

        itemHeaderEstimatedHeight = 50
        itemFooterEstimatedHeight = 50
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)
        (cell as? UIView)?.backgroundColor = UIColor.clear

        guard let cell = cell as? DslButtonTableCell else {
            return
        }
        bindItemGesture(cell.button)
        cell.button.setText(itemButtonText)
    }
}

class DslButtonTableCell: DslTableCell {

    let button = solidButton(titleSize: Res.text.normal.size)

    override func initCell() {
        super.initCell()

        button.bold()
        contentView.render(button) {
            $0.makeFullWidth()
            $0.makeFullHeight()
        }
    }
}