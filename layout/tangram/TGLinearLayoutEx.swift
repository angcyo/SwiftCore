//
// Created by angcyo on 21/08/13.
//

import Foundation
import TangramKit

///https://github.com/youngsoft/TangramKit/blob/master/README.zh.md#%E7%BA%BF%E6%80%A7%E5%B8%83%E5%B1%80tglinearlayout
func linearLayout(_ orientation: TGOrientation = TGOrientation.vert) -> TGLinearLayout {
    let layout = TGLinearLayout(orientation)
    //layout.tg_orientation = orientation
    layout.tg_width.equal(.wrap)
    layout.tg_height.equal(.wrap)
    //layout.tg_gravity = .center
    //layout.tg_gravity = TGGravity.vert.center
    //layout.tg_padding
    //layout.tg_margin(<#T##val: CGFloat##CoreGraphics.CGFloat#>)
    return layout
}