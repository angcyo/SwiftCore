//
// Created by angcyo on 21/09/16.
//

import Foundation
import UIKit
import TangramKit

/// 媒体选择表单,视频/图片 多选, YPImagePicker
class FormPickerMediaTableItem: BaseFormTableItem, IPickerItem {

    var pickerItemConfig = PickerItemConfig()

    let _maxSectionInterceptor = SectionMaxInterceptor()

    override func initItem() {
        super.initItem()

        let addItem = DslImageCollectionItem()
        addItem.itemImage = R.image.img_add()
        addItem.itemContentMode = .scaleAspectFit
        addItem.onItemClick = {
            self.pickerMedia { items, cancelled in
                //no op
            }
        }
        _maxSectionInterceptor.appendItems.add(addItem)

        pickerItemConfig.itemMaxNumberOfItems = 9

        /// 点击选择图片
        /*onItemClick = {
            pickerPhoto {
                self.pickerItemConfig.itemPickerImage = $0.image
                self.updateFormItemValue($0.image.toData()?.toFormFile())
                self.itemUpdate = true
            }
        }*/
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        _maxSectionInterceptor.maxCount = pickerItemConfig.itemMaxNumberOfItems

        cell.cellOf(FormPickerMediaTableCell.self) {
            let cell = $0
            $0.grid.defaultItemProvide.updateItemList(DslImageCollectionItem.self, data: pickerItemConfig.itemPreselectedList) {
                let item = $0
                $0.itemImage = $0.itemData
                $0.onItemClick = {
                    lantern(cell.grid.allItemImage(), index: item.itemIndex?.row ?? 0)
                }
            }
            $0.grid.sectionHelper.addInterceptor(_maxSectionInterceptor)

            let grid = $0.grid
            $0.grid.sectionHelper.observerUpdateOnce {
                let frame = grid.frame
                let size = grid.collectionContentSize
                if size.isSizeChange(rect: frame) {
                    cell.setGridViewHeight(size.height)
                    self.itemUpdate = true
                }
            }
        }
    }
}

class FormPickerMediaTableCell: BaseFormTableCell {

    let grid = DslCollectionView(spanCount: 4, heightEqualToWidth: true)

    override func initFormCell() {
        super.initFormCell()

        renderCell(grid) {
            $0.isScrollEnabled = false
            self.setGridViewHeight(-1)
        }
    }

    func setGridViewHeight(_ height: CGFloat) {
        grid.remakeView {
            $0.makeGravityLeft(offset: Res.size.x)
            $0.makeGravityRight(offset: Res.size.x)
            $0.makeGravityBottom(offset: Res.size.x, priority: .medium)
            $0.makeTopToBottomOf(formLabel, offset: Res.size.x)

            if height > 0 {
                $0.makeHeight(height)
            } else {
                $0.makeHeight(Res.size.itemMinHeight, priority: .low)
            }
        }
    }
}