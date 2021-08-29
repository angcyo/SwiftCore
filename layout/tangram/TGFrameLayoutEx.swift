//
// Created by angcyo on 21/08/13.
//

import Foundation
import TangramKit

///https://github.com/youngsoft/TangramKit/blob/master/README.zh.md#%E6%A1%86%E6%9E%B6%E5%B8%83%E5%B1%80tgframelayout
func frameLayout(padding: CGFloat = 0) -> TGFrameLayout {
    frameLayout(paddingHorizontal: padding, paddingVertical: padding)
}

func frameLayout(paddingHorizontal: CGFloat = 0, paddingVertical: CGFloat = 0) -> TGFrameLayout {
    let layout = TGFrameLayout()
    layout.wrap_content()
    layout.setPaddingHorizontal(paddingHorizontal)
    layout.setPaddingVertical(paddingVertical)
    return layout
}

/// 扩展[UIView]在[TGFrameLayout]中的一些属性
extension UIView {

    /// 定位在 左上角
    func frameGravityLT(offsetLeft: CGFloat = 0, offsetTop: CGFloat = 0) {
        tg_top.equal(offsetTop)
        tg_leading.equal(offsetLeft)
    }

    /// 左中
    func frameGravityLC(offsetLeft: CGFloat = 0, offsetY: CGFloat = 0) {
        tg_centerY.equal(offsetY)
        tg_leading.equal(offsetLeft)
    }

    /// 左下
    func frameGravityLB(offsetLeft: CGFloat = 0, offsetBottom: CGFloat = 0) {
        tg_bottom.equal(offsetBottom)
        tg_leading.equal(offsetLeft)
    }

    /// 上中
    func frameGravityTC(offsetTop: CGFloat = 0, offsetX: CGFloat = 0) {
        tg_centerX.equal(offsetX)
        tg_top.equal(offsetTop)
    }

    /// 居中
    func frameGravityCenter(offsetX: CGFloat = 0, offsetY: CGFloat = 0) {
        tg_centerX.equal(offsetX)
        tg_centerY.equal(offsetY)
    }

    /// 下中
    func frameGravityBC(offsetBottom: CGFloat = 0, offsetX: CGFloat = 0) {
        tg_centerX.equal(offsetX)
        tg_bottom.equal(offsetBottom)
    }

    /// 右上
    func frameGravityRT(offsetTop: CGFloat = 0, offsetRight: CGFloat = 0) {
        tg_trailing.equal(offsetRight)
        tg_top.equal(offsetTop)
    }

    /// 右中
    func frameGravityRC(offsetY: CGFloat = 0, offsetRight: CGFloat = 0) {
        tg_trailing.equal(offsetRight)
        tg_centerY.equal(offsetY)
    }

    /// 右下
    func frameGravityRB(offsetBottom: CGFloat = 0, offsetRight: CGFloat = 0) {
        tg_trailing.equal(offsetRight)
        tg_bottom.equal(offsetBottom)
    }

    func frameGravityLeft(offset: CGFloat = 0) {
        tg_leading.equal(0, offset: offset)
    }

    func frameGravityTop(offset: CGFloat = 0) {
        tg_top.equal(0, offset: offset)
    }

    func frameGravityRight(offset: CGFloat = 0) {
        tg_trailing.equal(0, offset: offset)
    }

    func frameGravityBottom(offset: CGFloat = 0) {
        tg_bottom.equal(0, offset: offset)
    }

}