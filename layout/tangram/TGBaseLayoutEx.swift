//
// Created by angcyo on 21/08/13.
//

import Foundation
import TangramKit

extension UIView {

    func wrap_content(minWidth: CGFloat? = nil, minHeight: CGFloat? = nil) {
        if let min = minWidth {
            tg_width.equal(.wrap).min(min)
        } else {
            tg_width.equal(.wrap)
        }

        if let min = minHeight {
            tg_height.equal(.wrap).min(min)
        } else {
            tg_height.equal(.wrap)
        }
    }

    func match_parent(maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) {
        if let max = maxWidth {
            tg_width.equal(.wrap).max(max)
        } else {
            tg_width.equal(.fill)
        }

        if let max = maxHeight {
            tg_height.equal(.wrap).max(max)
        } else {
            tg_height.equal(.fill)
        }
    }

    func wh(width: CGFloat? = nil, height: CGFloat? = nil) {
        if let width = width {
            tg_width.equal(width)
        } else {
            tg_width.equal(.wrap)
        }
        if let height = height {
            tg_height.equal(height)
        } else {
            tg_height.equal(.wrap)
        }
    }

    func mWwH(height: CGFloat? = nil, minHeight: CGFloat? = nil) {
        tg_width.equal(.fill)

        if let height = height {
            tg_height.equal(height)
        } else {
            tg_height.equal(.wrap)
        }

        if let min = minHeight {
            tg_height.equal(.wrap).min(min)
        }
    }

    func wWmH(width: CGFloat? = nil, minWidth: CGFloat? = nil) {
        tg_height.equal(.fill)

        if let width = width {
            tg_width.equal(width)
        } else {
            tg_width.equal(.wrap)
        }

        if let min = minWidth {
            tg_width.equal(.wrap).min(min)
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

    func setMargin(_ margin: CGFloat) {
        setMargin(left: margin, top: margin, right: margin, bottom: margin)
    }

    func setMarginHorizontal(_ margin: CGFloat) {
        tg_leading.equal(margin)
        tg_trailing.equal(margin)
    }

    func setMarginVertical(_ margin: CGFloat) {
        tg_top.equal(margin)
        tg_bottom.equal(margin)
    }

    func setMargin(left: CGFloat = 0, top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) {
        //tg_left.equal(left)
        tg_leading.equal(left)

        //tg_right.equal(right)
        tg_trailing.equal(right)

        tg_top.equal(top)
        tg_bottom.equal(bottom)
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

    func setPadding(_ padding: CGFloat) {
        setPadding(left: padding, top: padding, right: padding, bottom: padding)
    }

    func setPaddingHorizontal(_ padding: CGFloat) {
        setPadding(left: padding, top: tg_padding.top, right: padding, bottom: tg_padding.bottom)
    }

    func setPaddingVertical(_ padding: CGFloat) {
        setPadding(left: tg_padding.left, top: padding, right: tg_padding.right, bottom: padding)
    }

    func setPadding(left: CGFloat = 0, top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) {
        //tg_leadingPadding = left
        //tg_topPadding = top
        //tg_trailingPadding = right
        //tg_bottomPadding = bottom
        tg_padding = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}
