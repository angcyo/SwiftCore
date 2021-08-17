//
// Created by angcyo on 21/08/13.
//

import Foundation
import TangramKit

///https://github.com/youngsoft/TangramKit/blob/master/README.zh.md#%E7%BA%BF%E6%80%A7%E5%B8%83%E5%B1%80tglinearlayout
func linearLayout(_ orientation: TGOrientation = TGOrientation.vert, space: Float = 0) -> TGLinearLayout {
    let layout = TGLinearLayout(orientation)
    //layout.tg_orientation = orientation
    layout.tg_width.equal(.wrap)
    layout.tg_height.equal(.wrap)
    layout.tg_space = space.toCGFloat()
    //layout.tg_gravity = .center
    //layout.tg_gravity = TGGravity.vert.center
    //layout.tg_padding
    //layout.tg_margin(<#T##val: CGFloat##CoreGraphics.CGFloat#>)
    return layout
}

func horizontal(_ child: UIView...) -> TGLinearLayout {
    let layout = linearLayout(.horz)
    child.forEach {
        layout.render($0)
    }
    return layout
}

func vertical(_ child: UIView...) -> TGLinearLayout {
    let layout = linearLayout(.horz)
    child.forEach {
        layout.render($0)
    }
    return layout
}

extension UIView {

}