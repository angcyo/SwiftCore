//
// Created by wayto on 2021/7/29.
//

import Foundation
import UIKit

/// https://blog.csdn.net/u013406800/article/details/103859529
/// setContentCompressionResistancePriority 压缩优先级 值越小, 优先被压缩
/// setContentHuggingPriority 拉伸优先级 值越小, 优先被拉伸
/// https://blog.csdn.net/x567851326/article/details/51513212

extension UIView {

    /// 不拉伸, 阻止自己变大
    func lowStretch(for axis: NSLayoutConstraint.Axis = .horizontal) {
        setContentHuggingPriority(.required, for: axis)
    }

    /// 优先拉伸
    func highStretch(for axis: NSLayoutConstraint.Axis = .horizontal) {
        setContentHuggingPriority(.defaultLow, for: axis)
    }

    /// 不压缩, 阻止自己变小
    func lowCompression(for axis: NSLayoutConstraint.Axis = .horizontal) {
        setContentCompressionResistancePriority(.required, for: axis)
    }

    /// 优先压缩
    func highCompression(for axis: NSLayoutConstraint.Axis = .horizontal) {
        setContentCompressionResistancePriority(.defaultLow, for: axis)
    }
}

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
               widthRadii: CGFloat = Res.size.roundNormal,
               heightRadii: CGFloat = Res.size.roundNormal) -> UIBezierPath {
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
            cornerRadii: CGSize(width: widthRadii, height: heightRadii))
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

    /// 无内容
    func isNoContent() -> Bool {
        if let label = self as? UILabel {
            return isHidden || nilOrEmpty(label.text)
        } else if let text = self as? UITextField {
            return isHidden || nilOrEmpty(text.text)
        } else if let text = self as? UITextView {
            return isHidden || nilOrEmpty(text.text)
        } else {
            return isHidden
        }
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

    func eachChild(_ action: (UIView) -> Void) {
        for view in subviews {
            action(view)
        }
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

    /// 设置可见性
    func setVisible(_ visible: Bool = true) {
        isHidden = !visible
    }

    func setHidden(_ hidden: Bool = true) {
        isHidden = hidden
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
    func setRadius(_ radius: CGFloat = Res.size.roundNormal) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }

    func setRadiusBorder(_ radius: CGFloat = Res.size.roundNormal,
                         borderColor: UIColor? = Res.color.colorAccent,
                         borderWidth: CGFloat = Res.size.line) {
        layer.cornerRadius = CGFloat(radius)
        layer.masksToBounds = true
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = CGFloat(borderWidth)
    }

    /// 单独设置4个角的圆角
    func setRound(_ radii: CGFloat = Res.size.roundNormal,
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

            let r = radii
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: r, height: r))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = maskPath.cgPath
            layer.mask = maskLayer
        }
    }

    func setRoundTop(_ radii: CGFloat = Res.size.roundNormal) {
        setRound(radii, topLeft: true, topRight: true, bottomLeft: false, bottomRight: false)
    }

    func setRoundBottom(_ radii: CGFloat = Res.size.roundNormal) {
        setRound(radii, topLeft: false, topRight: false, bottomLeft: true, bottomRight: true)
    }

    func setRoundLeft(_ radii: CGFloat = Res.size.roundNormal) {
        setRound(radii, topLeft: true, topRight: false, bottomLeft: true, bottomRight: false)
    }

    func setRoundRight(_ radii: CGFloat = Res.size.roundNormal) {
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

    /// 切成圆
    func setCircle() {
        waitBounds {
            let radius = max(self.bounds.width, self.bounds.height) / 2
            self.setRadius(radius)
        }
    }

    /// 设置圆形边框
    func setCircleBorder(_ strokeColor: UIColor = Res.color.colorAccent,
                         lineWidth: CGFloat = Res.size.line * 2,
                         fillColor: UIColor = UIColor.clear) {
        waitBounds {
            let radius = max(self.bounds.width, self.bounds.height) / 2
            self.setRadius(radius)
            self.setBorder(strokeColor, radii: radius, lineWidth: lineWidth, fillColor: fillColor)
        }
    }

    /// 设置边框
    func setBorder(_ strokeColor: UIColor = Res.color.colorAccent,
                   radii: CGFloat = Res.size.roundNormal,
                   lineWidth: CGFloat = Res.size.line,
                   fillColor: UIColor = UIColor.clear) {
        if bounds.isEmpty {
            doMain { [self] in
                setBorder(strokeColor, radii: radii, lineWidth: lineWidth, fillColor: fillColor)
            }
        } else {
            let roundPath = roundPath(bounds: bounds, widthRadii: radii, heightRadii: radii)
            setBorder(strokeColor, lineWidth: lineWidth, fillColor: fillColor, path: roundPath.cgPath)
        }
    }

    func setBorder(_ strokeColor: UIColor = Res.color.colorAccent,
                   lineWidth: CGFloat = Res.size.line,
                   fillColor: UIColor = UIColor.clear,
                   path: CGPath) {
        if bounds.isEmpty {
            doMain { [self] in
                setBorder(strokeColor, lineWidth: lineWidth, fillColor: fillColor, path: path)
            }
        } else {
            removeLayer(CAShapeLayer.self)
            let borderLayer = CAShapeLayer()
            borderLayer.frame = bounds;
            borderLayer.path = path;
            borderLayer.lineWidth = lineWidth;
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

    /// 等到视图bound准备完成
    func waitBounds(_ action: @escaping () -> Void) {
        if bounds.isEmpty {
            doMain {
                self.waitBounds(action)
            }
        } else {
            action()
        }
    }

    /// 获取第一响应者, 向下查找
    func findFirstResponder() -> UIView? {
        if isFirstResponder {
            return self
        }

        for subview in subviews {
            let firstResponder = subview.findFirstResponder()
            if (firstResponder != nil) {
                return firstResponder
            }
        }

        return nil;
    }

    /// 向上查找 UITableViewCell
    func findAttachedTableCell() -> UITableViewCell? {
        if self is UITableViewCell {
            return self as! UITableViewCell
        }

        if let superview = superview {
            let cell = superview.findAttachedTableCell()
            if (cell != nil) {
                return cell
            }
            return superview.findAttachedTableCell()
        }

        return nil;
    }

    /// 向上查找 UICollectionViewCell
    func findAttachedCollectionCell() -> UICollectionViewCell? {
        if self is UICollectionViewCell {
            return self as! UICollectionViewCell
        }

        if let superview = superview {
            let cell = superview.findAttachedCollectionCell()
            if (cell != nil) {
                return cell
            }
            return superview.findAttachedCollectionCell()
        }

        return nil;
    }

    /// 向上查找 UITableView

    func findAttachedTableView() -> UITableView? {
        if self is UITableView {
            return self as! UITableView
        }

        if let superview = superview {
            let view = superview.findAttachedTableView()
            if (view != nil) {
                return view
            }
            return superview.findAttachedTableView()
        }

        return nil;
    }

    /// 向上查找 UICollectionView

    func findAttachedCollectionView() -> UICollectionView? {
        if self is UICollectionView {
            return self as! UICollectionView
        }

        if let superview = superview {
            let view = superview.findAttachedCollectionView()
            if (view != nil) {
                return view
            }
            return superview.findAttachedCollectionView()
        }

        return nil;
    }
}

//MARK: - 控件布局扩展

extension UIView {

    var width: CGFloat {
        get {
            bounds.width
        }
    }

    var height: CGFloat {
        get {
            bounds.height
        }
    }

    /// 返回视图计算后的内容大小 [ignoreHidden]是否忽略视图隐藏, 不忽略则隐藏后size为0
    func sizeOf(_ targetSize: CGSize? = nil, offsetWidth: CGFloat = 0, offsetHeight: CGFloat = 0, ignoreHidden: Bool = false) -> CGSize {
        let targetSize = targetSize ?? cgSize(CGFloat.max, CGFloat.max)
        var size: CGSize

        if isHidden && !ignoreHidden {
            size = .zero
        } else {
            size = sizeThatFits(targetSize)
        }

        size.width += offsetWidth
        size.height += offsetHeight

        return size
    }

    func removeView(_ viewClass: AnyClass) {
        for view in subviews.reversed() {
            if view.isEqualClassName(viewClass) {
                view.removeFromSuperview()
            }
        }
    }

    /// 移除所有view
    func removeAllView() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }

    /// 清除所有的手势识别器
    func clearGestureRecognizers() {
        while !nilOrEmpty(gestureRecognizers) {
            if let gestureRecognizers = gestureRecognizers {
                if let gesture = gestureRecognizers.get(0) {
                    gesture.isEnabled = false
                    removeGestureRecognizer(gesture)
                }
            }
        }
    }

    func removeLayer(_ layerClass: AnyClass) {
        layer.sublayers?.removeAll {
            $0.isEqualClassName(layerClass)
        }
    }

    func removeAllLayer() {
        while !nilOrEmpty(layer.sublayers) {
            if let sublayers = layer.sublayers {
                if let layer = sublayers.get(0) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }

    /// 将当前的view, 移动到兄弟视图的前面
    func toFront() {
        superview?.bringSubviewToFront(self)
    }

    /// 将当前的view, 移动到兄弟视图的后面
    func toBack() {
        superview?.sendSubviewToBack(self)
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

func sizeView(_ color: Any? = nil, size: CGFloat? = nil) -> UIView {
    let view = v(color)
    if let size = size {
        view.frame = rect(size, size)
    }
    return view
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
func hLine(height: CGFloat = Res.size.line, color: UIColor = Res.color.line) -> UIView {
    let view = v()
    view.makeHeight(height)
    view.setBackground(color)
    return view
}

/// 竖线, 高度需要手动约束
func vLine(width: CGFloat = Res.size.line, color: UIColor = Res.color.line) -> UIView {
    let view = v()
    view.makeWidth()
    view.setBackground(color)
    return view
}