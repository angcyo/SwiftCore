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
    static var width: CGFloat {
        UIScreen.main.bounds.width
    }

    /// 屏幕的高度
    static var height: CGFloat {
        UIScreen.main.bounds.height
    }

    /// 屏幕的缩放比例
    static var scale_: CGFloat {
        UIScreen.main.scale
    }
}

var screenWidth: CGFloat {
    get {
        UIScreen.width
    }
}

var screenHeight: CGFloat {
    get {
        UIScreen.height
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
    cgPoint(x: x, y: y)
}

func cgPoint(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
    CGPoint(x: x, y: y)
}

func rect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    CGRect(x: x, y: y, width: width, height: height)
}

func size(_ size: CGFloat) -> CGSize {
    CGSize(width: size, height: size)
}

func size(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    CGSize(width: width, height: height)
}

func cgSize(_ size: CGFloat) -> CGSize {
    CGSize(width: size, height: size)
}

func cgSize(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    CGSize(width: width, height: height)
}

func rect(_ width: CGFloat, _ height: CGFloat) -> CGRect {
    rect(0, 0, width, height)
}

func cgRect(_ width: CGFloat, _ height: CGFloat) -> CGRect {
    rect(0, 0, width, height)
}

func cgRect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    CGRect(x: x, y: y, width: width, height: height)
}

func cgRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
    CGRect(x: x, y: y, width: width, height: height)
}

func cgRect(x: CGFloat, y: CGFloat, size: CGSize) -> CGRect {
    CGRect(x: x, y: y, width: size.width, height: size.height)
}

func insets(size: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: size, left: size, bottom: size, right: size)
}

func insets(horizontal: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: 0, left: horizontal, bottom: 0, right: horizontal)
}

func insets(vertical: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: vertical, left: 0, bottom: vertical, right: 0)
}

func insets(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> UIEdgeInsets {
    UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
}

func insets(left: CGFloat = 0, top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) -> UIEdgeInsets {
    UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
}

extension UIEdgeInsets {

    /// 横向总插入
    var insetHorizontal: CGFloat {
        left + right
    }

    /// 纵向总插入
    var insetVertical: CGFloat {
        top + bottom
    }

    /// 重置底部
    func resetBottom(_ bottom: Float) -> UIEdgeInsets {
        UIEdgeInsets(top: top, left: left, bottom: bottom.toCGFloat(), right: right)
    }
}

extension CGSize {

    func isSizeChange(_ size: CGSize) -> Bool {
        width != size.width || height != size.height
    }

    func isSizeChange(rect: CGRect) -> Bool {
        isSizeChange(rect.size)
    }
}