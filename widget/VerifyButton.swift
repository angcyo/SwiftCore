//
// Created by angcyo on 21/08/29.
//

import Foundation
import UIKit

/// 获取验证码的按钮

class VerifyButton: UIButton {

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
        setText("获取验证码")
        setTextColor(Res.color.colorAccent)
        titleLabel?.setTextSize(Res.text.normal.size)

        backgroundColor = UIColor.clear
        layer.cornerRadius = Res.size.roundLittle
        clipsToBounds = true

        layer.borderColor = Res.color.colorAccent.cgColor
        layer.borderWidth = Res.size.line

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
}