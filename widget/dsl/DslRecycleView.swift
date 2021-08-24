//
// Created by angcyo on 21/08/10.
//

import Foundation
import UIKit

protocol DslRecycleView {

    /// 所有的数据集合, 但非全部在界面上显示. 包含界面上的所有item和隐藏的item
    var _itemList: [DslItem] { get set }

    var sectionHelper: SectionHelper { get set }

    /// 是否需要重新加载items
    var needsReload: Bool { get set }
}

extension DslRecycleView {

    ///[visible]仅可见的item
    func getItemList(_ visible: Bool = true) -> [DslItem] {
        if visible {
            return sectionHelper.visibleItems
        } else {
            return _itemList
        }
    }

    // MARK: item操作

    @discardableResult
    mutating func load<Item: DslItem>(_ item: Item, _ dsl: ((Item) -> Void)? = nil) -> Item {
        addItem(item, dsl)
    }

    @discardableResult
    mutating func addItem<Item: DslItem>(_ item: Item, _ dsl: ((Item) -> Void)? = nil) -> Item {
        _itemList.append(item)
        //init
        dsl?(item)
        needsReload = true
        return item
    }

    /// 删除item
    @discardableResult
    mutating func removeItem(_ item: DslItem) -> DslItem? {
        let index = _itemList.firstIndex {
            $0 == item
        }
        if let index = index {
            _itemList.remove(at: index)
            needsReload = true
            return item
        }
        return nil
    }

    // MARK: 操作符重载

    @discardableResult
    static func +(recyclerView: inout DslRecycleView, item: DslItem) -> DslItem {
        recyclerView.addItem(item)
        return item
    }

    // MARK: 辅助操作

    func getItem(_ indexPath: IndexPath) -> DslItem {
        let section = sectionHelper.sectionList[indexPath.section]
        let item = section.items[indexPath.row]
        return item
    }

    /// 注册cell
    func registerItemCell(_ items: [DslItem]) {
        items.forEach { (item: DslItem) in
            if let itemCell = item.itemCell {
                let identifier = item.identifier

                if let tableView = self as? UITableView {
                    tableView.register(itemCell, forCellReuseIdentifier: identifier)
                } else if let collectionView = self as? UICollectionView {
                    collectionView.register(itemCell, forCellWithReuseIdentifier: identifier)
                }
            }
        }
    }
}