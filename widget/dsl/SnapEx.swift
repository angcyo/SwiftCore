//
// Created by wayto on 2021/7/29.
//

import Foundation
import SnapKit

enum ConstraintTarget: ConstraintRelatableTarget {
    //父控件
    case PARENT
    //父控件中的最后一个控件, 排除自己
    case LAST
}

// MARK: - 布局扩展, 需要库SnapKit支持 http://snapkit.io/docs/

extension UIView {

    /// snp dsl
    func make(_ closure: (_ make: ConstraintMaker) -> Void) {
        snp.makeConstraints(closure)
    }

    /// snp dsl
    func remake(_ closure: (_ make: ConstraintMaker) -> Void) {
        snp.remakeConstraints(closure)
    }

    /// snp dsl
    func updateMake(_ closure: (_ make: ConstraintMaker) -> Void) {
        snp.updateConstraints(closure)
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

    func makeWidthHeight(size: ConstraintRelatableTarget) {
        make { maker in
            maker.width.height.equalTo(size)
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
            if parent is Number {
                maker.left.equalTo(superview!).offset(leftOffset)
                maker.right.equalTo(superview!).offset(rightOffset)
                maker.width.equalTo(parent!)
            } else {
                maker.left.equalTo(parent ?? superview!).offset(leftOffset)
                maker.right.equalTo(parent ?? superview!).offset(rightOffset)
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

    /// 注意offset可能需要是负值
    func makeGravityRight(_ parent: ConstraintRelatableTarget? = nil, offset: ConstraintOffsetTarget = 0) {
        make { maker in
            maker.right.equalTo(parent ?? superview!).offset(offset)
        }
    }

    /// 注意offset可能需要是负值
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

    func makeTopToTopOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                        offset: ConstraintOffsetTarget = 0) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.top.equalTo(parent.snp.top).offset(offset)
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

    /// 底部对齐底部时, 请先确定控件的高度, 否则无法准确计算
    func makeBottomToBottomOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                              offset: ConstraintOffsetTarget = 0) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.bottom.equalTo(parent.snp.bottom).offset(offset)
        }
    }

    func makeBottomToTopOf(_ parent: ConstraintRelatableTarget? = ConstraintTarget.LAST,
                           offset: ConstraintOffsetTarget = 0) {
        make { maker in
            let parent = toConstraintTargetView(parent)
            maker.bottom.equalTo(parent.snp.top).offset(offset)
        }
    }
}