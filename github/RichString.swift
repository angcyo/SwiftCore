//
// Created by angcyo on 21/08/11.
//

import Foundation
import SwiftRichString

/// https://github.com/malcommac/SwiftRichString

class RichStringBuilder {

    var _masterAttributedString: NSMutableAttributedString? = nil

    func append(_ string: String, _ style: StyleProtocol) {
        //_builder.add([string: style])
        if _masterAttributedString == nil {
            _masterAttributedString = NSMutableAttributedString()
        }
        _masterAttributedString?.append(string.set(style: style))
    }

    func build() -> AttributedString? {
        return _masterAttributedString
    }
}

func style(_ builder: (RichStringBuilder) -> Void) -> AttributedString? {
    let builder = RichStringBuilder()
    return builder.build()
}

func styleLabel(_ label: UILabel, _ builder: (RichStringBuilder) -> Void) {
    let builder = RichStringBuilder()
    label.attributedText = builder.build()

    //label.style
    //label.styledText
}