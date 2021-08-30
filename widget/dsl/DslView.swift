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

    /// 添加一个view, 并且返回. 请先确保 view 的 frame有效.
    @discardableResult
    func render<T: UIView>(_ view: T, _ action: ((T) -> Void)? = nil) -> T {
        if self == view {
            action?(view)
            return view
        }

        if let superview = view.superview {
            if superview != self {
                //parent改变了, 先从其他地方移除
                view.removeFromSuperview()
            }
        }

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

    @discardableResult
    func renderAndMake<T: UIView>(_ view: T, _ action: (ConstraintMaker) -> Void) -> T {
        render(view)
        view.make(action)
        return view
    }
}
