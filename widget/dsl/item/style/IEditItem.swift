//
// Created by angcyo on 21/08/10.
//

import Foundation
import UIKit

protocol IEditItem: IDslItem, UITextFieldDelegate {

    /// 配置项
    /// var editItemConfig: EditItemConfig = EditItemConfig()
    var editItemConfig: EditItemConfig { get set }

    /// 请实现以下方法
//    /// 文本内容改变后,保存值
//    open func textFieldDidChangeSelection(_ textField: UITextField) {
//        editItemConfig.itemEditText = textField.text
//        updateFormItemValue(textField.text)
//    }
//
//    /// 收起键盘
//    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    /// 限制最大输入字符数
//    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text else {
//            return true
//        }
//        let textLength = text.count + string.count - range.length
//        return textLength <= editItemConfig.itemEditMaxLength
//    }
}

class EditItemConfig {

    /// 输入框的文本
    var itemEditText: String? = nil

    /// 占位字符
    var itemEditPlaceholder: String? = "请输入..."

    ///是否可编辑, 默认使用表单item配置项
    var itemEditEnable: Bool? = nil

    /// 键盘类型
    var itemEditKeyboardType: UIKeyboardType = .default

    /// 限制最大输入字符数
    var itemEditMaxLength: Int = Int.max

    /// 是否是密码输入框
    var itemSecureTextEntry = false
}

extension IEditItem {

    /// 初始化
    func initEditItem(_ textField: UITextField) {
        textField.delegate = self
        textField.isSecureTextEntry = editItemConfig.itemSecureTextEntry
        textField.text = editItemConfig.itemEditText
        textField.isEnabled = editItemConfig.itemEditEnable ?? true
        //激活状态下, 才设置占位字符
        if textField.isEnabled {
            textField.placeholder = editItemConfig.itemEditPlaceholder
        } else {
            textField.placeholder = nil
        }
        textField.keyboardType = editItemConfig.itemEditKeyboardType
    }

}