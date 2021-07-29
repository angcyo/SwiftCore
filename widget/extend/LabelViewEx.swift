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
    func bold(_ bold: Bool = true) {
        if bold {
            font = font.bold()
        } else {
            font = font.normal()
        }
    }

    /// 设置字体大小
    func setTextSize(_ size: CGFloat) {
        font = font.withSize(size)
    }

    /// 设置文本颜色, 支持UIColor 支持hex颜色
    func setTextColor(_ color: Any) {
        textColor = toColor(color)
    }
}

func labelView(_ text: String? = nil,
               size: Double = Res.Text.normal.size,
               color: UIColor = Res.Text.normal.color) -> UILabel {
    let view = UILabel()
    view.text = text
    view.font = UIFont.systemFont(ofSize: CGFloat(size), weight: .regular)
    view.textColor = color
    return view
}
