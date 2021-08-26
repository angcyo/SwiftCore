//
// Created by angcyo on 21/08/19.
//

import Foundation
import UIKit
import TangramKit

/// 媒体选择表单, YPImagePicker
class FormPickerTableItem: BaseFormTableItem, IPickerItem {

    var pickerItemConfig = PickerItemConfig()

    /// 默认的图片
    var itemImage: UIImage? = nil

    override func initItem() {
        super.initItem()

        /// 点击选择图片
        onItemClick = {
            pickerPhoto {
                self.pickerItemConfig.itemPickerImage = $0.image
                self.updateFormItemValue($0.image.toData()?.toFormFile())
                self.itemUpdate = true
            }
        }
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        guard let cell = cell as? FormPickerTableCell else {
            return
        }

        cell.cellConfig.formLabel.text = itemLabel
        let image = pickerItemConfig.itemPickerImage ?? itemImage ?? R.image.img_add()
        cell.cellConfig.image.setImage(image)
    }
}

class FormPickerTableCell: DslTableCell {

    let cellConfig = FormPickerCellConfig()

    override func getCellConfig() -> IDslCellConfig? {
        cellConfig
    }
}

//MARK: cell 界面声明, 用于兼容UITableView和UICollectionView

class FormPickerCellConfig: BaseFormItemCellConfig {

    let wrap = horizontal()
    let image = imageView(size: 68)

    override func initCellContent() -> UIView {
        wrap.setPadding(Res.size.x)
        wrap.mWwH(minHeight: Res.size.itemMinHeight)
        wrap.setGravity(TGGravity.vert.center)

        wrap.render(image)

        wrap.render(formLabel) {
            $0.setTextColor(Res.text.label.color)
            $0.setMargin(left: Res.size.x)
            $0.wrap_content(minWidth: self.labelMinWidth)
        }

        return wrap
    }
}