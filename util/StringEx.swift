//
// Created by angcyo on 21/08/10.
//

import Foundation
import UIKit

extension NSString {
    func toString() -> String {
        self as String
    }
}

extension String {

    func toNSString() -> NSString {
        NSString(string: self)
    }

    /// 如果为空时则返回[empty]
    func ifEmpty(_ empty: String) -> String {
        if self.isEmpty || self.lowercased() == "null" {
            return empty
        }
        return self
    }

    func splitString(separator: Character, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [String] {
        let array = split(separator: separator, maxSplits: maxSplits, omittingEmptySubsequences: omittingEmptySubsequences)
        /*var result = [String]()
        for item in array {
            result.append("\(item)")
        }*/
        return array.compactMap {
            "\($0)"
        }
    }

    /// 文本绘制成图片
    /// https://stackoverflow.com/questions/1636492/converting-text-to-image-on-ios
    func toImage(rect: CGRect,
                 fillColor: UIColor = Res.color.colorPrimaryDark,
                 textColor: UIColor = Res.color.white,
                 size: Float = Float(Res.text.title.size),
                 gravity: Int = Gravity.Center) -> UIImage? {
        let text = self.toNSString()
        let attributes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(size))
        ]
        let textSize = text.size(withAttributes: attributes) //文本的宽高
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)

        //绘制背景
        let context = UIGraphicsGetCurrentContext()!
        //UIGraphicsPushContext(context)
        context.setFillColor(fillColor.cgColor)
        context.fill(rect)
        //UIGraphicsPopContext()

        //绘制文本
        dslGravity(gravity, rect: rect, size: textSize) { gravity in
            //文本左上角为原点开始绘制
            text.draw(at: CGPoint(x: gravity._left.toCGFloat(), y: gravity._top.toCGFloat()), withAttributes: attributes)
        }

        //text.draw(in: rect, withAttributes: attributes) //文本的左上角为原点开始绘制文本
        let image = UIGraphicsGetImageFromCurrentImageContext()
        defer {
            UIGraphicsEndImageContext()
        }
        return image
    }
}

func nilOrEmpty(_ value: String?) -> Bool {
    value == nil || value?.isEmpty == true
}