//
// Created by angcyo on 21/09/08.
//

import Foundation
import UIKit

/// 简单的网格item, 上图片 下文本

class DslGridCollectionItem: DslCollectionItem {

    var itemImage: AnyImage? = nil

    var itemText: String? = nil

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellOf(DslGridCollectionCell.self) {
            $0.image.setImage(itemImage)
            $0.text.setText(itemText)
        }
    }
}

class DslGridCollectionCell: DslCollectionCell {

    let image = scaleImageView()

    let text = subTitleView(size: Res.text.des.size)

    override func initCell() {
        contentView.render(image)
        contentView.render(text)

        //backgroundColor = .green

        with(image) {
            $0.makeGravityLeft()
            $0.makeGravityRight()
            $0.makeGravityTop(offset: Res.size.x)
            $0.makeWidthHeight(size: 52)
        }

        with(text) {
            //$0.backgroundColor = .red
            $0.makeGravityLeft(offset: Res.size.x)
            $0.makeGravityRight(offset: Res.size.x)
            $0.makeGravityBottom(offset: Res.size.m)
            $0.makeTopToBottomOf(image, offset: Res.size.m)
            //$0.makeHeight(20)
            $0.textAlignment = .center
            //$0.sizeToFit()
        }
    }
}
