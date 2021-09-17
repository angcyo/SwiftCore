//
// Created by angcyo on 21/09/16.
//

import Foundation
import UIKit
import YPImagePicker

/// 简单的图片item

class DslImageCollectionItem: DslCollectionItem, IImageItem {

    var imageItemConfig = ImageItemConfig()

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellOf(DslImageCollectionCell.self) {
            initImageItem($0.image)
        }
    }
}

class DslImageCollectionCell: DslCollectionCell {

    let image = scaleImageView()

    override func initCell() {
        contentView.render(image)
        //backgroundColor = .green

        with(image) {
            $0.makeEdge()
            $0.setRadius(Res.size.roundLittle)
        }
    }
}

extension DslRecycleView {

    /// 获取所有图片
    func allItemImage() -> [AnyImage] {
        let itemList = getItemList(false)
        var result: [AnyImage] = []
        itemList.forEach {
            if let item = $0 as? IImageItem {
                result.add(item.imageItemConfig.itemImage)
            }
        }
        return result
    }

}