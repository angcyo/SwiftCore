//
// Created by angcyo on 21/08/17.
//

import Foundation
import UIKit
import TangramKit

/// 横线item, 支持padding
class DslLineItem: DslItem {

    var itemPaddingLeft = Res.size.leftMargin
    var itemPaddingRight = Res.size.leftMargin
    var itemPaddingTop = Res.size.x
    var itemPaddingBottom = Res.size.x

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        guard let cell = cell as? DslLineCell else {
            return
        }

        cell.root.setPadding(left: itemPaddingLeft, top: itemPaddingTop, right: itemPaddingRight, bottom: itemPaddingBottom)
    }
}

class DslLineCell: DslTableCell, IFrameCell {

    let root = frameLayout()
    let line = lineView()

    override func initCell() {
        super.initCell()

        root.mWwH()
        root.render(line) {
            $0.mWwH(height: Res.size.line)
        }

        renderCell(root)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        root.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
}