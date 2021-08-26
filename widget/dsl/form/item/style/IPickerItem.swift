//
// Created by angcyo on 21/08/26.
//

import Foundation
import UIKit

/// YPImagePicker
protocol IPickerItem: IDslItem {

    var pickerItemConfig: PickerItemConfig { get set }
}

class PickerItemConfig {

    /// 相册选择后的图片
    var itemPickerImage: UIImage? = nil

}