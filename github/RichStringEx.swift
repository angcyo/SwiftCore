//
// Created by angcyo on 21/08/11.
//

import Foundation
import SwiftRichString
import UIKit

/// https://github.com/malcommac/SwiftRichString

class RichStringBuilder {

    var _masterAttributedString: NSMutableAttributedString? = nil

    func append(_ string: String, _ styleBuilder: @escaping (Style) -> Void) {
        append(string, Style {
            styleBuilder($0)
        })
    }

    func append(_ string: String, _ style: StyleProtocol? = nil) {
        //_builder.add([string: style])
        if _masterAttributedString == nil {
            _masterAttributedString = NSMutableAttributedString()
        }

        if let style = style {
            _masterAttributedString?.append(string.set(style: style))
        } else {
            _masterAttributedString?.append(string.toNSAttributedString())
        }
    }

    func build() -> AttributedString? {
        return _masterAttributedString
    }
}

extension UILabel {
    func style(_ builder: (RichStringBuilder) -> Void) {
        styleLabel(self, builder)
    }
}

extension Style {

    /// 填充提示
    func fillTip(_ textColor: UIColor, fillColor: UIColor? = nil) {
        backColor = fillColor ?? textColor.toAlpha(0.3)
        color = textColor

        //lineSpacing //行间距
        //kerning = .adobe(<#T##CGFloat##CoreGraphics.CGFloat#>) //字间距
    }

    /// https://github.com/malcommac/SwiftRichString
    /// NSAttributedString.Key.link
    func link(_ url: URL) {
        linkURL = url
    }
}

func style(_ builder: (RichStringBuilder) -> Void) -> AttributedString? {
    let _builder = RichStringBuilder()
    builder(_builder)
    return _builder.build()
}

func styleLabel(_ label: UILabel, _ builder: (RichStringBuilder) -> Void) {
    let _builder = RichStringBuilder()
    builder(_builder)
    label.attributedText = _builder.build()

    //label.style
    //label.styledText
}