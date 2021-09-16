//
// Created by angcyo on 21/08/26.
//

import Foundation
import UIKit
import YPImagePicker

/// YPImagePicker
protocol IPickerItem: IDslItem {

    var pickerItemConfig: PickerItemConfig { get set }
}

class PickerItemConfig {

    //MARK: 公共配置

    /// 最大选中数量, >1开启多选
    var itemMaxNumberOfItems: Int = 1

    /// 媒体选择配置
    var onConfigImagePicker: ((inout YPImagePickerConfiguration) -> Void)? = nil

    //MARK: 单选配置

    /// 相册选择后的图片
    var itemPickerImage: UIImage? = nil

    //MARK: 多选配置

    /// 预先选中的item
    var itemPreselectedList: [YPMediaItem] = []
}

extension IPickerItem where Self: DslItem {

    /// 开始选择媒体
    func pickerMedia(_ action: @escaping (_ items: [YPMediaItem], _ cancelled: Bool) -> Void) {
        /// 点击选择图片
        picker({ [self] in
            $0.library.maxNumberOfItems = pickerItemConfig.itemMaxNumberOfItems
            $0.library.preselectedItems = pickerItemConfig.itemPreselectedList

            pickerItemConfig.onConfigImagePicker?(&$0)
        }) { [self] items, cancelled in
            if !cancelled {
                if pickerItemConfig.itemMaxNumberOfItems == 1 {
                    let image = items.singlePhoto?.image
                    pickerItemConfig.itemPickerImage = items.singlePhoto?.image
                    if let formItem = self as? BaseFormTableItem, image != nil {
                        formItem.updateFormItemValue(image?.toData()?.toFormFile())
                    }
                }

                pickerItemConfig.itemPreselectedList = items

                self.itemUpdate = true
            }

            action(items, cancelled)
        }
    }
}