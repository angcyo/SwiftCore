//
// Created by angcyo on 21/08/09.
//

import Foundation
import UIKit

class DslTableItem: DslItem {

    //MARK: [DslTableView] 代理配置
    var itemIndentationLevel: Int = 0
    var itemCanEdit: Bool = false
    var itemCanMove: Bool = false
    var itemCanHighlight: Bool = false
    var itemCanSelect: Bool = false
    var itemCanDeselect: Bool = false

    /// 激活item的选择
    func enableSelect(_ enable: Bool = true) {
        itemCanHighlight = enable
        itemCanSelect = enable
        itemCanDeselect = enable
    }

    var itemHeight: CGFloat = UITableView.automaticDimension
    var itemEstimatedHeight: CGFloat = 50

    //MARK: [DslTableView] 代理配置-Header
    var itemHeaderView: UIView? = nil
    var itemHeaderTitle: String? = nil
    var itemHeaderHeight: CGFloat = UITableView.automaticDimension
    var itemHeaderEstimatedHeight: CGFloat = UITableView.automaticDimension

    //MARK: [DslTableView] 代理配置-Footer
    var itemFooterView: UIView? = nil
    var itemFooterTitle: String? = nil
    var itemFooterHeight: CGFloat = UITableView.automaticDimension
    var itemFooterEstimatedHeight: CGFloat = UITableView.automaticDimension

    //MARK: 界面回调 [DslTableCell]

    /// [自动赋值]
    var _itemEditing: Bool = false
    /// [自动赋值]
    var _itemHighlighted: Bool = false
    /// [自动赋值]
    var _itemSelected: Bool = false

    var onEditing: ((_ editing: Bool, _ animated: Bool) -> Void)? = nil
    var onHighlighted: ((_ highlighted: Bool, _ animated: Bool) -> Void)? = nil
    var onSelected: ((_ selected: Bool, _ animated: Bool) -> Void)? = nil

}