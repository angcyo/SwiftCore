//
// Created by wayto on 2021/7/29.
//

import Foundation
import UIKit

/// 横向布局
func hStackView(_ alignment: UIStackView.Alignment = .center,
                distribution: UIStackView.Distribution? = nil,
                spacing: CGFloat = 0) -> UIStackView {
    let view = UIStackView()
    // 排列方向
    view.axis = .horizontal
    // 对齐方式
    view.alignment = alignment
    // 间隙
    view.spacing = spacing

    // 分布方式
    //case fill = 0  //填满控件, 用约束控制那个控件需要撑满
    //case fillEqually = 1 //平分控件
    //case fillProportionally = 2 //比例填满控件
    //case equalSpacing = 3 //空隙平分
    //case equalCentering = 4 //中心距离平分
    if let distribution = distribution {
        view.distribution = distribution //.fill
    }
    return view
}

/// 纵向布局
func vStackView(_ alignment: UIStackView.Alignment = .center,
                distribution: UIStackView.Distribution? = nil,
                spacing: CGFloat = 0) -> UIStackView {
    let view: UIStackView = hStackView(alignment, distribution: distribution, spacing: spacing)
    view.axis = .vertical
    return view
}