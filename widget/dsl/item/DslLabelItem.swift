//
// Created by angcyo on 21/08/31.
//

import Foundation
import UIKit

/// 单行文本UILabel提示的item

class DslLabelTableItem: DslTableItem, ILabelItem {

    var labelItemConfig = LabelItemConfig()

    /// 边距
    var itemLabelInset: UIEdgeInsets? = insets(left: Res.size.x, top: Res.size.m, right: Res.size.x, bottom: Res.size.m)

    override func initItem() {
        super.initItem()
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellConfigOf(DslLabelCellConfig.self) {
            $0.label.remakeView {
                $0.makeEdge((cell as! UIView).cellContentView, inset: itemLabelInset)
            }
            initLabelItem($0.label)
        }
    }
}

class DslLabelTableCell: DslTableCell {

    fileprivate let cellConfig: DslLabelCellConfig = DslLabelCellConfig()

    override func getCellConfig() -> IDslCellConfig? {
        cellConfig
    }

}

//MARK: cell 界面声明, 用于兼容UITableView和UICollectionView

class DslLabelCellConfig: IDslCellConfig {

    let label = labelView()

    func getRootView(_ cell: UIView) -> UIView {
        cell.cellContentView
    }

    func initCellConfig(_ cell: UIView) {
        cell.cellContentView.render(label)
        with(label) {
            $0.makeEdge(cell.cellContentView)
        }
    }
}