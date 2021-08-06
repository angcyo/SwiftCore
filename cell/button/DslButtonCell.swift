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
}

extension DslItem {
    static var buttonCell: DslItem {
        let item = DslItem(DslButtonCell.self)
        item.itemHeight = 45
        item.itemCanHighlight = false
        item.itemCanSelect = false
        return item
    }
}