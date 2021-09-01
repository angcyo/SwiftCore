//
// Created by angcyo on 21/08/10.
//

import Foundation

/// 扩展item时的基协议, 方便继承查找
protocol IDslItem {

}

extension IDslItem {

    /// item是否可以被编辑
    var enableItemEdit: Bool {
        get {
            var enable = true

            if let formItem = self as? IFormItem {
                enable = formItem.formItemConfig.formCanEdit
            }

            if let textFieldItem = self as? ITextFieldItem {
                if let _enable = textFieldItem.textFieldItemConfig.itemEditEnable {
                    enable = _enable
                }
            }

            if let textViewItem = self as? ITextViewItem {
                if let _enable = textViewItem.textViewItemConfig.itemEditEnable {
                    enable = _enable
                }
            }

            return enable
        }
    }

}