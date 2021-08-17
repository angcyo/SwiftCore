//
// Created by angcyo on 21/08/16.
//

import Foundation
import TangramKit

/*
let C = UIView()
C.tg_left.equal(B.tg_right).offset(10)
C.tg_bottom.equal(B.tg_bottom)
C.tg_width.equal(40)
C.tg_height.equal(B.tg_height, multiple:0.5)
S.addSubview(C)
 */
///https://github.com/youngsoft/TangramKit/blob/master/README.zh.md#%E7%9B%B8%E5%AF%B9%E5%B8%83%E5%B1%80tgrelativelayout
func relativeLayout() -> TGRelativeLayout {
    let layout = TGRelativeLayout()
    return layout
}

extension UIView {

    /// 相对于目标, 自身左居中于目标
    func leftCenterOf(_ target: UIView? = nil, offset: Float = 0, offsetY: Float = 0) {
        if let target = target {
            tg_leading.equal(target.tg_trailing, offset: offset.toCGFloat())
            tg_centerY.equal(target.tg_centerY, offset: offsetY.toCGFloat())
        } else if let superview = superview {
            tg_leading.equal(superview.tg_leading, offset: offset.toCGFloat())
            tg_centerY.equal(superview.tg_centerY, offset: offsetY.toCGFloat())
        } else {
            tg_leading.equal(0, offset: offset.toCGFloat())
            tg_centerY.equal(0, offset: offsetY.toCGFloat())
        }
    }

    /// 相对于目标, 自身右居中于目标
    func rightCenterOf(_ target: UIView? = nil, offset: Float = 0, offsetY: Float = 0) {
        if let target = target {
            tg_trailing.equal(target.tg_leading, offset: offset.toCGFloat())
            tg_centerY.equal(target.tg_centerY, offset: offsetY.toCGFloat())
        } else if let superview = superview {
            tg_trailing.equal(superview.tg_trailing, offset: offset.toCGFloat())
            tg_centerY.equal(superview.tg_centerY, offset: offsetY.toCGFloat())
        } else {
            tg_trailing.equal(0, offset: offset.toCGFloat())
            tg_centerY.equal(0, offset: offsetY.toCGFloat())
        }
    }

    /// 自身左上 对齐目标左上
    func ltOf(_ target: UIView? = nil, offsetLeft: Float = 0, offsetTop: Float = 0) {
        if let target = target ?? superview {
            tg_leading.equal(target.tg_leading, offset: offsetLeft.toCGFloat())
            tg_top.equal(target.tg_top, offset: offsetTop.toCGFloat())
        } else {
            tg_leading.equal(0, offset: offsetLeft.toCGFloat())
            tg_top.equal(0, offset: offsetTop.toCGFloat())
        }
    }

    func rtOf(_ target: UIView? = nil, offsetRight: Float = 0, offsetTop: Float = 0) {
        if let target = target ?? superview {
            tg_trailing.equal(target.tg_trailing, offset: offsetRight.toCGFloat())
            tg_top.equal(target.tg_top, offset: offsetTop.toCGFloat())
        } else {
            tg_trailing.equal(0, offset: offsetRight.toCGFloat())
            tg_top.equal(0, offset: offsetTop.toCGFloat())
        }
    }

    func bottomToTopOf(_ target: UIView? = nil, offset: Float = 0) {
        if let target = target ?? superview {
            tg_bottom.equal(target.tg_top, offset: offset.toCGFloat())
        }
    }

    func bottomToBottomOf(_ target: UIView? = nil, offset: Float = 0) {
        if let target = target ?? superview {
            tg_bottom.equal(target.tg_bottom, offset: offset.toCGFloat())
        }
    }

    func topToBottomOf(_ target: UIView? = nil, offset: Float = 0) {
        if let target = target ?? superview {
            tg_top.equal(target.tg_bottom, offset: offset.toCGFloat())
        }
    }

    func topToTopOf(_ target: UIView? = nil, offset: Float = 0) {
        if let target = target ?? superview {
            tg_top.equal(target.tg_top, offset: offset.toCGFloat())
        }
    }

    func rightToLeftOf(_ target: UIView? = nil, offset: Float = 0) {
        if let target = target ?? superview {
            tg_trailing.equal(target.tg_leading, offset: offset.toCGFloat())
        }
    }

    func rightToRightOf(_ target: UIView? = nil, offset: Float = 0) {
        if let target = target ?? superview {
            tg_trailing.equal(target.tg_trailing, offset: offset.toCGFloat())
        }
    }

    func leftToRightOf(_ target: UIView? = nil, offset: Float = 0) {
        if let target = target ?? superview {
            tg_leading.equal(target.tg_trailing, offset: offset.toCGFloat())
        }
    }

    func leftToLeftOf(_ target: UIView? = nil, offset: Float = 0) {
        if let target = target ?? superview {
            tg_leading.equal(target.tg_leading, offset: offset.toCGFloat())
        }
    }
}