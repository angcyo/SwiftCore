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

    @discardableResult
    func renderAndMake(_ view: UIView, _ action: (ConstraintMaker) -> Void) -> UIView {
        render(view)
        view.make(action)
        return view
    }
}
