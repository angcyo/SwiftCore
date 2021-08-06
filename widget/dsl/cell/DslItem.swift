//
// Created by wayto on 2021/8/2.
//

import Foundation
import UIKit

/// 数据和界面关联的item
class DslItem: NSObject {

    /// cell 界面
    /// 如果是在DslTableView中, 则必须是UITableViewCell的子类
    var itemCell: AnyClass? = nil

    /// itemCell 可复用的标识
    var identifier: String {
        NSStringFromClass(itemCell!)
    }

    /// data 数据
    var itemData: Any? = nil

    /// 分组, 相同的sectionName会分配在同一个section中, 分组只和上下item之间判断
    var itemSectionName: String? = nil

    /// 是否隐藏item
    var itemHidden: Bool = false {
        willSet {
            if itemHidden != newValue {
                _dslTableView?.needsReload = true
            }
        }
    }

    /// 是否需要更新item, 在diff判断时使用, 在[@selector(onBindCell:::)]中取消
    var itemUpdate: Bool = false {
        willSet {
            if newValue {
                _dslTableView?.needsReload = true
            }
        }
    }

    /// [自动赋值] 绑定的[DslTableView]视图 [@selector(createTableViewCell:cellForRowAt:item:)]
    var _dslTableView: DslTableView? = nil

    /// [自动赋值] 分组完成之后, 所在的section.
    var _itemSection: DslSection? = nil

    /// index
    var itemIndexOfSection: IndexPath? {
        if let section = _itemSection, let tableView = _dslTableView {
            //在第几个section中, 从0开始
            let s = tableView.sectionHelper.sectionList.indexOf(section)
            //在section中的第几个
            let r = section.items.indexOf(self)
            return IndexPath(row: r, section: s)
        } else {
            return nil
        }
    }

    init(_ cell: AnyClass, _ data: Any? = nil) {
        itemCell = cell
        itemData = data
    }

    //MARK: [DslTableView] 代理配置
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
    var itemHeaderEstimatedHeight: CGFloat = 0

    //MARK: [DslTableView] 代理配置-Footer
    var itemFooterView: UIView? = nil
    var itemFooterTitle: String? = nil
    var itemFooterHeight: CGFloat = UITableView.automaticDimension
    var itemFooterEstimatedHeight: CGFloat = 0

    //MARK: 界面回调 [DslTableCell]

    /// [自动赋值]
    var _itemEditing: Bool = false
    /// [自动赋值]
    var _itemHighlighted: Bool = false
    /// [自动赋值]
    var _itemSelected: Bool = false

    ///
    var onBindCell: ((_ cell: DslTableCell, _ indexPath: IndexPath) -> Void)? = nil

    var onEditing: ((_ editing: Bool, _ animated: Bool) -> Void)? = nil
    var onHighlighted: ((_ highlighted: Bool, _ animated: Bool) -> Void)? = nil
    var onSelected: ((_ selected: Bool, _ animated: Bool) -> Void)? = nil
}