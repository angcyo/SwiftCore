//
// Created by angcyo on 21/09/03.
//

import Foundation
import UIKit
import RxSwift

/// 基类

open class BaseUIView: UIView {

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        initView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    open func initView() {
        //
    }

    /// 自身内容大小, 动态计算
    var contentSize: CGSize = .zero {
        didSet {
            if contentSize.width != oldValue.width || contentSize.height != oldValue.height {
                invalidateIntrinsicContentSize()
                setNeedsUpdateConstraints()
            }
        }
    }

    //Auto Layout 自身的大小
    open override var intrinsicContentSize: CGSize {
        contentSize = onMeasureAndLayout(super.intrinsicContentSize)
        return contentSize
    }

    //通知布局系统, 需要自身的大小改变了
    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
    }

    open override func sizeToFit() {
        super.sizeToFit()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        //super.sizeThatFits(size)
        //cgSize(max(size.width, contentSize.width), max(size.height, contentSize.height))
        onMeasureAndLayout(size)
    }

    /// 开始布局
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentSize = onMeasureAndLayout(bounds.size)
    }

    /// 测量和布局
    func onMeasureAndLayout(_ size: CGSize) -> CGSize {
        size
    }

    //MARK: cell 中自适应

    open override func updateConstraints() {
        super.updateConstraints()
    }

    open override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize)
        return size
    }

    open override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        return size
    }

    //MARK: add remove

    open override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
    }

    open override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
    }

    //MARK: rx

    /// 手势订阅
    lazy var gestureDisposeBag: DisposeBag = {
        DisposeBag()
    }()

    func resetGesture() {
        gestureDisposeBag = DisposeBag()
    }

    //MARK: draw

    open override func draw(_ rect: CGRect, for formatter: UIViewPrintFormatter) {
        super.draw(rect, for: formatter)
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    public override func draw(_ layer: CALayer, in ctx: CGContext) {
        super.draw(layer, in: ctx)
    }

    //MARK: touch

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }

    open override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        super.touchesEstimatedPropertiesUpdated(touches)
    }

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event)
    }

    //MARK: presses

    open override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesBegan(presses, with: event)
    }

    open override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesChanged(presses, with: event)
    }

    open override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesEnded(presses, with: event)
    }

    open override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesCancelled(presses, with: event)
    }

    //MARK: motion

    open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
    }

    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
    }

    open override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionCancelled(motion, with: event)
    }

}