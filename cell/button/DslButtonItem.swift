//
// Created by angcyo on 21/08/06.
//

import Foundation
import UIKit

class DslButtonItem: DslTableItem {

    override func initItem() {
        itemCell = DslButtonCell.self
        itemHeight = 45
        itemCanHighlight = false
        itemCanSelect = false
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)
        (cell as? UIView)?.backgroundColor = UIColor.clear
    }
}

class DslButtonCell: DslTableCell {

    let button = solidButton()

    override func initCell() {
        super.initCell()
        contentView.render(button) { view in
            view.makeFullWidth()
            view.makeFullHeight()
        }
    }
}