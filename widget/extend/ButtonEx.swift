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

    /// 加粗
    func setBold(_ bold: Bool = true) {
        titleLabel?.setBold(bold)
    }

    func bold(_ bold: Bool = true) {
        titleLabel?.setBold(bold)
    }
}

/// 按钮
func button(_ title: String? = nil,
            titleColor: UIColor = Res.color.white,
            bgColor: UIColor = Res.color.colorAccent,
            radius: Float = Res.size.roundNormal,
            titleSize: Double = Res.text.normal.size,
            insets: UIEdgeInsets? = nil) -> UIButton {
    let view = UIButton()
    view.setTitle(title, for: .normal)
    view.setTitleColor(titleColor, for: .normal)
    view.setBackground(bgColor)
    view.setRadius(radius)
    view.titleLabel?.setTextSize(titleSize)

    if let insets = insets {
        view.contentEdgeInsets = insets
    }

    //view.setBackgroundImage(<#T##image: UIImage?##UIKit.UIImage?#>, for: <#T##State##UIKit.UIControl.State#>)
    //view.setImage(<#T##image: UIImage?##UIKit.UIImage?#>, for: <#T##State##UIKit.UIControl.State#>)

    //view.layer.contents = UIImage().cgImage

    return view
}

/// 背景填充, 文本白色按钮
func solidButton(_ title: String? = nil,
                 fillColor: UIColor = Res.color.colorAccent,
                 radius: Float = Res.size.roundNormal,
                 titleColor: UIColor = Res.color.white,
                 titleSize: Double = Res.text.des.size,
                 insets: UIEdgeInsets? = nil) -> UIButton {
    let view = button(title, titleColor: titleColor, bgColor: fillColor,
            radius: radius, titleSize: titleSize, insets: insets)
    return view
}

/// 边框按钮
func borderButton(_ title: String? = nil,
                  radius: Float = Res.size.roundNormal,
                  titleColor: UIColor = Res.color.colorAccent,
                  bgColor: UIColor = Res.color.white,
                  borderColor: UIColor? = nil,
                  borderWidth: Float = Res.size.line,
                  titleSize: Double = Res.text.des.size,
                  insets: UIEdgeInsets? = nil) -> UIButton {
    let view = button(title, titleColor: titleColor,
            bgColor: bgColor, radius: radius,
            titleSize: titleSize,
            insets: UIEdgeInsets(top: 8, left: 9, bottom: 8, right: 9))
    view.setRadiusBorder(radius, borderColor: borderColor ?? titleColor, borderWidth: borderWidth)
    return view
}