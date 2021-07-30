//
// Created by wayto on 2021/7/29.
//

import Foundation
import UIKit

class TargetObserver {
    /// dsl
    var onAction: (() -> Void)? = nil

    /// 回调
    @objc func onActionInner(sender: UIView) {
        onAction?()
    }
}

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
    func setRadius(_ radius: Float) {
        layer.cornerRadius = CGFloat(radius)
    }

    /// 单独设置4个角的圆角
    func setRound(_ radii: CGFloat,
                  topLeft: Bool = true, topRight: Bool = true,
                  bottomLeft: Bool = true, bottomRight: Bool = true) {
        if bounds.isEmpty {
            doMain { [self] in
                setRound(radii, topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
            }
        } else {
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
    }

    func setRoundTop(_ radii: CGFloat) {
        setRound(radii, topLeft: true, topRight: true, bottomLeft: false, bottomRight: false)
    }

    func setRoundBottom(_ radii: CGFloat) {
        setRound(radii, topLeft: false, topRight: false, bottomLeft: true, bottomRight: true)
    }

    func setRoundLeft(_ radii: CGFloat) {
        setRound(radii, topLeft: true, topRight: false, bottomLeft: true, bottomRight: false)
    }

    func setRoundRight(_ radii: CGFloat) {
        setRound(radii, topLeft: false, topRight: true, bottomLeft: false, bottomRight: true)
    }


    /// 快速监听事件
    /// 返回对象需要保存起来, 否则会被ARC回收, 导致回调不了
    /// - Parameters:
    ///   - controlEvents:
    ///   - action:
    /// - Returns:
    func onClick(_ controlEvents: UIControl.Event = .touchUpInside, _ action: @escaping () -> Void) -> Any {
        let observer = TargetObserver()
        observer.onAction = action

        //self.isUserInteractionEnabled = true

        if self is UIControl {
            (self as! UIControl).addTarget(observer,
                    action: #selector(TargetObserver.onActionInner(sender:)),
                    for: controlEvents)
            return observer
        } else {
            let gesture = UITapGestureRecognizer(target: observer,
                    action: #selector(TargetObserver.onActionInner(sender:)))

            // 点击一次
            gesture.numberOfTapsRequired = 1
            // 一个手指
            gesture.numberOfTouchesRequired = 1

            //需要交互
            isUserInteractionEnabled = true
            //添加手势
            addGestureRecognizer(gesture)

            return gesture
        }
    }
}

func v(_ color: Any? = nil) -> UIView {
    let view = UIView()
    //view.backgroundColor = UIColor()
    view.setBackground(color)
    return view
}

/// 横线, 宽度需要手动约束
func hLine(height: Float = Res.Size.line, color: UIColor = Res.Color.line) -> UIView {
    let view = v()
    view.makeHeight(height)
    view.setBackground(color)
    return view
}

/// 竖线, 高度需要手动约束
func vLine(width: Float = Res.Size.line, color: UIColor = Res.Color.line) -> UIView {
    let view = v()
    view.makeWidth()
    view.setBackground(color)
    return view
}