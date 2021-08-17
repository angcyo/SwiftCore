//
// Created by angcyo on 21/08/17.
//

import Foundation
import UIKit
import TangramKit

/// 横线item, 支持padding
class LineItem: DslItem {

    var itemPaddingLeft = Res.size.leftMargin
    var itemPaddingRight = Res.size.leftMargin
    var itemPaddingTop = Res.size.x
    var itemPaddingBottom = Res.size.x

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        guard let cell = cell as? LineCell else {
            return
        }

        cell.frameLayout.setPadding(left: itemPaddingLeft, top: itemPaddingTop, right: itemPaddingRight, bottom: itemPaddingBottom)
    }
}

class LineCell: DslTableCell, IFrameCell {

    var frameLayout: TGFrameLayout = TGFrameLayout()

    var line = lineView()

    override func initCell() {
        super.initCell()

        frameLayout.mWwH()
        frameLayout.render(line) {
            $0.mWwH(height: Res.size.line)
        }

        renderCell(frameLayout)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        frameLayout.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
}