//
// Created by angcyo on 21/08/06.
//

import Foundation
import UIKit

/// 左右各一个按钮的item
class DslButton2TableItem: DslTableItem {

    var itemLeftButtonText: String? = "删除"

    var itemRightButtonText: String? = "保存"

    var onLeftButtonClick: (() -> Void)? = nil
    var onRightButtonClick: (() -> Void)? = nil

    override func initItem() {
        super.initItem()
        itemHeight = 45
        itemCanHighlight = false
        itemCanSelect = false

        itemHeaderEstimatedHeight = 50
        itemFooterEstimatedHeight = 50
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)
        (cell as? UIView)?.backgroundColor = UIColor.clear

        guard let cell = cell as? DslButton2TableCell else {
            return
        }

        cell.leftButton.setText(itemLeftButtonText)
        cell.rightButton.setText(itemRightButtonText)

        cell.leftButton.onClick(bag: gestureDisposeBag) { _ in
            self.onLeftButtonClick?()
        }
        cell.rightButton.onClick(bag: gestureDisposeBag) { _ in
            self.onRightButtonClick?()
        }
    }
}

class DslButton2TableCell: DslTableCell {

    let wrap = hStackView(distribution: .fillEqually, spacing: Res.size.x)
    let leftButton = borderButton(titleColor: Res.color.error, bgColor: UIColor.clear, titleSize: Res.text.normal.size)
    let rightButton = solidButton(titleSize: Res.text.normal.size)

    override func initCell() {
        super.initCell()

        rightButton.bold()
        rightButton.addGradient()

        wrap.render(leftButton) {
            $0.makeFullHeight()
        }
        wrap.render(rightButton) {
            $0.makeFullHeight()
        }

        contentView.render(wrap) {
            $0.makeFullWidth()
            $0.makeFullHeight()
        }
    }
}