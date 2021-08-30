//
// Created by angcyo on 21/08/29.
//

import Foundation
import UIKit

/// 获取验证码的按钮

class VerifyButton: UIButton {

    var defaultButtonText = "获取验证码"

    var defaultColor = Res.color.colorPrimary
    var disableColor = Res.color.disable

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        L.i("init:frame:\(frame)")
        initButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        L.i("init:coder:\(coder)")
        initButton()
    }

    func initButton() {
        setText(defaultButtonText)
        //setTextColor(Res.color.colorPrimary)
        titleLabel?.setTextSize(Res.text.tip.size)

        backgroundColor = UIColor.clear
        layer.cornerRadius = Res.size.roundLittle
        clipsToBounds = true

        layer.borderColor = defaultColor.cgColor
        layer.borderWidth = Res.size.line

        setPadding(Res.size.m)

        //color
        setTitleColor(defaultColor, for: .normal)
        setTitleColor(Res.color.colorPrimaryDark, for: .highlighted)
        setTitleColor(disableColor, for: .disabled)

        sizeToFit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        L.i("layoutSubviews:\(frame)")
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        L.i("layoutSublayers:\(frame)")
    }

    var _isStart = false

    func startCountDown() {
        if _isStart {
            return
        }

        dispatchTimer(timeInterval: 1, repeatCount: 60) { timer, count in
            if self._isStart {
                self._updateText(count)
                if count == 0 {
                    timer?.cancel()
                    self.stopCountDown()
                }
            } else {
                timer?.cancel()
            }
        }

        layer.borderColor = disableColor.cgColor

        isEnabled = false
        _isStart = true
    }

    func _updateText(_ count: Int) {
        setText("\(count)s")
    }

    func stopCountDown() {
        layer.borderColor = defaultColor.cgColor
        _isStart = false
        setText(defaultButtonText)
        isEnabled = true
    }
}