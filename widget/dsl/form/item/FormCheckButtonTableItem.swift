//
// Created by angcyo on 21/09/16.
//

import Foundation
import UIKit

/// 单选 check button 切换item
class FormCheckButtonTableItem: BaseFormTableItem {

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellOf(FormCheckButtonTableCell.self) {
            $0.checkGroup.resetSubView(BorderedButton.self, count: 3) { button, index in
                //button.backgroundColor = .green
                button.setText("Index \(index)")
            }
            $0.checkGroup.selectIndex = 0
        }
    }
}

class FormCheckButtonTableCell: BaseFormTableCell {

    let checkGroup = CheckGroupView()

    override func initFormCell() {
        super.initFormCell()

        renderCell(formLabel) {
            self.setLabelMinWidth()
            $0.makeGravityLeft(offset: Res.size.x)
            $0.makeGravityTop(offset: Res.size.x)
        }
        renderCell(formRequired) {
            $0.makeGravityLeft(offset: self.requiredOffsetLeft)
            $0.makeCenterY(self.formLabel)
        }
        renderCell(formLine) {
            $0.makeGravityLeft(offset: Res.size.x)
            $0.makeGravityRight(offset: Res.size.x)
            $0.makeGravityBottom()
            $0.makeHeight(Res.size.line)
        }
        renderCell(checkGroup) {
            //$0.backgroundColor = .red
            $0.makeGravityLeft(offset: Res.size.x)
            $0.makeGravityRight(offset: Res.size.x)
            $0.makeGravityBottom(offset: Res.size.x)
            $0.makeTopToBottomOf(self.formLabel, offset: Res.size.x)
        }
    }
}