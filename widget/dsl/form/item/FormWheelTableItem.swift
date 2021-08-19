//
// Created by angcyo on 21/08/18.
//

import Foundation
import UIKit
import TangramKit

/// wheel 滚动选择item
class FormWheelTableItem: BaseFormTableItem {

    var itemWheelValue: String? = nil

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        guard let cell = cell as? FormWheelTableCell else {
            return
        }

        cell.formWheelCellConfig.formLine.visible(itemShowLine) //Line
        cell.formWheelCellConfig.formLabel.text = itemLabel //Label
        cell.formWheelCellConfig.formRequired.visible(formItemConfig.formRequired) //必填提示

        cell.formWheelCellConfig.text.text = itemWheelValue
    }
}

class FormWheelTableCell: DslTableCell, IFormWheelCell {

    var formWheelCellConfig = FormWheelCellConfig()

    override func initCell() {
        super.initCell()

        formWheelCellConfig.initCellConfig(self)
        renderToCell(self, formWheelCellConfig.formRoot)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        formWheelCellConfig.formRoot.sizeThatFits(CGSize(width: targetSize.width - safeAreaInsets.left - safeAreaInsets.right, height: targetSize.height))
    }
}

protocol IFormWheelCell: IDslCell {
    var formWheelCellConfig: FormWheelCellConfig { get set }
}

class FormWheelCellConfig: BaseFormItemCellConfig {

    let wrap = horizontal()
    let text = textFieldView(borderStyle: .none)

    override func initCellContent() -> UIView {
        wrap.setPadding(Res.size.x)
        wrap.mWwH(minHeight: Res.size.itemMinHeight)
        wrap.setGravity(TGGravity.vert.center)

        wrap.render(formLabel) {
            $0.wrap_content(minWidth: self.labelMinWidth)
        }

        text.placeholder = "请选择"
        text.textColor = Res.text.label.color
        text.isUserInteractionEnabled = false
        text.isEnabled = false
        wrap.render(text) {
            $0.mWwH(minHeight: Res.size.minHeight)
        }
        wrap.render(formArrow)
        return wrap
    }
}