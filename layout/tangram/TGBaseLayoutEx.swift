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

    func mWwH(height: Float? = nil) {
        tg_width.equal(.fill)

        if let height = height {
            tg_height.equal(height.toCGFloat())
        } else {
            tg_height.equal(.wrap)
        }
    }

    func wWmH(width: Float? = nil) {
        tg_height.equal(.fill)

        if let width = width {
            tg_width.equal(width.toCGFloat())
        } else {
            tg_width.equal(.wrap)
        }
    }
}

extension TGBaseLayout {

    func setPadding(_ padding: Float) {
        setPadding(left: padding, top: padding, right: padding, bottom: padding)
    }

    func setPaddingHorizontal(_ padding: Float) {
        setPadding(left: padding, top: 0, right: padding, bottom: 0)
    }

    func setPaddingVertical(_ padding: Float) {
        setPadding(left: 0, top: padding, right: 0, bottom: padding)
    }

    func setPadding(left: Float = 0, top: Float = 0, right: Float = 0, bottom: Float = 0) {
        tg_leadingPadding = left.toCGFloat()
        tg_topPadding = top.toCGFloat()
        tg_trailingPadding = right.toCGFloat()
        tg_bottomPadding = bottom.toCGFloat()
    }

}