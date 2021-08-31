//
// Created by angcyo on 21/08/31.
//

import Foundation
import UIKit

protocol ILabelItem: IDslItem {

    /// 配置项
    /// var labelItemConfig = LabelItemConfig()
    var labelItemConfig: LabelItemConfig { get set }
}

extension ILabelItem {
    func initLabelItem(_ label: UILabel) {
        label.numberOfLines = labelItemConfig.itemLabelLines
        label.textColor = labelItemConfig.itemLabelColor
        label.textAlignment = labelItemConfig.itemLabelTextAlignment
        label.text = labelItemConfig.itemLabelText
    }
}

class LabelItemConfig {

    var itemLabelText: String? = nil

    var itemLabelColor: UIColor = Res.text.label.color

    var itemLabelLines: Int = 0 //任意行

    var itemLabelTextAlignment: NSTextAlignment = .left //文本对齐

}