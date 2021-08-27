//
// Created by angcyo on 21/08/26.
//

import Foundation
import UIGradient
import UIKit

/// https://github.com/dqhieu/UIGradient
///
extension UIView {

    func initGradient(colors: [UIColor] = [Res.color.colorPrimary, Res.color.colorPrimaryDark], action: @escaping (GradientLayer) -> Void) {
        if bounds.isEmpty {
            doMain {
                self.initGradient(colors: colors, action: action)
            }
        } else {

            let gradientLayer = GradientLayer(direction: .leftToRight, colors: colors, cornerRadius: 0, locations: nil)
            let cloneGradient = gradientLayer.clone()
            cloneGradient.frame = bounds

            action(cloneGradient)
        }
    }

    /// 添加渐变, 不支持透明度颜色
    func addGradient(colors: [UIColor] = [Res.color.colorPrimary, Res.color.colorPrimaryDark]) {
        initGradient(colors: colors) {
            self.layer.insertSublayer($0, at: 0)
        }
    }
}

extension UIButton {
    func setTextGradient(colors: [UIColor] = [Res.color.colorPrimary, Res.color.colorPrimaryDark]) {
        initGradient(colors: colors) {
            self.titleLabel?.setTextColor(UIColor.fromGradient($0, frame: self.bounds))
        }
    }
}