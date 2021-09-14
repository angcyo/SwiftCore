//
// Created by angcyo on 21/09/04.
//

import Foundation

/// 加载更多item

class DslLoadMoreTableItem: BaseStatusTableItem {

    override func initItem() {
        super.initItem()
        itemFooterEstimatedHeight = 0.001
        itemHeaderEstimatedHeight = 0.001
    }
}

class DslLoadMoreTableCell: BaseStatusTableCell {

    override func getCellConfig() -> IDslCellConfig? {
        cellConfig.indicatorSize = 20
        return cellConfig
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        if let _ = findAttachedTableView() {
            return cgSize(targetSize.width, 30)
        } else {
            return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        }
    }
}