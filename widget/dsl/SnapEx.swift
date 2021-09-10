//
// Created by wayto on 2021/7/29.
//

import Foundation
import SnapKit

/*
http://snapkit.io/docs/

ViewAttribute	NSLayoutAttribute
view.snp.left	NSLayoutConstraint.Attribute.left
view.snp.right	NSLayoutConstraint.Attribute.right
view.snp.top	NSLayoutConstraint.Attribute.top
view.snp.bottom	NSLayoutConstraint.Attribute.bottom
view.snp.leading	NSLayoutConstraint.Attribute.leading
view.snp.trailing	NSLayoutConstraint.Attribute.trailing
view.snp.width	NSLayoutConstraint.Attribute.width
view.snp.height	NSLayoutConstraint.Attribute.height
view.snp.centerX	NSLayoutConstraint.Attribute.centerX
view.snp.centerY	NSLayoutConstraint.Attribute.centerY
view.snp.lastBaseline	NSLayoutConstraint.Attribute.lastBaseline

 */

enum ConstraintTarget: ConstraintRelatableTarget {
    //父控件
    case PARENT
    //父控件中的最后一个控件, 排除自己
    case LAST
}

extension ConstraintOffsetTarget {
    /// 取负值
    func reverse() -> ConstraintOffsetTarget {
        let offset: CGFloat
        if let amount = self as? Float {
            offset = -CGFloat(amount)
        } else if let amount = self as? Double {
            offset = -CGFloat(amount)
        } else if let amount = self as? CGFloat {
            offset = -CGFloat(amount)
        } else if let amount = self as? Int {
            offset = -CGFloat(amount)
        } else if let amount = self as? UInt {
            offset = -CGFloat(amount)
        } else {
            return self
        }
        return offset
    }
}

// MARK: - 布局扩展, 需要库SnapKit支持 http://snapkit.io/docs/

extension UILayoutGuide {
    var snap: ConstraintLayoutGuideDSL {
        snp
    }
}

extension UIView {

    /// snp 智能提示太慢了, 换个名字
    var snap: ConstraintViewDSL {
        snp
    }

    /// snp dsl
    func make(_ closure: (_ make: ConstraintMaker) -> Void) {
        snap.makeConstraints(closure)
    }

    /// snp dsl
    func remake(_ closure: (_ make: ConstraintMaker) -> Void) {
        snap.remakeConstraints(closure)
    }

    func removeConstraints() {
        snap.removeConstraints()
    }

    func remakeView(_ closure: (_ view: UIView) -> Void) {
        snap.removeConstraints()
        closure(self)

        /*snp.remakeConstraints { _ in
            closure(self)
        }*/
    }

    /// snp dsl
    func updateMake(_ closure: (_ make: ConstraintMaker) -> Void) {
        snap.updateConstraints(closure)
    }

    /// 移除所有child的约束
    func clearChildMake() {
        eachChild {
            $0.snap.removeConstraints()
        }
    }

    /// 转换成约束目标
    func toConstraintTarget(_ parent: ConstraintRelatableTarget? = nil) -> ConstraintRelatableTarget {
        if parent is ConstraintTarget {
            switch parent as! ConstraintTarget {
            case .PARENT:
                return superview!
            case .LAST:
                let views: [UIView] = superview!.subviews.reversed()
                for view in views {
                    if view == self {
                        continue
                    }
                    return view
                }
            }
            return superview!
        } else {
            return parent ?? superview!
        }
    }

    func toConstraintTargetView(_ parent: ConstraintRelatableTarget? = nil) -> UIView {
        if parent is ConstraintTarget {
            switch parent as! ConstraintTarget {
            case .PARENT:
                return superview!
            case .LAST:
                let views: [UIView] = superview!.subviews.reversed()
                for view in views {
                    if view == self {
                        continue
                    }
                    return view
                }
            }
            return superview!
        } else if parent == nil {
            return superview!
        } else {
            return parent as! UIView
        }
    }

    func makeEdge(_ target: ConstraintRelatableTarget? = nil, inset: UIEdgeInsets? = nil,
                  priority: ConstraintPriority = .required) {
        make { maker in
            let target = target ?? superview!
            if let num = target as? CGFloat {
                makeEdge(left: num, right: num, top: num, bottom: num, priority: priority)
            } else if let inset = inset {
                maker.edges.equalTo(target).inset(inset).priority(priority)
            } else {
                maker.edges.equalTo(target).priority(priority)
            }
        }
    }

