//
// Created by angcyo on 21/08/10.
//

import Foundation
import UIKit

protocol IEditItem: IDslItem, UITextFieldDelegate {

    /// 配置项
    var editItemConfig: EditItemConfig { get set }
}

class EditItemConfig {

    /// 输入框的文本
    var itemEditText: String? = nil

    /// 占位字符
    var itemEditPlaceholder: String? = "请输入..."

    ///是否可编辑
    var itemEditEnable: Bool = true
}

extension IEditItem {

    /// 初始化
    func initEditItem(_ textField: UITextField) {
        textField.delegate = self
        textField.text = editItemConfig.itemEditText
        textField.isEnabled = editItemConfig.itemEditEnable
        //textField.setEdit = editItemConfig.itemEditEnable
        textField.placeholder = editItemConfig.itemEditPlaceholder
    }

}