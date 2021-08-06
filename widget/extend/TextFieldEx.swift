//
// Created by wayto on 2021/7/29.
//

import Foundation
import UIKit

/// 文本框代理
class TextFieldDelegate: UIResponder, UITextFieldDelegate {

    var textFieldShouldReturnAction: ((UITextField) -> Bool)? = nil

    /// 返回true 执行默认行为 1:文本需要开始编辑
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("...textFieldShouldBeginEditing(_:)")
        return true
    }

    /// 2:文本开始编辑
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("...textFieldDidBeginEditing")
    }

    /// 返回true 执行默认行为 5:文本需要结束编辑
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("....textFieldShouldEndEditing(_:)")
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("...textFieldDidEndEditing")
    }

    /// 6:文本结束编辑
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("...textFieldDidBeginEditing")
    }

    /// 返回true 执行默认行为 3:文本内容编辑改变
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("...textField(_:shouldChangeCharactersIn:replacementString:)")
        return true
    }

    /// 4:文本内容已改变
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("...textFieldDidChangeSelection:\(textField.text ?? "nil")")
    }

    /// 返回true 执行默认行为 :点击了clear
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("...textFieldShouldClear(_:)")
        return true
    }

    /// 返回true 执行默认行为 :点击了return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("....textFieldShouldReturn")
        return textFieldShouldReturnAction?(textField) ?? true
    }
}

extension UITextField {

    /// 监听键盘上的return建
    /// 返回对象需要保存起来, 否则会被ARC回收, 导致回调不了
    /// - Parameters:
    ///   - returnKeyType:
    ///   - action:
    /// - Returns:
    func doReturnAction(_ returnKeyType: UIReturnKeyType? = nil, _ action: @escaping (UITextField) -> Bool) -> TextFieldDelegate {
        if let type = returnKeyType {
            self.returnKeyType = type
        }
        let result = TextFieldDelegate().apply { (this: TextFieldDelegate) in
            this.textFieldShouldReturnAction = action
        }
        delegate = result
        return result
    }
}

func textFieldView(_ placeholder: String? = "请输入...",
                   borderStyle: UITextField.BorderStyle = .roundedRect) -> UITextField {
    let view = UITextField()
    view.font = Res.font.normal
    view.textColor = Res.text.normal.color

    //边框样式
    //UITextBorderStyleNone, // 无边框
    //UITextBorderStyleLine, // 有黑色边框
    //UITextBorderStyleBezel, // 有灰色边框和阴影
    //UITextBorderStyleRoundedRect // 圆角
    view.borderStyle = borderStyle

    view.placeholder = placeholder
    //view.font
    //view.textColor
    view.tintColor = Res.color.colorAccent // 光标的颜色
    //view.setValue(UIColor.red, forKeyPath: .pla)
    //view.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.red]) //占位文本的颜色

    //删除按钮
    //UITextFieldViewModeNever, 重不出现
    //UITextFieldViewModeWhileEditing, 编辑时出现
    //UITextFieldViewModeUnlessEditing, 除了编辑外都出现
    //UITextFieldViewModeAlways 一直出现
    view.clearButtonMode = .whileEditing

    //是否安全输入, 密码框
    view.isSecureTextEntry = false
    //是否纠错
    view.autocorrectionType = .no
    //首字母大写
    view.autocapitalizationType = .none
    //文本对齐
    view.textAlignment = .left
    //自动字体大小
    view.adjustsFontSizeToFitWidth = false

    //UIKeyboardTypeDefault, 默认键盘，支持所有字符
    //UIKeyboardTypeASCIICapable, 支持ASCII的默认键盘
    //UIKeyboardTypeNumbersAndPunctuation, 标准电话键盘，支持＋＊＃字符
    //UIKeyboardTypeURL, URL键盘，支持.com按钮 只支持URL字符
    //UIKeyboardTypeNumberPad, 数字键盘
    //UIKeyboardTypePhonePad,电话键盘
    //UIKeyboardTypeNamePhonePad, 电话键盘，也支持输入人名
    //UIKeyboardTypeEmailAddress,用于输入电子 邮件地址的键盘
    //UIKeyboardTypeDecimalPad,数字键盘 有数字和小数点
    //UIKeyboardTypeTwitter, 优化的键盘，方便输入@、#字符
    //UIKeyboardTypeAlphabet = UIKeyboardTypeASCIICapable,
    view.keyboardType = .default

    //UIReturnKeyDefault, 默认 灰色按钮，标有Return
    //UIReturnKeyGo, 标有Go的蓝色按钮
    //UIReturnKeyGoogle,标有Google的蓝色按钮，用语搜索
    //UIReturnKeyJoin,标有Join的蓝色按钮
    //UIReturnKeyNext,标有Next的蓝色按钮
    //UIReturnKeyRoute,标有Route的蓝色按钮
    //UIReturnKeySearch,标有Search的蓝色按钮
    //UIReturnKeySend,标有Send的蓝色按钮
    //UIReturnKeyYahoo,标有Yahoo的蓝色按钮
    //UIReturnKeyYahoo,标有Yahoo的蓝色按钮
    //UIReturnKeyEmergencyCall, 紧急呼叫按钮
    view.returnKeyType = .done

    //view.rightView

    //view.becomeFirstResponder()

    return view
}

func secureTextField(_ placeholder: String? = "请输入密码...",
                     borderStyle: UITextField.BorderStyle = .roundedRect) -> UITextField {
    let view = textFieldView(placeholder, borderStyle: borderStyle)
    view.isSecureTextEntry = true
    return view
}