    func makeEdge(left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0,
                  priority: ConstraintPriority = .required) {
        make { maker in
            maker.edges.equalTo(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)).priority(priority)
        }
    }

    func makeEdgeHorizontal(size: CGFloat = 0, priority: ConstraintPriority = .required) {
        makeEdge(left: size, right: size, top: 0, bottom: 0, priority: priority)
    }

    func makeEdgeVertical(size: CGFloat = 0, priority: ConstraintPriority = .required) {
        makeEdge(left: 0, right: 0, top: size, bottom: size, priority: priority)
    }

    /// 约束宽度, 支持最大宽度, 最小宽度
    func makeWidth(_ width: ConstraintRelatableTarget? = nil,
                   minWidth: ConstraintRelatableTarget? = nil,
                   maxWidth: ConstraintRelatableTarget? = nil,
                   amount: ConstraintMultiplierTarget = 1) {
        make { maker in
            if let width = width {
                maker.width.equalTo(width).multipliedBy(amount)
            }
            if let min = minWidth {
                maker.width.greaterThanOrEqualTo(min).multipliedBy(amount)
            }
            if let max = maxWidth {
                maker.width.lessThanOrEqualTo(max).multipliedBy(amount)
            }
        }
    }

    /// 约束高度
    func makeHeight(_ height: ConstraintRelatableTarget? = nil,
                    minHeight: ConstraintRelatableTarget? = nil,
                    maxHeight: ConstraintRelatableTarget? = nil,
                    amount: ConstraintMultiplierTarget = 1) {
        make { maker in
            if let height = height {
                maker.height.equalTo(height).multipliedBy(amount)
            }
            if let min = minHeight {
                // 约束最小高度, >=min
                maker.height.greaterThanOrEqualTo(min).multipliedBy(amount)
            }
            if let max = maxHeight {
                // 约束最大高度, <=max
                maker.height.lessThanOrEqualTo(max).multipliedBy(amount)
            }
        }
    }

    func makeWidthHeight(size: ConstraintRelatableTarget, priority: ConstraintPriority = .required) {
        make { maker in
            maker.width.height.equalTo(size).priority(priority)
        }
    }

    /// 约束自身的宽高等于目标的宽高
    func makeWidthHeight(view: UIView?,
                         widthAmount: ConstraintMultiplierTarget = 1,
                         heightAmount: ConstraintMultiplierTarget = 1) {
        make { maker in
            maker.width.equalTo((view ?? superview!).snap.width).multipliedBy(widthAmount)
            maker.height.equalTo((view ?? superview!).snap.height).multipliedBy(heightAmount)
        }
    }

    ///make.size.equalTo(CGSize(width: 50, height: 100))
    func makeSize(size: ConstraintRelatableTarget) {
        make { maker in
            maker.size.equalTo(size)
        }
    }

    /// 约束宽高
    ///
    /// - Parameters:
    ///   - width:
    ///   - height:
    ///   - widthAmount: 目标宽度乘以的倍数
    ///   - heightAmount: 目标高度乘以的倍数
    func makeWidthHeight(_ width: ConstraintRelatableTarget,
                         _ height: ConstraintRelatableTarget,
                         widthAmount: ConstraintMultiplierTarget = 1,
                         heightAmount: ConstraintMultiplierTarget = 1) {
        make { maker in
            maker.width.equalTo(width).multipliedBy(widthAmount)
            maker.height.equalTo(height).multipliedBy(heightAmount)
        }
    }

    /// 撑满宽度
    func makeFullWidth(_ parent: ConstraintRelatableTarget? = nil,
                       leftOffset: ConstraintOffsetTarget = 0,
                       rightOffset: ConstraintOffsetTarget = 0) {
        make { maker in
            if parent is Number {
                maker.leading.equalTo(superview!).offset(leftOffset)
                maker.trailing.equalTo(superview!).offset(rightOffset)
                maker.width.equalTo(parent!)
            } else {
                maker.leading.equalTo(parent ?? superview!).offset(leftOffset)
                maker.trailing.equalTo(parent ?? superview!).offset(rightOffset)
            }
        }
    }

    /// 撑满高度
    func makeFullHeight(_ parent: ConstraintRelatableTarget? = nil,
                        topOffset: ConstraintOffsetTarget = 0,
                        bottomOffset: ConstraintOffsetTarget = 0) {
        make { maker in
            if parent is Number {
                maker.top.equalTo(superview!).offset(topOffset)
                maker.bottom.equalTo(superview!).offset(bottomOffset)
                maker.height.equalTo(parent!)
            } else {
                maker.top.equalTo(parent ?? superview!).offset(topOffset)
                maker.bottom.equalTo(parent ?? superview!).offset(bottomOffset)
            }
        }
    }

    /// 居中
    func makeCenter(_ parent: ConstraintRelatableTarget? = nil,
                    offset: ConstraintOffsetTarget = 0,
                    priority: ConstraintPriority = .required) {
        make { maker in
            maker.center.equalTo(parent ?? superview!).offset(offset).priority(priority)
        }
    }

    /// 横向居中. 水平居中
    func makeCenterX(_ parent: ConstraintRelatableTarget? = nil,
                     offset: ConstraintOffsetTarget = 0,
                     priority: ConstraintPriority = .required) {
        make { maker in
            maker.centerX.equalTo(parent ?? superview!).offset(offset).priority(priority)
        }
    }

    /// 竖向居中, 垂直居中
    func makeCenterY(_ parent: ConstraintRelatableTarget? = nil,
                     offset: ConstraintOffsetTarget = 0,
                     priority: ConstraintPriority = .required) {
        make { maker in
            maker.centerY.equalTo(parent ?? superview!).offset(offset).priority(priority)
        }
    }

    /// 自身和目标顶部对齐
    func makeGravityTop(_ parent: ConstraintRelatableTarget? = nil,
                        offset: ConstraintOffsetTarget = 0,
                        priority: ConstraintPriority = .required) {
        make { maker in
            maker.top.equalTo(parent ?? superview!).offset(offset).priority(priority)
        }
    }

    func makeGravityTopSafe(_ parent: UIView? = nil,
                            offset: ConstraintOffsetTarget = 0,
                            priority: ConstraintPriority = .required) {
        makeGravityTop((parent ?? superview!).safeAreaLayoutGuide.snap.top, offset: offset, priority: priority)
    }

    func makeGravityLeft(_ parent: ConstraintRelatableTarget? = nil,
                         offset: ConstraintOffsetTarget = 0,
                         priority: ConstraintPriority = .required) {
        make { maker in
            maker.leading.equalTo(parent ?? superview!).offset(offset).priority(priority)
        }
    }

    func makeGravityLeftSafe(_ parent: UIView? = nil,
                             offset: ConstraintOffsetTarget = 0,
                             priority: ConstraintPriority = .required) {
        makeGravityLeft((parent ?? superview!).safeAreaLayoutGuide.snap.leading, offset: offset, priority: priority)
    }

    func makeGravityHorizontal(_ parent: ConstraintRelatableTarget? = nil,
                               offset: ConstraintOffsetTarget = 0,
                               priority: ConstraintPriority = .required) {
        make { maker in
            let parent = toConstraintTarget(parent)
            maker.leading.equalTo(parent).offset(offset).priority(priority)
            maker.trailing.equalTo(parent).offset(offset.reverse()).priority(priority)
        }
    }

    func makeGravityVertical(_ parent: ConstraintRelatableTarget? = nil,
                             offset: ConstraintOffsetTarget = 0,
                             priority: ConstraintPriority = .required) {
        make { maker in
            let parent = toConstraintTarget(parent)
            maker.top.equalTo(parent).offset(offset).priority(priority)
            maker.bottom.equalTo(parent).offset(offset.reverse()).priority(priority)
        }
    }

    /// 注意offset可能需要是负值, 已自动取负值
    func makeGravityRight(_ parent: ConstraintRelatableTarget? = nil,
                          offset: ConstraintOffsetTarget = 0,
                          priority: ConstraintPriority = .required) {
        make { maker in
            maker.trailing.equalTo(parent ?? superview!).offset(offset.reverse()).priority(priority)
        }
    }

    func makeGravityRightSafe(_ parent: UIView? = nil,
                              offset: ConstraintOffsetTarget = 0,
                              priority: ConstraintPriority = .required) {
        makeGravityRight((parent ?? superview!).safeAreaLayoutGuide.snap.trailing, offset: offset, priority: priority)
    }

    /// 注意offset可能需要是负值, 已自动取负值
    func makeGravityBottom(_ parent: ConstraintRelatableTarget? = nil,
                           offset: ConstraintOffsetTarget = 0,
                           priority: ConstraintPriority = .required) {
        make { maker in
            maker.bottom.equalTo(parent ?? superview!).offset(offset.reverse()).priority(priority)
        }
    }

    func makeGravityBottomSafe(_ parent: UIView? = nil,
                               offset: ConstraintOffsetTarget = 0,
                               priority: ConstraintPriority = .required) {
        makeGravityBottom((parent ?? superview!).safeAreaLayoutGuide.snap.bottom, offset: offset, priority: priority)
    }

    /// 自身左边, 对齐目标右边
    func makeLeftToRightOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                           offset: ConstraintOffsetTarget = 0,
                           priority: ConstraintPriority = .required) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.leading.equalTo(parent.snp.trailing).offset(offset).priority(priority)
        }
    }

    func makeLeftToLeftOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                          offset: ConstraintOffsetTarget = 0,
                          priority: ConstraintPriority = .required) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.leading.equalTo(parent.snp.leading).offset(offset).priority(priority)
        }
    }

    func makeRightToRightOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                            offset: ConstraintOffsetTarget = 0,
                            priority: ConstraintPriority = .required) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.trailing.equalTo(parent.snp.trailing).offset(offset.reverse()).priority(priority)
        }
    }

    func makeRightToLeftOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                           offset: ConstraintOffsetTarget = 0,
                           priority: ConstraintPriority = .required) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.trailing.equalTo(parent.snp.leading).offset(offset.reverse()).priority(priority)
        }
    }

    func makeTopToTopOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                        offset: ConstraintOffsetTarget = 0,
                        priority: ConstraintPriority = .required) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.top.equalTo(parent.snp.top).offset(offset).priority(priority)
        }
    }

    /// 自身顶部, 对齐目标底部
    func makeTopToBottomOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                           offset: ConstraintOffsetTarget = 0,
                           priority: ConstraintPriority = .required) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.top.equalTo(parent.snp.bottom).offset(offset).priority(priority)
        }
    }

    /// 自身顶部对齐目标y轴中心
    func makeTopToCenterYOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.PARENT,
                            offset: ConstraintOffsetTarget = 0,
                            priority: ConstraintPriority = .required) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.top.equalTo(parent.snp.centerY).offset(offset).priority(priority)
        }
    }

    /// 底部对齐底部时, 请先确定控件的高度, 否则无法准确计算
    func makeBottomToBottomOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                              offset: ConstraintOffsetTarget = 0,
                              priority: ConstraintPriority = .required) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.bottom.equalTo(parent.snp.bottom).offset(offset.reverse()).priority(priority)
        }
    }

    /// 已自动取负值
    func makeBottomToTopOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                           offset: ConstraintOffsetTarget = 0,
                           priority: ConstraintPriority = .required) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.bottom.equalTo(parent.snp.top).offset(offset.reverse()).priority(priority)
        }
    }

    /// 自身底部对齐目标y轴中心
    func makeBottomToCenterYOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.PARENT,
                               offset: ConstraintOffsetTarget = 0,
                               priority: ConstraintPriority = .required) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.bottom.equalTo(parent.snp.centerY).offset(offset.reverse()).priority(priority)
        }
    }

    //MARK: 比例约束 http://snapkit.io/docs/

    /// 宽度是高度的多少倍, 默认是自身的高度 [amount] w/h
    func makeWidthRatio(_ amount: ConstraintMultiplierTarget = 1, other: ConstraintRelatableTarget? = nil) {
        makeWidth(other ?? snp.height, amount: amount)
    }

    /// 高度是宽度的多少倍, 默认是自身的高度 [amount] h/w
    func makeHeightRatio(_ amount: ConstraintMultiplierTarget = 1, other: ConstraintRelatableTarget? = nil) {
        makeHeight(other ?? snp.width, amount: amount)
    }

    //MARK: 撑满

    /// 宽度撑满, 对齐顶部
    func makeTopIn(_ view: UIView? = nil,
                   offsetLeft: ConstraintOffsetTarget = 0,
                   offsetTop: ConstraintOffsetTarget = 0,
                   offsetRight: ConstraintOffsetTarget = 0,
                   offsetBottom: ConstraintOffsetTarget = 0,
                   priority: ConstraintPriority = .medium) {
        let view = view ?? superview!
        make { maker in
            maker.leading.equalTo(view.snap.leading).offset(offsetLeft).priority(priority)
            maker.trailing.equalTo(view.snap.trailing).offset(offsetRight.reverse()).priority(priority)
            maker.bottom.equalTo(view.snap.bottom).offset(offsetBottom.reverse()).priority(priority)
            maker.top.equalTo(view.snap.top).offset(offsetTop).priority(.required)
        }
    }

    /// 宽度撑满, 对齐底部
    func makeBottomIn(_ view: UIView? = nil,
                      offsetLeft: ConstraintOffsetTarget = 0,
                      offsetTop: ConstraintOffsetTarget = 0,
                      offsetRight: ConstraintOffsetTarget = 0,
                      offsetBottom: ConstraintOffsetTarget = 0,
                      priority: ConstraintPriority = .medium) {
        let view = view ?? superview!
        make { maker in
            maker.leading.equalTo(view.snap.leading).offset(offsetLeft).priority(priority)
            maker.trailing.equalTo(view.snap.trailing).offset(offsetRight.reverse()).priority(priority)
            maker.top.equalTo(view.snap.top).offset(offsetTop).priority(priority)
            maker.bottom.equalTo(view.snap.bottom).offset(offsetBottom.reverse()).priority(.required)
        }
    }

    func makeLeftIn(_ view: UIView? = nil,
                    offsetLeft: ConstraintOffsetTarget = 0,
                    offsetTop: ConstraintOffsetTarget = 0,
                    offsetRight: ConstraintOffsetTarget = 0,
                    offsetBottom: ConstraintOffsetTarget = 0,
                    priority: ConstraintPriority = .medium) {
        let view = view ?? superview!
        make { maker in
            maker.leading.equalTo(view.snap.leading).offset(offsetLeft).priority(.required)
            maker.trailing.equalTo(view.snap.trailing).offset(offsetRight.reverse()).priority(priority)
            maker.bottom.equalTo(view.snap.bottom).offset(offsetBottom.reverse()).priority(priority)
            maker.top.equalTo(view.snap.top).offset(offsetTop).priority(priority)
        }
    }

    func makeRightIn(_ view: UIView? = nil,
                     offsetLeft: ConstraintOffsetTarget = 0,
                     offsetTop: ConstraintOffsetTarget = 0,
                     offsetRight: ConstraintOffsetTarget = 0,
                     offsetBottom: ConstraintOffsetTarget = 0,
                     priority: ConstraintPriority = .medium) {
        let view = view ?? superview!
        make { maker in
            maker.leading.equalTo(view.snap.leading).offset(offsetLeft).priority(priority)
            maker.trailing.equalTo(view.snap.trailing).offset(offsetRight.reverse()).priority(.required)
            maker.bottom.equalTo(view.snap.bottom).offset(offsetBottom.reverse()).priority(priority)
            maker.top.equalTo(view.snap.top).offset(offsetTop).priority(priority)
        }
    }

    func makeIn(_ view: UIView? = nil,
                offsetLeft: ConstraintOffsetTarget = 0,
                offsetTop: ConstraintOffsetTarget = 0,
                offsetRight: ConstraintOffsetTarget = 0,
                offsetBottom: ConstraintOffsetTarget = 0,
                priority: ConstraintPriority = .medium) {
        let view = view ?? superview!
        make { maker in
            maker.leading.equalTo(view.snap.leading).offset(offsetLeft).priority(priority)
            maker.top.equalTo(view.snap.top).offset(offsetTop).priority(priority)
            maker.trailing.equalTo(view.snap.trailing).offset(offsetRight.reverse()).priority(priority)
            maker.bottom.equalTo(view.snap.bottom).offset(offsetBottom.reverse()).priority(priority)
        }
    }

}

extension UIView {

    //MARK: Window 安全区域插入

    var leftSafeInsets: CGFloat {
        get {
            UIApplication.mainWindow?.safeAreaInsets.left ?? 0
        }
    }

    var rightSafeInsets: CGFloat {
        get {
            UIApplication.mainWindow?.safeAreaInsets.right ?? 0
        }
    }

    var bottomSafeInsets: CGFloat {
        get {
            UIApplication.mainWindow?.safeAreaInsets.bottom ?? 0
        }
    }

    var topSafeInsets: CGFloat {
        get {
            UIApplication.mainWindow?.safeAreaInsets.top ?? 0
        }
    }

}