//
// Created by wayto on 2021/7/29.
//

import Foundation
import UIKit

extension UIView {

    /**将UIVIew转换成UIImage*/
    func toImage() -> UIImage? {
        let size = bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 通过id查找控件
    func find(_ id: Int) -> UIView? {
        viewWithTag(id)
    }

    /// 通过条件, 查找指定控件
    func find(_ condition: (UIView) -> Bool) -> UIView? {
        var result: UIView? = nil
        for view in subviews {
            if condition(view) {
                result = view
                break
            }
        }
        return result
    }

    func find(_ name: String) -> UIView? {
        find(name.hashValue)
    }

    func v<T: UIView>(_ id: Int) -> T? {
        viewWithTag(id) as? T
    }

    func v<T: UIView>(_ name: String) -> T? {
        v(name.hashValue)
    }

    /// 设置id
    func setId(_ id: Int) {
        tag = id
    }

    func setId(_ name: String) {
        tag = name.hashValue
    }

    /// 设置背景图片
    func setBgImage(_ image: UIImage?) {
        //        if image == nil {
        //            backgroundColor = nil
        //        }else{
        //            //平铺, 不拉伸, 也不缩放
        //            backgroundColor = UIColor(patternImage: image!)
        //        }

        layer.contents = image?.cgImage
    }

    /// 设置背景颜色或图片
    ///
    /// - Parameter color: 支持UIColor , 支持 hex, 支持UIImage
    func setBackground(_ color: Any?) {
        if color == nil {
            //clear
            if self is UIStackView {
                let stackView = self as! UIStackView
                var bgViews: [UIView] = []
                stackView.subviews.forEach { body in
                    if body is UIBgView {
                        bgViews.append(body)
                    }
                }
                bgViews.forEach { bgView in
                    bgView.removeFromSuperview()
                }
            } else {
                //清除的时候, 只能清除背景颜色
                backgroundColor = nil
            }
        } else {
            //set
            let targetView: UIView
            if self is UIStackView {
                targetView = self.find { body in
                    body is UIBgView
                } ?? UIBgView(frame: bounds).apply { view in
                    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    insertSubview(view, at: 0)
                }
            } else {
                targetView = self
            }

            // op
            if color is UIColor {
                targetView.backgroundColor = color as! UIColor
            } else if color is String {
                targetView.backgroundColor = UIColor.parse(color as! String)
            } else if color is UIImage {
                targetView.setBgImage(color as! UIImage)
            }
        }
    }

    /// 同时设置4个角的圆角
    func setRadius(_ radius: Double) {
        layer.cornerRadius = CGFloat(radius)
    }

    /// 单独设置4个角的圆角
    func setRound(_ radii: CGFloat, topLeft: Bool = false, topRight: Bool = false,
                  bottomLeft: Bool = false, bottomRight: Bool = false) {
        var corners: UIRectCorner = []
        if topLeft {
            corners.insert(UIRectCorner.topLeft)
        }
        if topRight {
            corners.insert(UIRectCorner.topRight)
        }
        if bottomLeft {
            corners.insert(UIRectCorner.bottomLeft)
        }
        if bottomRight {
            corners.insert(UIRectCorner.bottomRight)
        }

        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }

    func setRoundTop(_ radii: CGFloat) {
        setRound(radii, topLeft: true, topRight: true)
    }

    func setRoundBottom(_ radii: CGFloat) {
        setRound(radii, bottomLeft: true, bottomRight: true)
    }

    func setRoundLeft(_ radii: CGFloat) {
        setRound(radii, topLeft: true, bottomLeft: true)
    }

    func setRoundRight(_ radii: CGFloat) {
        setRound(radii, topRight: true, bottomRight: true)
    }
}

func v() -> UIView {
    let view = UIView()
    //view.backgroundColor = UIColor()
    return view
}