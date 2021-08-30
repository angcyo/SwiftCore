//
// Created by wayto on 2021/7/29.
//

import Foundation
import UIKit
import UIGradient

extension UIButton {

    func setText(_ title: String?, all: Bool = true) {
        setTitle(title, for: .normal)
        if all {
            setTitle(title, for: .selected)
            setTitle(title, for: .highlighted)
        }
    }

    func setAttributedText(_ title: NSAttributedString?, all: Bool = true) {
        setAttributedTitle(title, for: .normal)
        if all {
            setAttributedTitle(title, for: .selected)
            setAttributedTitle(title, for: .highlighted)
        }
    }

    func setTextSize(_ size: CGFloat) {
        titleLabel?.setTextSize(size)
    }

    func setTextColor(_ color: UIColor?, all: Bool = true) {
        setTitleColor(color, for: .normal)
        if all {
            setTitleColor(color, for: .selected)
            setTitleColor(color, for: .highlighted)
        }
    }

    /// 加粗
    func setBold(_ bold: Bool = true) {
        titleLabel?.setBold(bold)
    }

    func bold(_ bold: Bool = true) {
        titleLabel?.setBold(bold)
    }

    func setPadding(_ padding: CGFloat = 0) {
        setPadding(left: padding, top: padding, right: padding, bottom: padding)
    }

    func setPaddingHorizontal(_ padding: CGFloat) {
        setPadding(left: padding, top: contentEdgeInsets.top, right: padding, bottom: contentEdgeInsets.bottom)
    }

    func setPaddingVertical(_ padding: CGFloat) {
        setPadding(left: contentEdgeInsets.left, top: padding, right: contentEdgeInsets.right, bottom: padding)
    }

    func setPadding(left: CGFloat = 0, top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) {
        contentEdgeInsets = insets(left: left, top: top, right: right, bottom: bottom)
    }
}

/// 按钮
func button(_ title: String? = nil,
            titleColor: UIColor = Res.color.white,
            bgColor: UIColor = Res.color.colorAccent,
            radius: CGFloat = Res.size.roundNormal,
            titleSize: CGFloat = Res.text.normal.size,
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

func gradientButton(_ title: String? = nil, colors: [UIColor] = [Res.color.colorPrimary, Res.color.colorPrimaryDark]) -> UIButton {
    let view = button(title)
    view.addGradient(colors: colors)
    return view
}

/// 背景填充, 文本白色按钮
func solidButton(_ title: String? = nil,
                 fillColor: UIColor = Res.color.colorAccent,
                 radius: CGFloat = Res.size.roundNormal,
                 titleColor: UIColor = Res.color.white,
                 titleSize: CGFloat = Res.text.des.size,
                 insets: UIEdgeInsets? = nil) -> UIButton {
    let view = button(title, titleColor: titleColor, bgColor: fillColor,
            radius: radius, titleSize: titleSize, insets: insets)
    return view
}

/// 边框按钮
func borderButton(_ title: String? = nil,
                  radius: CGFloat = Res.size.roundNormal,
                  titleColor: UIColor = Res.color.colorAccent,
                  bgColor: UIColor = Res.color.white,
                  borderColor: UIColor? = nil,
                  borderWidth: CGFloat = Res.size.line,
                  titleSize: CGFloat = Res.text.des.size,
                  insets: UIEdgeInsets? = nil) -> UIButton {
    let view = button(title, titleColor: titleColor,
            bgColor: bgColor, radius: radius,
            titleSize: titleSize,
            insets: UIEdgeInsets(top: 8, left: 9, bottom: 8, right: 9))
    view.setRadiusBorder(radius, borderColor: borderColor ?? titleColor, borderWidth: borderWidth)
    return view
}

/// 偏平的文本按钮
func labelButton(_ title: String? = nil,
                 titleColor: UIColor = Res.text.label.color,
                 titleSize: CGFloat = Res.text.label.size,
                 _ onClick: ((UIResponder) -> Void)? = nil) -> UIButton {
    let view = UIButton(type: .custom)
    view.backgroundColor = UIColor.clear
    view.tintColor = titleColor
    view.setTitle(title, for: .normal)
    view.setTitle(title, for: .selected)
    view.setTitle(title, for: .highlighted)
    view.setTitle(title, for: .disabled)
    view.setTitleColor(titleColor, for: .normal)
    view.setTitleColor(titleColor, for: .selected)
    view.setTitleColor(titleColor, for: .highlighted)
    view.setTitleColor(titleColor, for: .disabled)
    view.titleLabel?.setTextSize(titleSize)

    if let click = onClick {
        view.onClick(.touchUpInside, click)
    }
    return view
}

/// 勾选框 [onCheck] 返回是否可以选中/取消选中
func checkButton(_ title: String? = nil,
                 titleColor: UIColor = Res.text.label.color,
                 titleSize: CGFloat = Res.text.label.size,
                 _ onCheck: ((Bool) -> Bool)? = nil) -> UIButton {
    let view = UIButton(type: .custom)
    view.backgroundColor = UIColor.clear
    view.tintColor = titleColor
    view.setImage(R.image.uncheck(), for: .normal)
    view.setImage(R.image.checked(), for: .selected)
    view.setTitle(title, for: .normal)
    view.setTitle(title, for: .selected)
    view.setTitle(title, for: .highlighted)
    view.setTitleColor(titleColor, for: .normal)
    view.setTitleColor(titleColor, for: .selected)
    view.setTitleColor(titleColor, for: .highlighted)
    view.titleLabel?.setTextSize(titleSize)

    // 文本和图标的左边界
    //view.titleEdgeInsets = insets(left: 10)
    //view.titleEdgeInsets.left = Res.size.x.toCGFloat()
    //view.imageEdgeInsets.right = Res.size.x.toCGFloat()

    view.onClick { _ in
        let selected = !view.isSelected
        if let onCheck = onCheck {
            if onCheck(selected) {
                view.isSelected = selected
            }
        } else {
            view.isSelected = selected
        }
    }
    return view
}