//
// Created by angcyo on 21/08/19.
//

import Foundation
import UIKit
import TangramKit

/// 头像编辑item
class FormAvatarTableItem: BaseFormTableItem {

    /// 头像的url
    var itemAvatarUrl: String? = nil
    var itemUserName: String? = nil

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        guard let cell = cell as? FormAvatarTableCell else {
            return
        }

        cell.formAvatarCellConfig.formLabel.text = itemLabel
        cell.formAvatarCellConfig.avatar.setAvatarUrl(itemAvatarUrl, name: itemUserName ?? "")
    }
}

class FormAvatarTableCell: DslTableCell, IFormAvatarCell {

    var formAvatarCellConfig = FormAvatarCellConfig()

    override func initCell() {
        super.initCell()

        formAvatarCellConfig.initCellConfig(self)
        renderToCell(self, formAvatarCellConfig.formRoot)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        formAvatarCellConfig.formRoot.sizeThatFits(CGSize(width: targetSize.width - safeAreaInsets.left - safeAreaInsets.right, height: targetSize.height))
    }
}

protocol IFormAvatarCell: IDslCell {
    var formAvatarCellConfig: FormAvatarCellConfig { get set }
}

class FormAvatarCellConfig: BaseFormItemCellConfig {

    let wrap = horizontal()
    let avatar = avatarView(size: 44)

    override func initCellContent() -> UIView {
        wrap.setPadding(Res.size.x)
        wrap.mWwH(minHeight: Res.size.itemMinHeight)
        wrap.setGravity(TGGravity.vert.center)

        wrap.render(formLabel) {
            $0.wrap_content(minWidth: self.labelMinWidth)
        }

        wrap.render(avatar)

        formRoot.render(formArrow) {
            $0.contentMode = .scaleAspectFit
            $0.wh(width: 16, height: 16)
            $0.frameGravityRC(offsetY: 6, offsetRight: Res.size.x)
        }
        return wrap
    }
}