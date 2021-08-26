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

    /// 相册选择后的图片
    var itemPickerImage: UIImage? = nil

    override func initItem() {
        super.initItem()

        /// 点击选择图片
        onItemClick = {
            pickerPhoto {
                self.itemPickerImage = $0.image
                self.updateFormItemValue($0.image.toData()?.toFormFile())
                self.itemUpdate = true
            }
        }
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        guard let cell = cell as? FormAvatarTableCell else {
            return
        }

        cell.cellConfig.avatar.setImage(itemPickerImage ?? itemAvatarUrl, name: itemUserName)
    }
}

class FormAvatarTableCell: DslTableCell {

    let cellConfig = FormAvatarCellConfig()

    override func getCellConfig() -> IDslCellConfig? {
        cellConfig
    }
}

//MARK: cell 界面声明, 用于兼容UITableView和UICollectionView

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
            $0.frameGravityRC(offsetY: 6, offsetRight: Res.size.x)
        }
        return wrap
    }
}