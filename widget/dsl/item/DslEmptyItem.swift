//
// Created by angcyo on 21/08/31.
//

import Foundation
import UIKit

/// 空布局item, 用来占位高度

class DslEmptyTableItem: DslTableItem {

    var itemWidth: CGFloat = 0.01

    var itemBackgroundColor: UIColor = UIColor.clear

    override func initItem() {
        super.initItem()
        itemHeight = 0.01
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        let cellView = cell as! UIView
        cellView.backgroundColor = itemBackgroundColor

        cell.cellConfigOf(DslEmptyCellConfig.self) {
            $0.view.remakeView {
                $0.makeEdge(cellView.cellContentView)
                $0.makeWidthHeight(itemWidth, itemHeight)
            }
        }
    }
}

class DslEmptyTableCell: DslTableCell {

    fileprivate let cellConfig: DslEmptyCellConfig = DslEmptyCellConfig()

    override func getCellConfig() -> IDslCellConfig? {
        cellConfig
    }

}

//MARK: cell 界面声明, 用于兼容UITableView和UICollectionView

class DslEmptyCellConfig: IDslCellConfig {

    let view = UIView()

    func getRootView(_ cell: UIView) -> UIView {
        cell.cellContentView
    }

    func initCellConfig(_ cell: UIView) {
        cell.cellContentView.render(view)
    }
}