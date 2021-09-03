//
// Created by angcyo on 21/09/03.
//

import Foundation
import UIKit

/// 显示在UITableView底部的版本号item

class DslVersionTableItem: DslTableItem {

    var itemVersion: String? = nil

    override func initItem() {
        super.initItem()

        itemVersion = "当前版本: v\(Bundle.versionName())"
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellOf(DslVersionTableCell.self) {
            $0.text.text = itemVersion

            if let tableView = _dslRecyclerView as? UITableView {
                let cellMaxWidth = beforeCellMaxWidth()
                let cellHeight = $0.sizeOf(cgSize(cellMaxWidth, .max)).height
                if isLastItem() {
                    let beforeHeight = beforeCellHeight()
                    let height = tableView.bounds.height - beforeHeight
                    itemHeight = max(height, cellHeight)
                } else {
                    itemHeight = cellHeight
                }
            }
        }
    }
}

class DslVersionTableCell: DslTableCell {

    let text = labelView()

    override func initCell() {
        //super.initCell()

        backgroundColor = .clear
        contentView.render(text)

        text.lowStretch() //不拉伸
        with(text) {
            //$0.backgroundColor = .red
            $0.textAlignment = .center
            $0.makeBottomIn(offsetTop: Res.size.x, offsetBottom: Res.size.x)
            $0.makeCenterX()
        }
    }
}