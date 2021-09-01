//
// Created by angcyo on 21/08/10.
//

import Foundation
import UIKit

protocol ITextViewItem: IDslItem, UITextViewDelegate {

    /// 配置项
    /// var textViewItemConfig = TextViewItemConfig()
    var textViewItemConfig: TextViewItemConfig { get set }

    /// 请主动实现部分代理方法
}

class TextViewItemConfig: TextFieldItemConfig {

    //super

    /// 最大行数
    var itemTextMaxLines = 0 //无限行

    /// 最大高度, 需要[GrowingTextView]支持, 无效的属性
    var itemTextMaxHeight: CGFloat = 0
}

extension ITextViewItem {

    /// 初始化
    func initTextViewItem(_ textView: UITextView) {
        textView.delegate = self
        textViewItemConfig.initTextInputTraits(textView, enable: enableItemEdit)

        // 私有属性
        textView.textContainer.maximumNumberOfLines = textViewItemConfig.itemTextMaxLines

        if let growingTextView = textView as? GrowingTextView {
            growingTextView.maxHeight = textViewItemConfig.itemTextMaxHeight
            growingTextView.maxLength = textViewItemConfig.itemEditMaxLength
        }
    }

}