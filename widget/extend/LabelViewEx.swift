//
//  LabelViewEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/28.
//

import Foundation
import UIKit

extension UIFont {

    func normal() -> UIFont {
        UIFont.systemFont(ofSize: self.pointSize)
    }

    /// 加粗
    func bold() -> UIFont {
        UIFont.boldSystemFont(ofSize: self.pointSize)
    }

    /// 斜体
    func italic() -> UIFont {
        UIFont.italicSystemFont(ofSize: self.pointSize)
    }
}

extension UILabel {

    /// 加粗
    func setBold(_ bold: Bool = true) {
        if bold {
            font = font.bold()
        } else {
            font = font.normal()
        }
    }

    func bold(_ bold: Bool = true) {
        setBold(bold)
    }

    /// 设置文本
    func setText(_ text: String?) {
        self.text = text
    }

    func setAlignment(_ alignment: NSTextAlignment) {
        textAlignment = alignment
    }

    func setAttributedText(_ text: NSAttributedString?) {
        attributedText = text
    }

    /// 设置字体大小
    func setTextSize(_ size: Double) {
        font = font.withSize(size.toCGFloat())
    }

    func setTextSize(_ size: Float) {
        font = font.withSize(size.toCGFloat())
    }

    func setTextSize(_ size: CGFloat) {
        font = font.withSize(size)
    }

    /// 设置文本颜色, 支持UIColor 支持hex颜色
    func setTextColor(_ color: Any?) {
        textColor = toColor(color)
    }

    /// 单行显示
    func singleLine(line: Int = 1, lineBreakMode: NSLineBreakMode = .byTruncatingTail) {
        numberOfLines = line
        self.lineBreakMode = lineBreakMode ///*.byWordWrapping + */.byTruncatingTail
    }
}

func labelView(_ text: String? = nil,
               size: CGFloat = Res.text.label.size,
               color: UIColor = Res.text.label.color) -> UILabel {
    let view = UILabel()
    view.text = text
    view.font = UIFont.systemFont(ofSize: CGFloat(size), weight: .regular)
    view.textColor = color
    view.numberOfLines = 0 //任意行
    view.lineBreakMode = .byWordWrapping /*+ .byTruncatingTail*/
    if !nilOrEmpty(text) {
        view.sizeToFit()
    }
    return view
}

func titleView(_ text: String? = nil,
               size: CGFloat = Res.text.title.size,
               color: UIColor = Res.text.title.color) -> UILabel {
    let view = labelView(text, size: size, color: color)
    return view
}

func subTitleView(_ text: String? = nil,
                  size: CGFloat = Res.text.subTitle.size,
                  color: UIColor = Res.text.subTitle.color) -> UILabel {
    let view = labelView(text, size: size, color: color)
    return view
}

func bodyTextView(_ text: String? = nil) -> UILabel {
    let view = labelView(text, size: Res.text.body.size, color: Res.text.body.color)
    return view
}

func desLabel(_ text: String? = nil) -> UILabel {
    desView(text)
}

func desView(_ text: String? = nil,
             size: CGFloat = Res.text.des.size,
             color: UIColor = Res.text.des.color) -> UILabel {
    let view = labelView(text, size: size, color: color)
    return view
}

/// 填充色 提示性质的Label
func fillTipLabel(_ text: String? = nil, textColor: UIColor = Res.color.info, fillColor: UIColor? = nil) -> PaddingLabel {
    let backColor = fillColor ?? textColor.alpha(0.3)
    let color = textColor
    let view = PaddingLabel()

    view.text = text
    view.font = UIFont.systemFont(ofSize: CGFloat(Res.text.tip.size), weight: .regular)
    view.numberOfLines = 0 //任意行
    view.lineBreakMode = .byWordWrapping

    view.setRadius(Res.size.roundLittle)
    view.setBackground(backColor)
    view.textColor = color

    if !nilOrEmpty(text) {
        view.sizeToFit()
    }

    /*let button = UIButton()
    button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    button.setTitle("title", for: .normal)
    button.tintColor = .white // this will be the textColor
    button.isUserInteractionEnabled = false*/
    return view
}

/// 边框色 提示性质的Label
func borderTipLabel(_ text: String? = nil, textColor: UIColor = Res.color.info, borderColor: UIColor? = nil) -> PaddingLabel {
    let borderColor = borderColor ?? textColor
    let color = textColor
    let view = PaddingLabel()
    view.topInset = 3
    view.bottomInset = view.topInset
    view.leftInset = 5
    view.rightInset = view.leftInset

    view.text = text
    view.font = UIFont.systemFont(ofSize: CGFloat(Res.text.tip.size), weight: .regular)
    view.numberOfLines = 0 //任意行
    view.lineBreakMode = .byWordWrapping

    view.setRadiusBorder(Res.size.roundLittle, borderColor: borderColor)
    view.textColor = color

    if !nilOrEmpty(text) {
        view.sizeToFit()
    }
    return view
}

func paddingLabel(size: CGFloat = Res.text.label.size, color: UIColor = Res.text.label.color) -> PaddingLabel {
    let view = PaddingLabel()
    view.topInset = 3
    view.bottomInset = view.topInset
    view.leftInset = 5
    view.rightInset = view.leftInset
    view.textColor = color
    view.font = UIFont.systemFont(ofSize: size, weight: .regular)
    return view
}