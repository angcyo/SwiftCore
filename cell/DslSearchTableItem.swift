//
// Created by angcyo on 21/09/03.
//

import Foundation
import UIKit

/// 不包含输入框的搜素框item

class DslSearchTableItem: DslTableItem {

    var itemSearchTip: String? = "请输入名称"

    override func initItem() {
        super.initItem()
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellOf(DslSearchTableCell.self) {
            $0.text.text = itemSearchTip
        }
    }

}

class DslSearchTableCell: DslTableCell {

    let bg = view()

    let icon = iconView(R.image.icon_search())

    let text = labelView()

    override func initCell() {
        //super.initCell()

        //backgroundColor = .clear
        contentView.render(bg)
        contentView.render(icon)
        contentView.render(text)

        bg.setBackground("#F4F6F9".toColor())
        bg.setRound(Res.size.roundCommon)
        with(bg) {
            $0.makeEdge(inset: insets(left: Res.size.leftMargin, top: Res.size.x, right: Res.size.leftMargin, bottom: Res.size.x))
            $0.makeHeight(Res.size.minHeight)
        }

        with(icon) {
            $0.makeRightToLeftOf(text, offset: Res.size.m)
            $0.makeCenterY(bg)
            $0.makeSize(size: 13)
        }

        //text.lowStretch() //不拉伸
        with(text) {
            //$0.backgroundColor = .red
            //$0.textAlignment = .center
            //$0.makeBottomIn(offsetTop: Res.size.x, offsetBottom: Res.size.x)
            $0.makeCenter(bg)
        }
    }
}