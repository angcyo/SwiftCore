//
// Created by angcyo on 21/09/07.
//

import Foundation
import PPBadgeViewSwift

////# 角标 https://github.com/jkpang/PPBadgeView
///pod 'PPBadgeViewSwift' #3.1.0

/*
给UITabBarItem添加badge

tabBarVC的 viewDidLoad() 中获取不到tabBarItem实例,demo为了演示效果做了0.1s的延时操作,
在实际开发中,badge的显示是在网络请求成功/推送之后,所以不用担心获取不到tabBarItem添加不了badge
*/

extension UIBarButtonItem {

    /// nil 隐藏角标, 空字符, 显示点
    func updateBadge(_ text: String? = nil, dotColor: UIColor = Res.color.error) {
        if let text = text {

            /// 恢复默认属性值
            pp.badgeView.flexMode = .middle
            pp.badgeView.layer.cornerRadius = 9

            if text.isEmpty {
                pp.addDot(color: dotColor)
            } else {
                pp.addBadge(text: text)
                pp.setBadge(height: 15) //设置高度, 避免圆点和字符切换时的frame变形bug
            }
        } else {
            pp.hiddenBadge()
        }
    }
}

extension UITabBarItem {

    /// nil 隐藏角标, 空字符, 显示点
    func updateBadge(_ text: String?, dotColor: UIColor = Res.color.error) {
        if let text = text {

            /// 恢复默认属性值
            pp.badgeView.flexMode = .middle
            pp.badgeView.layer.cornerRadius = 9

            if text.isEmpty {
                pp.addDot(color: dotColor)
            } else {
                pp.addBadge(text: text)
                pp.setBadge(height: 15) //设置高度, 避免圆点和字符切换时的frame变形bug
            }
        } else {
            pp.hiddenBadge()
        }
    }
}

extension UIView {

    /// nil 隐藏角标, 空字符, 显示点
    func updateBadge(_ text: String?, dotColor: UIColor = Res.color.error) {
        if let text = text {

            /// 恢复默认属性值
            pp.badgeView.flexMode = .middle
            pp.badgeView.layer.cornerRadius = 9

            if text.isEmpty {
                pp.addDot(color: dotColor)
            } else {
                pp.addBadge(text: text)
                pp.setBadge(height: 15) //设置高度, 避免圆点和字符切换时的frame变形bug
            }
        } else {
            pp.hiddenBadge()
        }
    }
}
