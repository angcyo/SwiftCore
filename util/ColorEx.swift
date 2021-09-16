//
// Created by wayto on 2021/7/28.
//

import Foundation
import UIKit
import Hue

/// 颜色扩展
extension UIColor {

    ///
    /// UIColor.parse(hexStr: "#2D2D38")
    /// UIColor.parse(hexStr: "#2D2D38", alpha: 1)
    /// - Parameters:
    ///   - hexStr:
    ///   - alpha: 不透明度 1:完全不透明, 0:完全透明
    /// - Returns:
    static func parse(_ hexStr: String) -> UIColor {
        var cStr = hexStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString;

        if (cStr.length < 6) {
            return UIColor.clear;
        }

        if (cStr.hasPrefix("0x")) {
            cStr = cStr.substring(from: 2) as NSString
        }

        if (cStr.hasPrefix("#")) {
            cStr = cStr.substring(from: 1) as NSString
        }

        if (cStr.length != 6 && cStr.length != 8) {
            return UIColor.clear;
        }

        let rStr: String
        let gStr: String
        let bStr: String
        let aStr: String

        if cStr.length == 8 {
            aStr = cStr.substring(to: 2)
            rStr = cStr.substring(from: 2)
            gStr = (cStr.substring(from: 4) as NSString).substring(to: 2)
            bStr = (cStr.substring(from: 6) as NSString).substring(to: 2)
        } else {
            aStr = ""
            rStr = cStr.substring(to: 2)
            gStr = (cStr.substring(from: 2) as NSString).substring(to: 2)
            bStr = (cStr.substring(from: 4) as NSString).substring(to: 2)
        }

        var a: UInt32 = 0x0
        if aStr.isEmpty {
            a = 255
        } else {
            Scanner(string: aStr).scanHexInt32(&a);
        }

        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0

        Scanner(string: rStr).scanHexInt32(&r);
        Scanner(string: gStr).scanHexInt32(&g);
        Scanner(string: bStr).scanHexInt32(&b);

        return UIColor(red: CGFloat(r) / 255.0,
                green: CGFloat(g) / 255.0,
                blue: CGFloat(b) / 255.0,
                alpha: CGFloat(a) / 255.0);
    }

    /// [0~1] 的值
    var r: CGFloat {
        redComponent
    }
    var g: CGFloat {
        greenComponent
    }
    var b: CGFloat {
        blueComponent
    }
    /// 透明度, 0全透明, 1不透明
    var a: CGFloat {
        alphaComponent
    }

    /// 修改颜色透明度, 并返回新的颜色
    /// 颜色对象的不透明度值，指定为 0.0 到 1.0 之间的值。 低于 0.0 的 Alpha 值被解释为 0.0，高于 1.0 的值被解释为 1.0
    /// 不透明度 1:完全不透明, 0:完全透明
    func toAlpha(_ alpha: CGFloat = 0.3) -> UIColor {
        //let components = cgColor.components!
        //return UIColor(red: components[0], green: components[1], blue: components[2], alpha: alpha.toCGFloat())
        withAlphaComponent(alpha)
    }

    /// 渐变到另一个颜色 [fraction] 0~1 的进度
    func toColor(_ endColor: UIColor, fraction: CGFloat) -> UIColor {

        var redCurrent: CGFloat
        var blueCurrent: CGFloat
        var greenCurrent: CGFloat
        var alphaCurrent: CGFloat

        let redStart = r
        let blueStart = b
        let greenStart = g
        let alphaStart = a

        let redEnd = endColor.r
        let blueEnd = endColor.b
        let greenEnd = endColor.g
        let alphaEnd = endColor.a

        let redDifference = redEnd - redStart
        let blueDifference = blueEnd - blueStart
        let greenDifference = greenEnd - greenStart
        let alphaDifference = alphaEnd - alphaStart

        redCurrent = redStart + fraction * redDifference
        blueCurrent = blueStart + fraction * blueDifference
        greenCurrent = greenStart + fraction * greenDifference
        alphaCurrent = alphaStart + fraction * alphaDifference

        return UIColor(red: redCurrent, green: greenCurrent, blue: blueCurrent, alpha: alphaCurrent)
    }

    /// 颜色变亮
    func lighterColor(brightness: CGFloat = 0.25) -> UIColor {
        colorWithAppendingBrightness(aBrightness: 1 + brightness)
    }

    /// 颜色变暗
    func darkerColor(brightness: CGFloat = 0.25) -> UIColor {
        colorWithAppendingBrightness(aBrightness: 1 - brightness)
    }

    private func colorWithAppendingBrightness(aBrightness: CGFloat) -> UIColor {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * aBrightness, alpha: alpha)
        } else {
            return self
        }
    }

    /// 调整颜色饱和度
    /// UIColor+Hue.swift
    func saturationColor(minSaturation: CGFloat) -> UIColor {
        color(minSaturation: minSaturation)
    }
}

extension String {
    func toColor() -> UIColor {
        UIColor.parse(self)
    }
}

/// 颜色转换
func toColor(_ color: Any?) -> UIColor? {
    // op
    if color is UIColor {
        return color as! UIColor
    } else if color is String {
        return UIColor.parse(color as! String)
    }
    return nil
}