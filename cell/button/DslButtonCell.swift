//
// Created by angcyo on 21/08/06.
//

import Foundation
import UIKit

class DslButtonCell: DslTableCell {

    let button = solidButton()

    override func initCell() {
        super.initCell()
        contentView.render(button) { view in
            view.makeFullWidth()
            view.makeFullHeight()
        }
    }

    override func onBindTableCell(_ tableView: DslTableView, _ indexPath: IndexPath, _ item: DslItem) {
        backgroundColor = UIColor.clear
        super.onBindTableCell(tableView, indexPath, item)
    }
}

extension DslItem {
    static var buttonCell: DslTableItem {
        let item = DslTableItem(DslButtonCell.self)
        item.itemHeight = 45
        item.itemCanHighlight = false
        item.itemCanSelect = false
        return item
    }
}