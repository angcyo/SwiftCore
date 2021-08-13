//
// Created by angcyo on 21/08/13.
//

import Foundation
import TangramKit

/// https://github.com/youngsoft/TangramKit/blob/master/README.zh.md#%E6%B5%81%E5%BC%8F%E5%B8%83%E5%B1%80tgflowlayout
func flowLayout(_ orientation: TGOrientation = TGOrientation.vert,
                space: Float = Res.size.space) -> TGFlowLayout {
    let layout = TGFlowLayout()
    if orientation == TGOrientation.vert {
        layout.tg_width.equal(.fill)
        layout.tg_height.equal(.wrap)
    } else {
        layout.tg_width.equal(.wrap)
        layout.tg_height.equal(.fill)
    }
    layout.tg_orientation = orientation
    layout.tg_space = space.toCGFloat()
    //layout.tg_gravity =
    return layout
}