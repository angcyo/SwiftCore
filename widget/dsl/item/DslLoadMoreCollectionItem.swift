//
// Created by angcyo on 21/09/14.
//

import Foundation

/// 情感图切换item

class DslLoadMoreCollectionItem: BaseStatusTableItem {

    override func initItem() {
        super.initItem()
        itemHeight = 30
    }
}

class DslLoadMoreCollectionCell: BaseStatusCollectionCell {

    override func getCellConfig() -> IDslCellConfig? {
        cellConfig.indicatorSize = 20
        return cellConfig
    }
}