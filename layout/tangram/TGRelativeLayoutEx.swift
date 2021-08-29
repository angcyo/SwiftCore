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
func relativeLayout(padding: CGFloat = 0) -> TGRelativeLayout {
    relativeLayout(paddingHorizontal: padding, paddingVertical: padding)
}

func relativeLayout(paddingHorizontal: CGFloat = 0, paddingVertical: CGFloat = 0) -> TGRelativeLayout {
    let layout = TGRelativeLayout()
    layout.wrap_content()
    layout.setPaddingHorizontal(paddingHorizontal)
    layout.setPaddingVertical(paddingVertical)
    return layout
}

extension UIView {

    /// 相对于目标, 自身左居中于目标
    func leftCenterOf(_ target: UIView? = nil, offset: CGFloat = 0, offsetY: CGFloat = 0) {
        if let target = target {
            tg_leading.equal(target.tg_trailing, offset: offset)
            tg_centerY.equal(target.tg_centerY, offset: offsetY)
        } else if let superview = superview {
            tg_leading.equal(superview.tg_leading, offset: offset)
            tg_centerY.equal(superview.tg_centerY, offset: offsetY)
        } else {
            tg_leading.equal(0, offset: offset)
            tg_centerY.equal(0, offset: offsetY)
        }
    }

    /// 相对于目标, 自身右居中于目标
    func rightCenterOf(_ target: UIView? = nil, offset: CGFloat = 0, offsetY: CGFloat = 0) {
        if let target = target {
            tg_trailing.equal(target.tg_leading, offset: offset)
            tg_centerY.equal(target.tg_centerY, offset: offsetY)
        } else if let superview = superview {
            tg_trailing.equal(superview.tg_trailing, offset: offset)
            tg_centerY.equal(superview.tg_centerY, offset: offsetY)
        } else {
            tg_trailing.equal(0, offset: offset)
            tg_centerY.equal(0, offset: offsetY)
        }
    }

    /// 自身左上 对齐目标左上
    func ltOf(_ target: UIView? = nil, offsetLeft: CGFloat = 0, offsetTop: CGFloat = 0) {
        if let target = target ?? superview {
            tg_leading.equal(target.tg_leading, offset: offsetLeft)
            tg_top.equal(target.tg_top, offset: offsetTop)
        } else {
            tg_leading.equal(0, offset: offsetLeft)
            tg_top.equal(0, offset: offsetTop)
        }
    }

    func rtOf(_ target: UIView? = nil, offsetRight: CGFloat = 0, offsetTop: CGFloat = 0) {
        if let target = target ?? superview {
            tg_trailing.equal(target.tg_trailing, offset: offsetRight)
            tg_top.equal(target.tg_top, offset: offsetTop)
        } else {
            tg_trailing.equal(0, offset: offsetRight)
            tg_top.equal(0, offset: offsetTop)
        }
    }

    func bottomToTopOf(_ target: UIView? = nil, offset: CGFloat = 0) {
        if let target = target ?? superview {
            tg_bottom.equal(target.tg_top, offset: offset)
        }
    }

    func bottomToBottomOf(_ target: UIView? = nil, offset: CGFloat = 0) {
        if let target = target ?? superview {
            tg_bottom.equal(target.tg_bottom, offset: offset)
        }
    }

    func topToBottomOf(_ target: UIView? = nil, offset: CGFloat = 0) {
        if let target = target ?? superview {
            tg_top.equal(target.tg_bottom, offset: offset)
        }
    }

    func topToTopOf(_ target: UIView? = nil, offset: CGFloat = 0) {
        if let target = target ?? superview {
            tg_top.equal(target.tg_top, offset: offset)
        }
    }

    func rightToLeftOf(_ target: UIView? = nil, offset: CGFloat = 0) {
        if let target = target ?? superview {
            tg_trailing.equal(target.tg_leading, offset: offset)
        }
    }

    func rightToRightOf(_ target: UIView? = nil, offset: CGFloat = 0) {
        if let target = target ?? superview {
            tg_trailing.equal(target.tg_trailing, offset: offset)
        }
    }

    func leftToRightOf(_ target: UIView? = nil, offset: CGFloat = 0) {
        if let target = target ?? superview {
            tg_leading.equal(target.tg_trailing, offset: offset)
        }
    }

    func leftToLeftOf(_ target: UIView? = nil, offset: CGFloat = 0) {
        if let target = target ?? superview {
            tg_leading.equal(target.tg_leading, offset: offset)
        }
    }

    /// y轴对齐, 垂直方向中心点一致
    func centerYOf(_ target: UIView? = nil, offset: CGFloat = 0) {
        if let target = target ?? superview {
            tg_centerY.equal(target.tg_centerY, offset: offset)
        }
    }

    /// x轴对齐, 水平方向中心点一致
    func centerXOf(_ target: UIView? = nil, offset: CGFloat = 0) {
        if let target = target ?? superview {
            tg_centerX.equal(target.tg_centerX, offset: offset)
        }
    }
}