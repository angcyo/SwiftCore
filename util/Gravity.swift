//
// Created by angcyo on 21/08/11.
//

import Foundation
import UIKit

class Gravity {

    static let Left = 0b0001
    static let Right = 0b0100
    static let Center_Horizontal = 0b100000

    static let Top = 0b0010
    static let Bottom = 0b1000
    static let Center_Vertical = 0b1000000

    static let Center = Center_Horizontal | Center_Vertical

    /// 偏移量, 根据方向. 自动取负值
    var offsetX: Float = 0
    var offsetY: Float = 0

    /// 计算之后的坐标位置
    var _left: Float = Float.min
    var _right: Float = Float.min
    var _top: Float = Float.min
    var _bottom: Float = Float.min
    var _centerX: Float = Float.min
    var _centerY: Float = Float.min

    func apply(rect: CGRect, size: CGSize, gravity: Int = Center) {
        let width = Float(size.width)
        let height = Float(size.height)

        //x
        if gravity.have(Gravity.Left) {
            _left = rect.x + offsetX
            _centerX = _left + width / 2
        } else if gravity.have(Gravity.Center_Horizontal) {
            _centerX = rect.x + rect.w / 2 + offsetX
            _left = _centerX - width / 2
        } else if gravity.have(Gravity.Right) {
            _left = rect.x + rect.w - offsetX - width
            _centerX = _left + width / 2
        }
        _right = _left + width

        //y
        if gravity.have(Gravity.Top) {
            _top = rect.y + offsetY
            _centerY = _top + height / 2
        } else if gravity.have(Gravity.Center_Vertical) {
            _centerY = rect.y + rect.h / 2 + offsetY
            _top = _centerY - height / 2
        } else if gravity.have(Gravity.Bottom) {
            _top = rect.y + rect.h - offsetY - height
            _centerY = _top + height / 2
        }
        _bottom = _top + height

    }
}

func dslGravity(_ gravity: Int, rect: CGRect, size: CGSize, _ config: (Gravity) -> Void) {
    let g = Gravity()
    g.apply(rect: rect, size: size)
    config(g)
}