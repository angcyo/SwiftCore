//
// Created by angcyo on 21/08/13.
// https://github.com/levantAJ/PaddingLabel

//
//  PaddingLabel.swift
//  PaddingLabel
//
//  Created by levantAJ on 11/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

@IBDesignable open class PaddingLabel: UILabel {

    @IBInspectable open var topInset: CGFloat = 5.0
    @IBInspectable open var bottomInset: CGFloat = 5.0
    @IBInspectable open var leftInset: CGFloat = 7.0
    @IBInspectable open var rightInset: CGFloat = 7.0

    var insets: UIEdgeInsets {
        UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }

    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                height: size.height + topInset + bottomInset)
    }

    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let b = bounds
        let tr = b.inset(by: insets)
        return super.textRect(forBounds: tr, limitedToNumberOfLines: numberOfLines)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + leftInset + rightInset
        let height = superSizeThatFits.height + topInset + bottomInset
        return CGSize(width: width, height: height)
    }

    open override var bounds: CGRect {
        didSet {
            // Supported Multiple Lines in Stack views
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
