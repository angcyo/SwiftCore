//
// Created by angcyo on 21/08/10.
//

import Foundation
import UIKit

protocol DslRecycleView: AnyObject {

    /// 所有的数据集合, 但非全部在界面上显示. 包含界面上的所有item和隐藏的item
    ///var _itemList: [DslItem] { get set }

    /// 数据源
    var recyclerDataSource: DslRecyclerDataSource { get set }

    /// diff 数据更新助手
    var sectionHelper: SectionHelper { get set }

    /// 是否需要重新加载items
    var needsReload: Bool { get set }

    /// 情感图切换item
    var statusItem: IStatusItem? { get set }

    /// 加载更多item
    var loadMoreItem: IStatusItem? { get set }
}

extension DslRecycleView {

    @discardableResult
    func load<Item: DslItem>(_ item: Item, _ dsl: ((Item) -> Void)? = nil) -> Item {
        let item = recyclerDataSource.defaultSectionItemProvide.load(item, dsl)
        recyclerDataSource.updateDataSource()
        return item
    }

    @discardableResult
    func addItem<Item: DslItem>(_ item: Item, _ dsl: ((Item) -> Void)? = nil) -> Item {
        let item = recyclerDataSource.defaultSectionItemProvide.addItem(item, dsl)
        recyclerDataSource.updateDataSource()
        return item
    }

    var defaultItemProvide: SectionItemProvide {
        get {
            recyclerDataSource.defaultSectionItemProvide
        }
    }

    /// 更新数据 [now] 是否立即更新
    func updateRecyclerDataSource(_ now: Bool = false) {
        recyclerDataSource.updateDataSource(now)
    }

    ///[visible]仅可见的item
    func getItemList(_ visible: Bool = true) -> [DslItem] {
        if visible {
            return sectionHelper.visibleItems
        } else {
            return recyclerDataSource.getAllItem()
        }
    }

    /// 获取对应位置的cell
    func getCellForRow(at indexPath: IndexPath) -> DslCell? {
        if let tableView = self as? UITableView {
            return tableView.cellForRow(at: indexPath)
        } else if let collection = self as? UICollectionView {
            return collection.cellForItem(at: indexPath)
        } else {
            return nil
        }
    }

    // MARK: 辅助操作

    func getItem(_ indexPath: IndexPath) -> DslItem? {
        let section = sectionHelper.sectionList.get(indexPath.section)
        let item = section?.items.get(indexPath.row)
        return item
    }

    func getTableItem(_ indexPath: IndexPath) -> DslTableItem? {
        getItem(indexPath) as? DslTableItem
    }

    func getCollectionItem(_ indexPath: IndexPath) -> DslCollectionItem? {
        getItem(indexPath) as? DslCollectionItem
    }

    func getSectionFirstTableItem(_ section: Int) -> DslTableItem? {
        sectionHelper.sectionList[section].firstItem as? DslTableItem
    }

    func getSectionFirstCollectionItem(_ section: Int) -> DslCollectionItem? {
        sectionHelper.sectionList[section].firstItem as? DslCollectionItem
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
                    //collectionView.register(<#T##viewClass: AnyClass?##Swift.AnyClass?#>, forSupplementaryViewOfKind: <#T##String##Swift.String#>, withReuseIdentifier: <#T##String##Swift.String#>)
                }
            }
        }
    }

    /// 立即更新 [animatingDifferences] 是否需要动画 [completion]完成的回调
    func loadDataNow(_ animatingDifferences: Bool? = nil, completion: (() -> Void)? = nil) {
        loadData(recyclerDataSource.getAllItem(), animatingDifferences: animatingDifferences, completion: completion)
    }

    /// 强制加载数据
    func loadData(_ items: [DslItem], animatingDifferences: Bool? = nil, completion: (() -> Void)? = nil) {
        sectionHelper.updateItemList(recyclerView: self, items: items, animatingDifferences: animatingDifferences, completion: completion)
        needsReload = false
    }

    //MARK: 情感图切换

    func toStatus(_ status: ItemStatus, data: Any? = nil, enable: Bool = true) {
        if let statusItem = statusItem {
            statusItem.itemStatusEnable = enable
            statusItem.itemStatus = status

            if let item = statusItem as? DslItem {
                item.itemData = data
            }
            needsReload = true
        }
    }

    func toStatusRefresh(_ enable: Bool = true) {
        toStatus(.ITEM_STATUS_REFRESH, enable: enable)
    }

    /// 如果界面无item实现, 则切换到刷新中
    /// 如果界面有内容item显示, 则直接触发刷新item的刷新回调
    func toStatusRefreshIfNeeded() {
        if sectionHelper.visibleItems.isEmpty {
            toStatus(.ITEM_STATUS_REFRESH, enable: true)
        } else if sectionHelper.visibleItems.count == 1 && sectionHelper.visibleItems.first is IStatusItem {
            toStatus(.ITEM_STATUS_REFRESH, enable: true)
        } else {
            //已有内容item
            if let statusItem = statusItem as? BaseStatusTableItem {
                //直接回调
                statusItem.onItemRefresh?(DslTableCell())
            }
        }
    }

    func toStatusContent(_ enable: Bool = true) {
        toStatus(.ITEM_STATUS_NONE, enable: enable)
    }

    //MARK: 加载更多控制

    func toLoadMore(_ status: ItemStatus = .ITEM_STATUS_REFRESH, data: Any? = nil, enable: Bool = true) {
        if let statusItem = loadMoreItem {
            statusItem.itemStatusEnable = enable
            statusItem.itemStatus = status

            if let item = statusItem as? DslItem {
                item.itemData = data
            }

            needsReload = true
        }
    }
}

extension UICollectionView {

    var flowLayout: UICollectionViewFlowLayout? {
        get {
            collectionViewLayout as? UICollectionViewFlowLayout
        }
    }

    /// 等同于 contentSize
    var collectionViewContentSize: CGSize {
        get {
            collectionViewLayout.collectionViewContentSize
        }
    }

    /// 内容的宽度
    var contentWidth: CGFloat {
        get {
            collectionViewContentSize.width + contentInset.left + contentInset.right
        }
    }

    /// 内容的高度
    var contentHeight: CGFloat {
        get {
            collectionViewContentSize.height + contentInset.top + contentInset.bottom
        }
    }
}
