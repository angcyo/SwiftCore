//
// Created by angcyo on 21/09/08.
//

import Foundation
import UIKit

/// 值动画, 从一个值, 在指定时间内, 到另一个值的动画回调

class ValueAnimation: NSObject {

    public var fpsChanged: ((Int) -> Void)? = {
        L.w("fps:\($0)")
    }

    lazy var displayLink: CADisplayLink? = CADisplayLink(target: self, selector: #selector(tick(_:)))

    /// 开始的时间 秒
    var _startTime: TimeInterval = 0

    override init() {
        super.init()

        //57465.888478875015
        _startTime = CACurrentMediaTime()
        displayLink?.preferredFramesPerSecond = 0 //自动选择
        displayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }

    deinit {
        stop()
    }

    private func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    //秒
    private var lastTimestamp: TimeInterval?

    ///计算fps
    private func fps(_ link: CADisplayLink) {
        guard let lastTimestamp = lastTimestamp else {
            lastTimestamp = link.timestamp
            return
        }
        let dif = link.timestamp - lastTimestamp
        guard dif > 0 else {
            return
        }
        self.lastTimestamp = link.timestamp
        let fps = Int(1 / dif)
        fpsChanged?(fps)
    }

    /// 动画执行时长, 秒
    var animationDuration: TimeInterval = 0.3

    /// 动画开始的值
    var animationFrom: CGFloat = 0

    /// 动画结束的值
    var animationTo: CGFloat = 0

    /// 动画当前的值
    var animationValue: CGFloat = 0

    /// 动画进度比例 [0~1]
    var animationFactor: CGFloat = 0

    /// 差值器
    var animationInterpolator: Interpolator? = LinearInterpolator()

    /// 动画值更新的回调
    var onAnimationUpdate: ((ValueAnimation) -> Void)? = nil

    @objc private func tick(_ link: CADisplayLink) {
        fps(link)

        // 执行消耗的时长 57426.667677541678
        let elapsed = link.timestamp - _startTime

        if elapsed >= animationDuration {
            //动画时间到了
            animationFactor = 1
            animationValue = animationTo
            stop()
        } else {
            animationFactor = CGFloat(elapsed / animationDuration)
            animationValue = animationFrom + (animationTo - animationFrom) * animationFactor
        }

        //差值器
        if let interpolator = animationInterpolator {
            let animationFactor = interpolator.getInterpolation(input: animationFactor)
            animationValue = animationFrom + (animationTo - animationFrom) * animationFactor
        }

        onAnimationUpdate?(self)
    }
}

/// 值动画
/// [duration] 秒
@discardableResult
func valueAnimation(from: CGFloat = 0, to: CGFloat = 1,
                    duration: TimeInterval = 0.3, onUpdate: @escaping (ValueAnimation) -> Void) -> ValueAnimation {
    let animation = ValueAnimation()
    animation.animationFrom = from
    animation.animationTo = to
    animation.animationDuration = duration
    animation.onAnimationUpdate = onUpdate
    return animation
}