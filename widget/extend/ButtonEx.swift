//
// Created by wayto on 2021/7/29.
//

import Foundation
import UIKit

func button(_ title: String? = nil,
            titleColor: UIColor = Res.color.white,
            bgColor: UIColor = Res.color.colorAccent,
            radius: Float = Res.size.roundNormal) -> UIButton {
    let view = UIButton()
    view.setTitle(title, for: .normal)
    view.setTitleColor(titleColor, for: .normal)
    view.setBackground(bgColor)
    view.setRadius(radius)

    //view.setBackgroundImage(<#T##image: UIImage?##UIKit.UIImage?#>, for: <#T##State##UIKit.UIControl.State#>)
    //view.setImage(<#T##image: UIImage?##UIKit.UIImage?#>, for: <#T##State##UIKit.UIControl.State#>)

    return view
}