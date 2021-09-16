//
// Created by angcyo on 21/09/16.
//

import Foundation
import UIKit

/// 平分subview
class CheckGroupView: BaseUIView {

    /// 横线间隙
    var horizontalSpace: CGFloat = Res.size.leftMargin

    var subMinHeight: CGFloat = Res.size.minHeight

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)

        if let view = subview as? UIControl {
            view.addTarget(self, action: #selector(onClickView), for: .touchUpInside)
        } else {
            L.w("子view需要继承自UIControl")
        }
    }

    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        if let view = subview as? UIControl {
            view.removeAllTarget(self)
        }
    }

    override func onMeasureAndLayout(_ size: CGSize) -> CGSize {
        var left: CGFloat = 0
        var top: CGFloat = 0

        var maxWidth: CGFloat
        if frame.width == 0 {
            maxWidth = superview?.frame.width ?? UIScreen.width
        } else {
            maxWidth = frame.width
        }

        var maxHeight: CGFloat = 0

        let subWidth = max((maxWidth - (childCount - 1).toCGFloat() * horizontalSpace) / childCount.toCGFloat(), 0).toFloorf()
        subviews.forEach {
            let size = cgSize(subWidth, 0)
            let fitsSize = $0.sizeThatFits(size)

            let height = max(subMinHeight, fitsSize.height)
            $0.frame = cgRect(x: left, y: top, width: subWidth, height: height)
            left += subWidth + horizontalSpace

            maxHeight = max(maxHeight, height)
        }

        return cgSize(maxWidth, maxHeight)
    }

    /// 选中的item
    var selectIndex: Int {
        get {
            var result = -1
            eachChildIndex {
                if let control = $0 as? UIControl {
                    if control.isSelected {
                        result = $1
                    }
                }
            }
            return result
        }
        set {
            if let control = subviews.get(newValue) as? UIControl {
                selectedView(control)
            }
        }
    }

    /// 取消其他选中
    func deselectView() {
        eachChild {
            if let control = $0 as? UIControl {
                control.isSelected = false
            }
        }
    }

    /// 选中回调
    var onSelectedView: ((UIControl) -> Void)? = nil

    func selectedView(_ view: UIControl) {
        if view.isEnabled && canSelectedView(view) {
            deselectView()
            view.isSelected = true

            onSelectedView?(view)
        }
    }

    func canSelectedView(_ view: UIControl) -> Bool {
        true
    }

    /// 点击事件
    @objc func onClickView(_ sender: UIControl) {
        selectedView(sender)
    }
}