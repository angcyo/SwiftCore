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
        static var big = (size: 24.0, color: UIColor.parse("#000000"))
        static var subTitle = (size: 16.0, color: UIColor.parse("#161D26"))
        static var des = (size: 13.0, color: UIColor.parse("#53575F"))
        static var label = (size: 15.0, color: UIColor.parse("#ACB0B7"))
        static var tip = (size: 12.0, color: UIColor.parse("#ACB0B7"))
        static var body = (size: 14.0, color: UIColor.parse("#161D26"))
    }

    // MARK: - 颜色资源

    struct color {
        static var colorPrimary = UIColor.parse("#2D52F2")
        static var colorPrimaryDark = UIColor.parse("#162bf2ff")
        static var colorAccent = UIColor.parse("#2D52F2")
        /// 控制器的默认背景颜色
        static var controllerBackgroundColor = UIColor.white

        static var white = UIColor.white
        static var line = UIColor.parse("#ECECEC")
        static var bg = UIColor.parse("#F3F5F9")
        static var desBg = UIColor.parse("#F3F5F9")

        /// 按压时的颜色
        static var press = UIColor.parse("#20000000")

        static var info = UIColor.parse("#4b7efe")
        static var success = UIColor.parse("#44CB5C")
        static var warning = UIColor.parse("#febf00")
        static var error = UIColor.parse("#ff4d3f")
        static var fairly = UIColor.parse("#c3c9cf")

        // 阴影颜色
        static var shadowColor = UIColor.parse("#2B2B2B")

        // 灰色图标颜色
        static var iconColor = UIColor.parse("#C3C7CF")
    }

    // MARK: - 尺寸资源

    struct size {
        static var line: Float = 1

        static var roundLittle: Float = 2
        static var roundMin: Float = 5
        static var roundNormal: Float = 10
        static var roundCommon: Float = 15
        static var roundMax: Float = 45

        static var x: Float = 10
        static var xx: Float = 20
        static var xxx: Float = 30

        // 行间距
        static var lineSpacing: Float = 6
        // Flow间隙
        static var space: Float = 8

        // 表单左边距
        static var leftMargin: Float = 16
        static var leadingMargin: Float = 16 //头
        static var trailingMargin: Float = 16 //尾

        // 头像的默认大小
        static var avatar: Float = 68
        // 图标的大小
        static var icon: Float = 18
        static var iconMin: Float = 15 //小图标

        static var minHeight: Float = 35 //控件 最小的高度

        static var itemRequiredOffsetLeft: Float = 3 // * 左边偏移量
        static var itemRequiredOffsetTop: Float = 20 // * 头部偏移量
        static var itemMinHeight: Float = 52 //dsl item 最小的高度
        static var itemMinLabelWidth: Float = 65 //dsl item label最小的宽度
    }

    // MARK: - 字体资源

    struct font {

        static func get(_ size: Float = Float(text.normal.size), _ weight: Float = Float(UIFont.Weight.regular.rawValue)) -> UIFont {
            UIFont.systemFont(ofSize: CGFloat(size), weight: UIFont.Weight(CGFloat(weight)))
        }

        static var normal = UIFont.systemFont(ofSize: CGFloat(text.normal.size), weight: .regular)

    }
}
