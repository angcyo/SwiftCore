//
// Created by wayto on 2021/7/29.
//

import Foundation
import UIKit

class TargetObserver: NSObject, UIGestureRecognizerDelegate {

    /// 是否要忽略当前的UIGestureRecognizer
    static func ignoreTouch(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //手势附加的view
        let gestureView = gestureRecognizer.view

        //正在touch的view
        let touchView = touch.view

        if touch.tapCount == 1 && gestureView != touchView {
            if let touchView = touchView {
                if touchView is UIControl && touchView.isUserInteractionEnabled {
                    //UIControl
                    return false
                }
                if let gestureRecognizers = touchView.gestureRecognizers {
                    let find = gestureRecognizers.find {
                        $0 is UITapGestureRecognizer
                    }
                    if find != nil {
                        //具有点击手势
                        return false
                    }
                }
            }
        }
        return true
    }

    /// dsl
    var onAction: ((UIResponder) -> Void)? = nil

    /// 回调
    @objc func onActionInner(sender: UIResponder) {
        L.d("onActionInner:\(sender)")
        onAction?(sender)
    }

    deinit {
        L.w("\(threadName())->销毁:\(self)")
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        TargetObserver.ignoreTouch(gestureRecognizer, shouldReceive: touch)
    }
}

/// 获取一个角度UIBezierPath
func roundPath(bounds: CGRect,
               topLeft: Bool = true,
               topRight: Bool = true,
               bottomLeft: Bool = true,
               bottomRight: Bool = true,
               widthRadii: Float = Res.size.roundNormal,
               heightRadii: Float = Res.size.roundNormal) -> UIBezierPath {
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

    let maskPath = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: CGFloat(widthRadii), height: CGFloat(heightRadii)))
    return maskPath
}

// MARK: - 控件属性/方法扩展

extension UIView {

    ///key hold ViewName
    static var KEY_VIEW_NAME = "s_key_view_name"

    ///hold 点击事件
    static var KEY_ON_CLICK = "s_key_on_click"

    ///控件的名字, 可以用来查找控件
    var viewName: String? {
        get {
            getObject(&UIView.KEY_VIEW_NAME) as? String
        }
        set {
            setObject(&UIView.KEY_VIEW_NAME, newValue)
        }
    }

    func hide(_ bool: Bool = true) {
        isHidden = bool
    }

    func show(_ bool: Bool = true) {
        hide(!bool)
    }

