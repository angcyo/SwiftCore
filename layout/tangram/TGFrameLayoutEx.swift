//
// Created by angcyo on 21/08/13.
//

import Foundation
import TangramKit

///https://github.com/youngsoft/TangramKit/blob/master/README.zh.md#%E6%A1%86%E6%9E%B6%E5%B8%83%E5%B1%80tgframelayout
func frameLayout() -> TGFrameLayout {
    let layout = TGFrameLayout()
    layout.wrap_content()
    return layout
}

/// 扩展[UIView]在[TGFrameLayout]中的一些属性
extension UIView {

    /// 定位在 左上角
    func frameGravityLT(offsetLeft: Float = 0, offsetTop: Float = 0) {
        tg_top.equal(offsetTop.toCGFloat())
        tg_leading.equal(offsetLeft.toCGFloat())
    }

    /// 左中
    func frameGravityLC(offsetLeft: Float = 0, offsetY: Float = 0) {
        tg_centerY.equal(offsetY.toCGFloat())
        tg_leading.equal(offsetLeft.toCGFloat())
    }

    /// 左下
    func frameGravityLB(offsetLeft: Float = 0, offsetBottom: Float = 0) {
        tg_bottom.equal(offsetBottom.toCGFloat())
        tg_leading.equal(offsetLeft.toCGFloat())
    }

    /// 上中
    func frameGravityTC(offsetTop: Float = 0, offsetX: Float = 0) {
        tg_centerX.equal(offsetX.toCGFloat())
        tg_top.equal(offsetTop.toCGFloat())
    }

    /// 居中
    func frameGravityCenter(offsetX: Float = 0, offsetY: Float = 0) {
        tg_centerX.equal(offsetX.toCGFloat())
        tg_centerY.equal(offsetY.toCGFloat())
    }

    /// 下中
    func frameGravityBC(offsetBottom: Float = 0, offsetX: Float = 0) {
        tg_centerX.equal(offsetX.toCGFloat())
        tg_bottom.equal(offsetBottom.toCGFloat())
    }

    /// 右上
    func frameGravityRT(offsetTop: Float = 0, offsetRight: Float = 0) {
        tg_trailing.equal(offsetRight.toCGFloat())
        tg_top.equal(offsetTop.toCGFloat())
    }

    /// 右中
    func frameGravityRC(offsetY: Float = 0, offsetRight: Float = 0) {
        tg_trailing.equal(offsetRight.toCGFloat())
        tg_centerY.equal(offsetY.toCGFloat())
    }

    /// 右下
    func frameGravityRB(offsetBottom: Float = 0, offsetRight: Float = 0) {
        tg_trailing.equal(offsetRight.toCGFloat())
        tg_bottom.equal(offsetBottom.toCGFloat())
    }
}