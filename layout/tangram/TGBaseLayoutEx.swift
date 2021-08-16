//
// Created by angcyo on 21/08/13.
//

import Foundation
import TangramKit

extension UIView {

    func wrap_content() {
        tg_width.equal(.wrap)
        tg_height.equal(.wrap)
    }

    func match_parent() {
        tg_width.equal(.fill)
        tg_height.equal(.fill)
    }

    func wh(width: Float? = nil, height: Float? = nil) {
        if let width = width {
            tg_width.equal(width.toCGFloat())
        } else {
            tg_width.equal(.wrap)
        }
        if let height = height {
            tg_height.equal(height.toCGFloat())
        } else {
            tg_height.equal(.wrap)
        }
    }

    func mWwH(height: Float? = nil, minHeight: Float? = nil) {
        tg_width.equal(.fill)

        if let height = height {
            tg_height.equal(height.toCGFloat())
        } else {
            tg_height.equal(.wrap)
        }

        if let min = minHeight {
            tg_height.min(min.toCGFloat())
        }
    }

    func wWmH(width: Float? = nil, minWidth: Float? = nil) {
        tg_height.equal(.fill)

        if let width = width {
            tg_width.equal(width.toCGFloat())
        } else {
            tg_width.equal(.wrap)
        }

        if let min = minWidth {
            tg_width.min(min.toCGFloat())
        }
    }
}

extension TGBaseLayout {

    func setPadding(_ padding: Float) {
        setPadding(left: padding, top: padding, right: padding, bottom: padding)
    }

    func setPaddingHorizontal(_ padding: Float) {
        setPadding(left: padding, top: tg_topPadding.toFloat(), right: padding, bottom: tg_bottomPadding.toFloat())
    }

    func setPaddingVertical(_ padding: Float) {
        setPadding(left: tg_leadingPadding.toFloat(), top: padding, right: tg_trailingPadding.toFloat(), bottom: padding)
    }

    func setPadding(left: Float = 0, top: Float = 0, right: Float = 0, bottom: Float = 0) {
        tg_leadingPadding = left.toCGFloat()
        tg_topPadding = top.toCGFloat()
        tg_trailingPadding = right.toCGFloat()
        tg_bottomPadding = bottom.toCGFloat()
    }

}