    /// 将UIVIew转换成UIImage UIView截图
    func toImage() -> UIImage? {
        let size = bounds.size
        //如果图片需要有透明通道, 则opaque设置为false,否则true
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        defer {
            UIGraphicsEndImageContext()
        }
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
            result = find(condition)
            if result != nil {
                break
            }
        }
        return result
    }

    func find(_ name: String) -> UIView? {
        find { view in
            view.viewName == name
        }
    }

    func v<T: UIView>(_ id: Int) -> T? {
        viewWithTag(id) as? T
    }

    func v<T: UIView>(_ name: String) -> T? {
        find(name) as? T
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
    func setRadius(_ radius: Float = Res.size.roundNormal) {
        layer.cornerRadius = CGFloat(radius)
        clipsToBounds = true
    }

    func setRadiusBorder(_ radius: Float = Res.size.roundNormal,
                         borderColor: UIColor? = Res.color.colorAccent,
                         borderWidth: Float = Res.size.line) {
        layer.cornerRadius = CGFloat(radius)
        layer.masksToBounds = true
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = CGFloat(borderWidth)
    }

    /// 单独设置4个角的圆角
    func setRound(_ radii: Float = Res.size.roundNormal,
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

            let r = CGFloat(radii)
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: r, height: r))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = maskPath.cgPath
            layer.mask = maskLayer
        }
    }

    func setRoundTop(_ radii: Float = Res.size.roundNormal) {
        setRound(radii, topLeft: true, topRight: true, bottomLeft: false, bottomRight: false)
    }

    func setRoundBottom(_ radii: Float = Res.size.roundNormal) {
        setRound(radii, topLeft: false, topRight: false, bottomLeft: true, bottomRight: true)
    }

    func setRoundLeft(_ radii: Float = Res.size.roundNormal) {
        setRound(radii, topLeft: true, topRight: false, bottomLeft: true, bottomRight: false)
    }

    func setRoundRight(_ radii: Float = Res.size.roundNormal) {
        setRound(radii, topLeft: false, topRight: true, bottomLeft: false, bottomRight: true)
    }


    /// 快速监听事件
    /// 返回对象需要保存起来, 否则会被ARC回收, 导致回调不了
    /// - Parameters:
    ///   - controlEvents:
    ///   - action:
    /// - Returns:
    @discardableResult
    func onClick(_ controlEvents: UIControl.Event = .touchUpInside, _ action: @escaping (UIResponder) -> Void) -> Any {
        let observer = TargetObserver()
        observer.onAction = action

        //self.isUserInteractionEnabled = true

        let old = getObject(&UIView.KEY_ON_CLICK)

        if self is UIControl {
            let control = (self as! UIControl)
            if let old = old as? TargetObserver {
                control.removeTarget(old,
                        action: #selector(TargetObserver.onActionInner(sender:)),
                        for: controlEvents)
            }
            control.addTarget(observer,
                    action: #selector(TargetObserver.onActionInner(sender:)),
                    for: controlEvents)
            setObject(&UIView.KEY_ON_CLICK, observer)
            return observer
        } else {
            if let old = old as? UITapGestureRecognizer {
                removeGestureRecognizer(old)
            }

            let gesture = UITapGestureRecognizer(target: observer,
                    action: #selector(TargetObserver.onActionInner(sender:)))

            gesture.setObject(&UIView.KEY_ON_CLICK, observer)

            gesture.delegate = observer
            // 点击一次
            gesture.numberOfTapsRequired = 1
            // 一个手指
            gesture.numberOfTouchesRequired = 1

            //需要交互
            isUserInteractionEnabled = true
            //添加手势
            addGestureRecognizer(gesture)

            setObject(&UIView.KEY_ON_CLICK, gesture)
            return gesture
        }
    }

    /// 设置边框
    func setBorder(_ strokeColor: UIColor = Res.color.colorAccent,
                   radii: Float = Res.size.roundNormal,
                   lineWidth: Float = Res.size.line,
                   fillColor: UIColor = UIColor.clear) {
        if bounds.isEmpty {
            doMain { [self] in
                setBorder(strokeColor, radii: radii, lineWidth: lineWidth, fillColor: fillColor)
            }
        } else {
            let roundPath = roundPath(bounds: bounds, widthRadii: radii, heightRadii: radii)
            setBorder(strokeColor, radii: radii, lineWidth: lineWidth, fillColor: fillColor, path: roundPath.cgPath)
        }
    }

    func setBorder(_ strokeColor: UIColor = Res.color.colorAccent,
                   radii: Float = Res.size.roundNormal,
                   lineWidth: Float = Res.size.line,
                   fillColor: UIColor = UIColor.clear,
                   path: CGPath) {
        if bounds.isEmpty {
            doMain { [self] in
                setBorder(strokeColor, radii: radii, lineWidth: lineWidth, fillColor: fillColor, path: path)
            }
        } else {
            let borderLayer = CAShapeLayer()
            borderLayer.frame = bounds;
            borderLayer.path = path;
            borderLayer.lineWidth = CGFloat(lineWidth);
            borderLayer.fillColor = fillColor.cgColor;
            borderLayer.strokeColor = strokeColor.cgColor;
            //layer.mask = borderLayer
            layer.addSublayer(borderLayer)
        }
    }

    /// 设置阴影
    func shadow(_ color: UIColor = Res.color.shadowColor, radius: Float = 5, size: CGSize = CGSize(width: 0, height: 2)) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = size
        layer.shadowOpacity = 0.4;
        layer.shadowRadius = CGFloat(radius)
        layer.masksToBounds = false

        //layer.shadowColor = UIColor.black.cgColor
        //layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        //layer.shadowRadius = 6.0
        //layer.shadowOpacity = 0.4
        //layer.masksToBounds = false
    }

    /// 查找VC
    func findParentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

//MARK: - 控件布局扩展

extension UIView {
    func removeAllView() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}

/// 获取一个渐变 图层
func gradientLayer(frame: CGRect,
                   colors: [Any]? = [Res.color.colorPrimary, Res.color.colorPrimaryDark]) -> CAGradientLayer {
    let layer = CAGradientLayer()

    layer.frame = frame
    layer.colors = colors

    //layer.cornerRadius

    //layer.locations = []

    layer.startPoint = CGPoint(x: 0, y: 0)
    layer.endPoint = CGPoint(x: 1, y: 1)

    return layer

    //    CAGradientLayer *graLayer = [CAGradientLayer layer];
    //    graLayer.frame = CGRectMake(100, 100, 200, 200);
    //    graLayer.colors = @[
    //        (__bridge id)[UIColor redColor].CGColor,
    //    (__bridge id)[UIColor yellowColor].CGColor
    //    ];
    ////    graLayer.locations = @[@0, @0.2];
    //    graLayer.startPoint = CGPointMake(0, 0);
    //    graLayer.endPoint = CGPointMake(1, 1);
}

func emptyView(width: Float = Float.min, height: Float = Float.min) -> UIView {
    let view = v()
    view.frame = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
    return view
}

func view(_ color: Any? = nil) -> UIView {
    v(color)
}

func v(_ color: Any? = nil) -> UIView {
    let view = UIView()
    //view.backgroundColor = UIColor()
    view.setBackground(color)
    return view
}

/// 线, 宽高需要手动设置
func lineView(_ color: UIColor = Res.color.line) -> UIView {
    let view = v()
    view.setBackground(color)
    return view
}

/// 横线, 宽度需要手动约束
func hLine(height: Float = Res.size.line, color: UIColor = Res.color.line) -> UIView {
    let view = v()
    view.makeHeight(height)
    view.setBackground(color)
    return view
}

/// 竖线, 高度需要手动约束
func vLine(width: Float = Res.size.line, color: UIColor = Res.color.line) -> UIView {
    let view = v()
    view.makeWidth()
    view.setBackground(color)
    return view
}