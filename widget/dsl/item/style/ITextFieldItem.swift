//
// Created by angcyo on 21/08/10.
//

import Foundation
import UIKit

protocol ITextFieldItem: IDslItem, UITextFieldDelegate {

    /// 配置项
    /// var textFieldItemConfig = TextFieldItemConfig()
    var textFieldItemConfig: TextFieldItemConfig { get set }

    /// 请主动实现部分代理方法
}

class TextFieldItemConfig {

    /// 输入框的文本
    var itemEditText: String? = nil

    /// 占位字符
    var itemEditPlaceholder: String? = "请输入..."

    ///是否可编辑, 默认使用表单item配置项
    var itemEditEnable: Bool? = nil

    /// 键盘类型
    var itemEditKeyboardType: UIKeyboardType = .default

    var itemEditReturnType: UIReturnKeyType = .done

    /// 限制最大输入字符数
    var itemEditMaxLength: Int = Int.max

    /// 是否是密码输入框
    var itemSecureTextEntry = false
}

extension ITextFieldItem {

    /// 初始化
    func initTextFieldItem(_ textField: UITextField) {
        textField.delegate = self
        textFieldItemConfig.initTextInputTraits(textField, enable: enableItemEdit)
    }
}

extension TextFieldItemConfig {

    /// 初始化输入特性
    func initTextInputTraits(_ input: UIView, enable: Bool) {
        if let input = input as? UITextField {
            input.isSecureTextEntry = itemSecureTextEntry
            input.keyboardType = itemEditKeyboardType
            input.returnKeyType = itemEditReturnType

            input.text = itemEditText
            input.isEnabled = enable
            //激活状态下, 才设置占位字符
            if input.isEnabled {
                input.placeholder = itemEditPlaceholder
            } else {
                input.placeholder = nil
            }

        } else if let input = input as? UITextView {
            input.isSecureTextEntry = itemSecureTextEntry
            input.keyboardType = itemEditKeyboardType
            input.returnKeyType = itemEditReturnType

            input.text = itemEditText
            input.isEditable = enable

            // 未激活时, 禁止滚动
            input.alwaysBounceVertical = enable
            input.alwaysBounceHorizontal = enable
            input.isScrollEnabled = enable

            //激活状态下, 才设置占位字符
            if let growingTextView = input as? GrowingTextView {
                if input.isEditable {
                    growingTextView.placeholder = itemEditPlaceholder
                } else {
                    growingTextView.placeholder = nil
                }
            } else if let kmPlaceholderTextView = input as? KMPlaceholderTextView {
                if input.isEditable {
                    kmPlaceholderTextView.placeholder = itemEditPlaceholder
                } else {
                    kmPlaceholderTextView.placeholder = nil
                }
            }

        }
    }
}