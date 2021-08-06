//
// Created by wayto on 2021/7/29.
//

import Foundation
import UIKit

extension UIButton {
    func setText(_ title: String?) {
        setTitle(title, for: .normal)
        //setTitle(title: title, for: .selected)
        //setTitle(title: title, for: .highlighted)
    }
}

/// 按钮
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

    //view.layer.contents = UIImage().cgImage

    return view
}

/// 背景填充, 文本白色按钮
func solidButton(_ title: String? = nil,
                 fillColor: UIColor = Res.color.colorAccent,
                 radius: Float = Res.size.roundNormal,
                 titleColor: UIColor = Res.color.white) -> UIButton {
    let view = button(title, titleColor: titleColor, bgColor: fillColor, radius: radius)
    return view
}

/// 边框按钮
func borderButton(_ title: String? = nil,
                  radius: Float = Res.size.roundNormal,
                  titleColor: UIColor = Res.color.colorAccent,
                  bgColor: UIColor = Res.color.white,
                  borderColor: UIColor? = Res.color.colorAccent,
                  borderWidth: Float = Res.size.line) -> UIButton {
    let view = button(title, titleColor: titleColor, bgColor: bgColor, radius: radius)
    view.setRadiusBorder(radius, borderColor: borderColor, borderWidth: borderWidth)
    return view
}