//
// Created by angcyo on 21/09/16.
//

import Foundation
import UIKit
import YPImagePicker

/// 简单的图片item

class DslImageCollectionItem: DslCollectionItem {

    var itemImage: AnyImage? = nil

    var itemContentMode: UIView.ContentMode = .scaleAspectFill

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellOf(DslImageCollectionCell.self) {
            $0.image.setImage(itemImage)
            $0.image.contentMode = itemContentMode
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

extension DslCollectionView {

    /// 获取所有图片
    func allItemImage() -> [AnyImage] {
        let itemList = getItemList(false)
        var result: [AnyImage] = []
        itemList.forEach {
            if let item = $0 as? DslImageCollectionItem {
                result.add(item.itemImage)
            }
        }
        return result
    }

}