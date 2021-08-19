//
// Created by angcyo on 21/08/13.
//

import Foundation
import TangramKit

extension UIView {

    func wrap_content(minWidth: Float? = nil, minHeight: Float? = nil) {
        if let min = minWidth {
            tg_width.min(min.toCGFloat())
        } else {
            tg_width.equal(.wrap)
        }

        if let min = minHeight {
            tg_height.min(min.toCGFloat())
        } else {
            tg_height.equal(.wrap)
        }
    }

    func match_parent(maxWidth: Float? = nil, maxHeight: Float? = nil) {
        if let max = maxWidth {
            tg_width.max(max.toCGFloat())
        } else {
            tg_width.equal(.fill)
        }

        if let max = maxHeight {
            tg_height.max(max.toCGFloat())
        } else {
            tg_height.equal(.fill)
        }
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

    /// 设置可见性
    func setVisible(_ visible: TGVisibility = .gone) {
        tg_visibility = visible
    }

    func gone(_ gone: Bool = true) {
        if gone {
            setVisible(.gone)
        } else {
            setVisible(.visible)
        }
    }

    func visible(_ visible: Bool = true) {
        if visible {
            setVisible(.visible)
        } else {
            setVisible(.gone)
        }
    }

    //MARK: margin

    func setMargin(_ margin: Float) {
        setMargin(left: margin, top: margin, right: margin, bottom: margin)
    }

    func setMarginHorizontal(_ margin: Float) {
        tg_leading.equal(margin.toCGFloat())
        tg_trailing.equal(margin.toCGFloat())
    }

    func setMarginVertical(_ margin: Float) {
        tg_top.equal(margin.toCGFloat())
        tg_bottom.equal(margin.toCGFloat())
    }

    func setMargin(left: Float = 0, top: Float = 0, right: Float = 0, bottom: Float = 0) {
        //tg_left.equal(left.toCGFloat())
        tg_leading.equal(left.toCGFloat())

        //tg_right.equal(right.toCGFloat())
        tg_trailing.equal(right.toCGFloat())

        tg_top.equal(top.toCGFloat())
        tg_bottom.equal(bottom.toCGFloat())
    }
}

extension TGBaseLayout {

    func cacheRect(_ bool: Bool = true) {
        tg_cacheEstimatedRect = bool
    }

    /// TGGravity.horz.center TGGravity.vert.center
    func setGravity(_ gravity: TGGravity = .center) {
        tg_gravity = gravity
    }

    //MARK: padding

    func setPadding(_ padding: Float) {
        setPadding(left: padding, top: padding, right: padding, bottom: padding)
    }

    func setPaddingHorizontal(_ padding: Float) {
        setPadding(left: padding, top: tg_padding.top.toFloat(), right: padding, bottom: tg_padding.bottom.toFloat())
    }

    func setPaddingVertical(_ padding: Float) {
        setPadding(left: tg_padding.left.toFloat(), top: padding, right: tg_padding.right.toFloat(), bottom: padding)
    }

    func setPadding(left: Float = 0, top: Float = 0, right: Float = 0, bottom: Float = 0) {
        //tg_leadingPadding = left.toCGFloat()
        //tg_topPadding = top.toCGFloat()
        //tg_trailingPadding = right.toCGFloat()
        //tg_bottomPadding = bottom.toCGFloat()
        tg_padding = UIEdgeInsets(top: top.toCGFloat(), left: left.toCGFloat(), bottom: bottom.toCGFloat(), right: right.toCGFloat())
    }
}
