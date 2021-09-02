//
//  TextViewEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/28.
//

import Foundation
import UIKit

extension UITextView {

    func configBase() {

        //是否安全输入, 密码框
        isSecureTextEntry = false
        //是否纠错
        autocorrectionType = .no
        //首字母大写
        autocapitalizationType = .none
        //文本对齐
        textAlignment = .left
        //自动字体大小
        tintColor = Res.color.colorAccent // 光标的颜色

        isEditable = true
        textColor = Res.text.normal.color
        font = Res.font.normal
        returnKeyType = .default
        textContainer.maximumNumberOfLines = 0 //最大行数
        textContainer.lineBreakMode = .byWordWrapping //最后一行行为


        //https://www.jianshu.com/p/32a4747a19fb
        textContainerInset = insets(left: 0, top: Res.size.textInset, right: 0, bottom: Res.size.textInset) //系统默认8
        //contentInset = insets(left: 0, top: 8, right: 0, bottom: 8)
        //textContainer.lineFragmentPadding = 0
    }
}

/// 系统默认的多行输入控件
func tv() -> UITextView {
    let view = UITextView()
    view.configBase()
    return view
}

/// 自适应高度, 并且支持占位字符
func growTextView() -> UITextView {
    let view = GrowingTextView()
    view.configBase()

    view.placeholder = nil
    view.placeholderColor = Res.text.label.color

    return view
}

/// 自适应高度, 并且支持占位字符
func placeholderTextView() -> KMPlaceholderTextView {
    let view = KMPlaceholderTextView()
    view.configBase()

    view.placeholder = nil
    view.placeholderColor = Res.text.label.color

    return view
}
