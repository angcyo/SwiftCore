//
// Created by angcyo on 21/08/05.
//

import Foundation
import UIKit

/*
 https://www.jishudog.com/5250/html
 https://github.com/DevYao/exampleForAnimation

KeyPath值	说明	使用形式- swift 3.0
transform.scale	比例缩放	0.8
transform.scale.x	缩放宽的比例	0.8
transform.scale.y	缩放高的比例	0.8
transform.rotation.x	围绕x轴旋转	2 * M_PI
transform.rotation.y	围绕y轴旋转	2 * M_PI
transform.rotation.z	围绕z轴旋转	2 * M_PI
backgroundColor	背景颜色的变化	UIColor.red.cgColor
bounds	大小缩放，中心不变	NSValue(cgRect: CGRect(x: 800, y: 500, width: 90, height: 30))
position	位置(中心点的改变)	NSValue(cgPoint: CGPoint(x: 40, y: 240))
contents	内容，比如UIImageView的图片	UIImage(named: “to”)?.cgImage
opacity	透明度	0.4
contentsRect.size.width	横向拉伸缩放	0.6
contentsRect.size.height	纵向拉伸缩放	0.5
 */

/// 动画 https://zsisme.gitbooks.io/ios-/content/index.html

/// 将控件的操作放在动画中执行, 相当于Android的transition [duration]秒
/// 注意: 需要调用 self.view.layoutIfNeeded() 触发动画
func animate(_ duration: Double = 0.3, delay: Double = 0, options: UIView.AnimationOptions = [], _ animations: @escaping () -> Void) {
    UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations)
}

extension UIView {

    //MARK: 标准动画

    /// 平移到指定坐标
    func translationTo(x: CGFloat = 0, y: CGFloat = 0) {
        transform = CGAffineTransform(translationX: x, y: y)
    }

    func translation(x: CGFloat = 0, y: CGFloat = 0) {
        transform = transform.concatenating(CGAffineTransform(translationX: x, y: y))
    }

    func translationBy(x: CGFloat = 0, y: CGFloat = 0) {
        transform = transform.translatedBy(x: x, y: y)
    }

    /// 缩放
    func scaledTo(x: CGFloat = 1, y: CGFloat = 1) {
        transform = CGAffineTransform(scaleX: x, y: y)
    }

    func scaled(x: CGFloat = 1, y: CGFloat = 1) {
        transform = transform.concatenating(CGAffineTransform(scaleX: x, y: y))
    }

    func scaledBy(x: CGFloat = 1, y: CGFloat = 1) {
        transform = transform.scaledBy(x: x, y: y)
    }

    /// 旋转的角度, 弧度
    func rotateTo(angle: CGFloat = 0) {
        transform = CGAffineTransform(rotationAngle: angle)
    }

    func rotate(angle: CGFloat = 0) {
        transform = transform.concatenating(CGAffineTransform(rotationAngle: angle))
    }

    func rotateBy(angle: CGFloat = 0) {
        transform = transform.rotated(by: angle)
    }

    //MARK: 动画扩展

    var transformX: CGFloat {
        get {
            transform.tx
        }
    }

    var transformY: CGFloat {
        get {
            transform.ty
        }
    }

    var scaleX: CGFloat {
        get {
            transform.a
        }
    }

    var scaleY: CGFloat {
        get {
            transform.d
        }
    }

    /// 已经旋转的弧度
    var rotate: CGFloat {
        get {
            var rotate: CGFloat = acosf(transform.a.toFloat()).toCGFloat()
            // 旋转180度后，需要处理弧度的变化
            if (transform.b < 0) {
                rotate = .pi * 2 - rotate
            }
            return rotate
        }
    }

    /// 回调
    func translationTo(x: CGFloat? = nil, y: CGFloat? = nil,
                       minX: CGFloat = 0, maxX: CGFloat = 0,
                       minY: CGFloat = 0, maxY: CGFloat = 0,
                       callback: ((_ x: CGFloat, _ y: CGFloat) -> Void)? = nil) {

        if let x = x, let y = y {
            //同时移动x和y
            let _x = x.clamp(minX, maxX)
            let _y = y.clamp(minY, maxY)

            translationTo(x: _x, y: _y)
        } else if let x = x {
            //只移动x
            let _x = x.clamp(minX, maxX)
            let _y = transform.ty

            translationTo(x: _x, y: _y)
        } else if let y = y {
            //只移动y
            let _x = transform.tx
            let _y = y.clamp(minY, maxY)

            translationTo(x: _x, y: _y)
        }
        callback?(transform.tx, transform.ty)
    }
}