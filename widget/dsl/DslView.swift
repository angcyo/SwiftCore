//
//  DslView.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/28.
//

import Foundation
import UIKit
import SnapKit

class DslView {
    /// 根试图
    var rootView: UIView

    init(rootView: UIView) {
        self.rootView = rootView
    }
}

// MARK: - view操作扩展

extension UIView {

    /// 添加一个view, 并且返回.
    @discardableResult
    func render<T: UIView>(_ view: T, _ action: ((T) -> Void)? = nil) -> T {
        if view.superview == nil {
            if self is UIStackView {
                (self as! UIStackView).addArrangedSubview(view)
            } else {
                addSubview(view)
            }
        }
        action?(view)
        return view
    }
}

// MARK: - 布局扩展, 需要库SnapKit支持

extension UIView {

    /// snp dsl
    func make(_ closure: (_ make: ConstraintMaker) -> Void) {
        snp.makeConstraints(closure)
    }

    /// 转换成约束目标
    func toConstraintTarget(_ parent: ConstraintRelatableTarget? = nil) -> ConstraintRelatableTarget {
        if parent is ConstraintTarget {
            switch parent as! ConstraintTarget {
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

    /// 约束宽高
    ///
    /// - Parameters:
    ///   - width:
    ///   - height:
    ///   - widthAmount: 目标宽度乘以的倍数
    ///   - heightAmount: 目标高度乘以的倍数
    func makeWidthHeight(_ width: ConstraintRelatableTarget? = nil,
                         _ height: ConstraintRelatableTarget? = nil,
                         widthAmount: ConstraintMultiplierTarget = 1,
                         heightAmount: ConstraintMultiplierTarget = 1) {
        make { maker in
            if let width = width {
                maker.width.equalTo(width).multipliedBy(widthAmount)
            }
            if let height = height {
                maker.height.equalTo(height).multipliedBy(heightAmount)
            }
        }
    }

    /// 撑满宽度
    func makeFullWidth(_ parent: ConstraintRelatableTarget? = nil,
                       leftOffset: ConstraintOffsetTarget = 0,
                       rightOffset: ConstraintOffsetTarget = 0) {
        make { maker in
            maker.left.equalTo(parent ?? superview!).offset(leftOffset)
            maker.right.equalTo(parent ?? superview!).offset(rightOffset)
        }
    }

    /// 撑满高度
    func makeFullHeight(_ parent: ConstraintRelatableTarget? = nil,
                        topOffset: ConstraintOffsetTarget = 0,
                        bottomOffset: ConstraintOffsetTarget = 0) {
        make { maker in
            maker.top.equalTo(parent ?? superview!).offset(topOffset)
            maker.bottom.equalTo(parent ?? superview!).offset(bottomOffset)
        }
    }

    /// 居中
    func makeCenter(_ parent: ConstraintRelatableTarget? = nil, offset: ConstraintOffsetTarget = 0) {
        make { maker in
            maker.center.equalTo(parent ?? superview!).offset(offset)
        }
    }

    /// 横向居中
    func makeCenterX(_ parent: ConstraintRelatableTarget? = nil, offset: ConstraintOffsetTarget = 0) {
        make { maker in
            maker.centerX.equalTo(parent ?? superview!).offset(offset)
        }
    }

    /// 竖向居中
    func makeCenterY(_ parent: ConstraintRelatableTarget? = nil, offset: ConstraintOffsetTarget = 0) {
        make { maker in
            maker.centerY.equalTo(parent ?? superview!).offset(offset)
        }
    }

    /// 自身和目标顶部对齐
    func makeGravityTop(_ parent: ConstraintRelatableTarget? = nil, offset: ConstraintOffsetTarget = 0) {
        make { maker in
            maker.top.equalTo(parent ?? superview!).offset(offset)
        }
    }

    func makeGravityLeft(_ parent: ConstraintRelatableTarget? = nil, offset: ConstraintOffsetTarget = 0) {
        make { maker in
            maker.left.equalTo(parent ?? superview!).offset(offset)
        }
    }

    func makeGravityHorizontal(_ parent: ConstraintRelatableTarget? = nil, offset: Int = 0) {
        make { maker in
            let parent = toConstraintTarget(parent)
            maker.left.equalTo(parent).offset(offset)
            maker.right.equalTo(parent).offset(-offset)
        }
    }

    func makeGravityVertical(_ parent: ConstraintRelatableTarget? = nil, offset: Int = 0) {
        make { maker in
            let parent = toConstraintTarget(parent)
            maker.top.equalTo(parent).offset(offset)
            maker.bottom.equalTo(parent).offset(-offset)
        }
    }

    func makeGravityRight(_ parent: ConstraintRelatableTarget? = nil, offset: ConstraintOffsetTarget = 0) {
        make { maker in
            maker.right.equalTo(parent ?? superview!).offset(offset)
        }
    }

    func makeGravityBottom(_ parent: ConstraintRelatableTarget? = nil, offset: ConstraintOffsetTarget = 0) {
        make { maker in
            maker.bottom.equalTo(parent ?? superview!).offset(offset)
        }
    }

    /// 自身左边, 对齐目标右边
    func makeLeftToRightOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                           offset: ConstraintOffsetTarget = 0) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.left.equalTo(parent.snp.right).offset(offset)
        }
    }

    func makeLeftToLeftOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                          offset: ConstraintOffsetTarget = 0) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.left.equalTo(parent.snp.left).offset(offset)
        }
    }

    func makeRightToRightOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                            offset: ConstraintOffsetTarget = 0) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.right.equalTo(parent.snp.right).offset(offset)
        }
    }

    func makeRightToLeftOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                           offset: ConstraintOffsetTarget = 0) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.right.equalTo(parent.snp.left).offset(offset)
        }
    }

    /// 自身顶部, 对齐目标底部
    func makeTopToBottomOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                           offset: ConstraintOffsetTarget = 0) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.top.equalTo(parent.snp.bottom).offset(offset)
        }
    }

    func makeBottomToBottomOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                              offset: ConstraintOffsetTarget = 0) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.bottom.equalTo(parent.snp.bottom).offset(offset)
        }
    }
}
