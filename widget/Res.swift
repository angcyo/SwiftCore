//
// Created by wayto on 2021/7/28.
//

import Foundation
import UIKit

// MARK: - 资源

struct Res {

    // MARK: - 文本资源

    struct text {
        static var normal: (size: CGFloat, color: UIColor) = (size: 17.0, color: UIColor.parse("#222222"))
        static var title: (size: CGFloat, color: UIColor) = (size: 20.0, color: UIColor.parse("#222222"))
        static var big: (size: CGFloat, color: UIColor) = (size: 24.0, color: UIColor.parse("#000000"))
        static var subTitle: (size: CGFloat, color: UIColor) = (size: 16.0, color: UIColor.parse("#161D26"))
        static var des: (size: CGFloat, color: UIColor) = (size: 13.0, color: UIColor.parse("#53575F"))
        static var label: (size: CGFloat, color: UIColor) = (size: 15.0, color: UIColor.parse("#ACB0B7"))
        static var tip: (size: CGFloat, color: UIColor) = (size: 12.0, color: UIColor.parse("#ACB0B7"))
        static var body: (size: CGFloat, color: UIColor) = (size: 14.0, color: UIColor.parse("#161D26"))
        static var min: (size: CGFloat, color: UIColor) = (size: 9.0, color: UIColor.parse("#ACB0B7"))
    }

    // MARK: - 颜色资源

    struct color {
        //static var _test = "#2D52F2"

        static var colorPrimary = UIColor.parse("#E41C1C")
        static var colorPrimaryDark = UIColor.parse("#921212")
        static var colorAccent = UIColor.parse("#E41C1C")
        /// 控制器的默认背景颜色
        static var controllerBackgroundColor = UIColor.white

        /// 禁用的颜色
        static var disable = UIColor.parse("#ACB0B7")
        static var clear = UIColor.clear

        static var white = UIColor.white
        static var black = UIColor.black
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

        /// 0 占位
        static var o: CGFloat = 0

        static var estimatedHeight: CGFloat = 0.0000001
        static var line: CGFloat = 1

        static var roundLittle: CGFloat = 2
        static var roundMin: CGFloat = 6
        static var roundNormal: CGFloat = 10
        static var roundCommon: CGFloat = 16
        static var roundMax: CGFloat = 46

        static var s: CGFloat = 2
        static var m: CGFloat = 6
        static var l: CGFloat = 8
        static var x: CGFloat = 10
        static var x2: CGFloat = 16
        static var xx: CGFloat = 20
        static var xxx: CGFloat = 30

        // 行间距
        static var lineSpacing: CGFloat = 6
        // Flow间隙
        static var space: CGFloat = 8

        static var textInset: CGFloat = 8 //ios textContainerInset 默认就是8
        // 表单左边距
        static var leftMargin: CGFloat = 16 //ios insetGrouped 边距默认也是16
        static var leadingMargin: CGFloat = 16 //头
        static var trailingMargin: CGFloat = 16 //尾

        // 头像的默认大小
        static var avatar: CGFloat = 68
        // 图标的大小
        static var icon: CGFloat = 18
        static var iconMin: CGFloat = 15 //小图标

        static var minHeight: CGFloat = 35 //控件 最小的高度

        static var itemRequiredOffsetLeft: CGFloat = 3 // * 左边偏移量
        static var itemRequiredOffsetTop: CGFloat = 20 // * 头部偏移量
        static var itemMinHeight: CGFloat = 52 //dsl item 最小的高度
        static var itemMinLabelWidth: CGFloat = 65 //dsl item label最小的宽度

        static var passwordMaxLength: Int = 20 //密码最大的长度
        static var codeMaxLength: Int = 6 //短信验证码最大的长度
    }

    // MARK: - 字体资源

    struct font {

        static func get(_ size: CGFloat = text.normal.size, _ weight: CGFloat = UIFont.Weight.regular.rawValue) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: UIFont.Weight(weight))
        }

        static var normal = UIFont.systemFont(ofSize: CGFloat(text.normal.size), weight: .regular)
    }
}
