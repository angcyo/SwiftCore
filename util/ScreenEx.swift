//
//  ScreenEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/28.
//

import Foundation
import UIKit

extension UIScreen {

    /// 屏幕的宽度
    static var width: Float {
        UIScreen.main.bounds.w
    }

    /// 屏幕的高度
    static var height: Float {
        UIScreen.main.bounds.h
    }

    /// 屏幕的缩放比例
    static var scale_: Float {
        UIScreen.main.scale.toFloat()
    }
}

extension CGSize {
    var w: Float {
        Float(width)
    }

    var h: Float {
        Float(height)
    }
}

extension CGRect {
    var x: Float {
        Float(origin.x)
    }

    var y: Float {
        Float(origin.y)
    }

    var w: Float {
        Float(size.width)
    }

    var h: Float {
        Float(size.height)
    }
}

func point(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
    CGPoint(x: x, y: y)
}

func rect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    CGRect(x: x, y: y, width: width, height: height)
}

func rect(_ width: CGFloat, _ height: CGFloat) -> CGRect {
    rect(0, 0, width, height)
}

func insets(left: CGFloat = 0, top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) -> UIEdgeInsets {
    UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
}

extension UIEdgeInsets {
    func resetBottom(_ bottom: Float) -> UIEdgeInsets {
        UIEdgeInsets(top: top, left: left, bottom: bottom.toCGFloat(), right: right)
    }
}