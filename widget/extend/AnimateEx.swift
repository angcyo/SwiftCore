//
// Created by angcyo on 21/08/05.
//

import Foundation
import UIKit

/// 将控件的操作放在动画中执行, 相当于Android的transition [duration]秒
func animate(_ duration: TimeInterval = TimeInterval(0.3), _ animations: @escaping () -> Void) {
    UIView.animate(withDuration: duration, animations: animations)
}

extension UIView {

    /// 平移到指定坐标
    func translation(x: Float = 0, y: Float = 0) {
        transform = CGAffineTransform(translationX: CGFloat(x), y: CGFloat(y))
    }

    func translationBy(x: Float = 0, y: Float = 0) {
        transform = transform.translatedBy(x: CGFloat(x), y: CGFloat(y))
    }

    /// 缩放
    func scale(x: Float = 1, y: Float = 1) {
        transform = CGAffineTransform(scaleX: CGFloat(x), y: CGFloat(y))
    }

    func scaledBy(x: Float = 0, y: Float = 0) {
        transform = transform.scaledBy(x: CGFloat(x), y: CGFloat(y))
    }

    /// 旋转的角度, 弧度
    func rotate(angle: Float = 0) {
        transform = CGAffineTransform(rotationAngle: CGFloat(angle))
    }

    func rotateBy(angle: Float = 0) {
        transform = transform.rotated(by: CGFloat(angle))
    }
}