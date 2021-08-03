//
// Created by wayto on 2021/7/28.
//

import Foundation
import UIKit

// MARK: - 资源

struct Res {

    // MARK: - 文本资源

    struct text {
        static var normal = (size: 17.0, color: UIColor.parse("#222222"))
        static var title = (size: 20.0, color: UIColor.parse("#222222"))
        static var big = (size: 22.0, color: UIColor.parse("#000000"))
        static var subTitle = (size: 14.0, color: UIColor.parse("#666666"))
        static var des = (size: 12.0, color: UIColor.parse("#ACB0B7"))
        static var tip = (size: 12.0, color: UIColor.parse("#ACB0B7"))
        static var body = (size: 16.0, color: UIColor.parse("#161D26"))
    }

    // MARK: - 颜色资源

    struct color {
        static var colorPrimary = UIColor.parse("#2D52F2")
        static var colorPrimaryDark = UIColor.parse("#162bf2ff")
        static var colorAccent = UIColor.parse("#2D52F2")

        static var white = UIColor.white
        static var line = UIColor.parse("#ECECEC")
        static var bg = UIColor.parse("#F3F5F9")

        static var shadowColor = UIColor.parse("#2B2B2B")
    }

    // MARK: - 尺寸资源

    struct size {
        static var line: Float = 1

        static var roundNormal: Float = 5
        static var roundCommon: Float = 15
        static var roundMax: Float = 45

        static var x: Float = 10
        static var xx: Float = 20
        static var xxx: Float = 30
    }

    // MARK: - 字体资源

    struct font {
        static var normal = UIFont.systemFont(ofSize: CGFloat(text.normal.size), weight: .regular)
    }
}
