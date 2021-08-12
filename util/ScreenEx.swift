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

func rect(_ x: Float, _ y: Float, _ width: Float, _ height: Float) -> CGRect {
    CGRect(x: x.toCGFloat(), y: y.toCGFloat(), width: width.toCGFloat(), height: height.toCGFloat())
}

func rect(_ width: Float, _ height: Float) -> CGRect {
    rect(0, 0, width, height)
}