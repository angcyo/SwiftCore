//
// Created by angcyo on 21/08/10.
//

import Foundation
import UIKit

protocol DslRecycleView: AnyObject {

    /// 所有的数据集合, 但非全部在界面上显示. 包含界面上的所有item和隐藏的item
    var _itemList: [DslItem] { get set }

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

    ///[visible]仅可见的item
    func getItemList(_ visible: Bool = true) -> [DslItem] {
        if visible {
            return sectionHelper.visibleItems
        } else {
            return _itemList
        }
    }

    // MARK: item操作

    func clearAllItems() {
        _itemList.removeAll()
        needsReload = true
    }

    @discardableResult
    func load<Item: DslItem>(_ item: Item, _ dsl: ((Item) -> Void)? = nil) -> Item {
        addItem(item, dsl)
    }

    @discardableResult
    func addItem<Item: DslItem>(_ item: Item, _ dsl: ((Item) -> Void)? = nil) -> Item {
        _itemList.append(item)
        //init
        dsl?(item)
        needsReload = true
        return item
    }

    @discardableResult
    func insertItem<Item: DslItem>(_ item: Item, _ at: Int, _ dsl: ((Item) -> Void)? = nil) -> Item {
        var index = at
        if at > _itemList.endIndex {
            index = _itemList.endIndex
        } else if at < 0 {
            index = _itemList.endIndex
        }
        _itemList.insert(item, at: index)
        //init
        dsl?(item)
        needsReload = true
        return item
    }

    /// 删除item
    @discardableResult
    func removeItem(_ item: DslItem) -> DslItem? {
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

    func getItem(_ indexPath: IndexPath) -> DslItem? {
        let section = sectionHelper.sectionList.get(indexPath.section)
        let item = section?.items.get(indexPath.row)
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

    /// 立即更新 [animatingDifferences] 是否需要动画 [completion]完成的回调
    func loadDataNow(_ animatingDifferences: Bool? = nil, completion: (() -> Void)? = nil) {
        loadData(_itemList, animatingDifferences: animatingDifferences, completion: completion)
    }

    /// 强制加载数据
    func loadData(_ items: [DslItem], animatingDifferences: Bool? = nil, completion: (() -> Void)? = nil) {
        var animate = true
        if animatingDifferences == nil {
            // 智能判断是否要动画
            animate = !sectionHelper.visibleItems.isEmpty
        } else {
            animate = animatingDifferences!
        }

        ///diff 更新数据
        doMain {
            let snapshot = self.sectionHelper.createSnapshot(self, self._itemList)
            //Please always submit updates either always on the main queue or always off the main queue
            if let tableView = self as? DslTableView {
                tableView.diffableDataSource.apply(snapshot, animatingDifferences: animate, completion: completion)
            } else if let collectionView = self as? DslCollectionView {
                collectionView.diffableDataSource.apply(snapshot, animatingDifferences: animate, completion: completion)
            } else {
                L.w("不支持的DslRecyclerView:\(self)")
            }
        }

        needsReload = false
    }
}

// MARK: 更新

extension DslRecycleView {

    /// 从后面查找锚点item, 如果第一个class对应的item不存在, 则找第二个class对应的item, 以此类推
    func findAnchor(_ itemClass: AnyClass..., end: Bool = true) -> DslItem? {
        var result: DslItem? = nil

        var index = 0
        while (index < itemClass.endIndex) {
            let cls = itemClass[index]

            if end {
                for i in (_itemList.startIndex..<_itemList.endIndex).reversed() {
                    let item = _itemList[i]
                    let itemType = type(of: item)

                    if itemType.description() == cls.description() {
                        // 锚点找到
                        result = item
                        break
                    }
                }
            } else {
                for i in _itemList.startIndex..<_itemList.endIndex {
                    let item = _itemList[i]
                    let itemType = type(of: item)

                    if itemType.description() == cls.description() {
                        // 锚点找到
                        result = item
                        break
                    }
                }
            }

            //next
            index += 1
        }

        return result
    }

    func findAnchor(_ itemTag: String...) -> DslItem? {
        var result: DslItem? = nil

        var index = 0
        while (index < itemTag.endIndex) {
            let tag = itemTag[index]

            for i in _itemList.startIndex..<_itemList.endIndex {
                let item = _itemList[i]
                if item.itemTag == tag {
                    // 锚点找到
                    result = item
                    break
                }
            }

            //next
            index += 1
        }

        return result
    }

    /// 在指定位置更新item, 如果指定位置不存在相同的item, 则插入.
    ///
    /// - Parameters:
    ///   - itemClass: 需要插入或更新的item
    ///   - at: 锚点, 在此item的后面操作
    ///   - data: 数据量, 入股为nil, 则更新一条, 如果非空对象, 则进行增删改
    /// - Returns:
    @discardableResult
    func updateItem<T: DslItem>(_ itemClass: T.Type = T.self, atItemType at: DslItem.Type = T.self, data: [Any?]? = nil, dsl: ((T) -> Void)? = nil) -> [T] {
        if itemClass.description() == at.description() {
            // 更新自身
            for i in _itemList.startIndex..<_itemList.endIndex {
                let item = _itemList[i]
                let itemType = type(of: item)

                if itemType.description() == at.description() {
                    // 锚点找到
                    return updateItem(itemClass, withIndex: i, data: data, dsl: dsl)
                }
            }
            return updateItem(itemClass, withIndex: -1, data: data, dsl: dsl)
        } else {
            var anchorItem: DslItem? = nil

            //左边小, 右边大. 否则会报错
            //Fatal error: Range requires lowerBound <= upperBound

            // 从尾部开始查找
            for i in (_itemList.startIndex..<_itemList.endIndex).reversed() {
                let item = _itemList[i]
                let itemType = type(of: item) //Wayto_GBSecurity_iOS.MeCertificateTableItem
                //let t2 = type(of: at) //Wayto_GBSecurity_iOS.DslItem.Type

                if itemType.description() == at.description() {
                    // 锚点找到
                    anchorItem = item
                    break
                }
            }
            return updateItem(itemClass, atItem: anchorItem, data: data, dsl: dsl)
        }
    }

    @discardableResult
    func updateItem<T: DslItem>(_ itemClass: T.Type = T.self, atItemTag at: String?, data: [Any?]? = nil, dsl: ((T) -> Void)? = nil) -> [T] {
        var anchorItem: DslItem? = nil

        //... ..< 左边小, 右边大. 否则会报错
        //Fatal error: Range requires lowerBound <= upperBound

        // 从尾部开始查找
        for i in (_itemList.startIndex..<_itemList.endIndex).reversed() {
            let item = _itemList[i]
            if item.itemTag == at {
                // 锚点找到
                anchorItem = item
                break
            }
        }

        return updateItem(itemClass, atItem: anchorItem, data: data, dsl: dsl)
    }

    @discardableResult
    func updateItem<T: DslItem>(_ itemClass: T.Type = T.self, withItemTag at: String?, data: [Any?]? = nil, dsl: ((T) -> Void)? = nil) -> [T] {
        var targetItemIndex: Int = -1
        // 从尾部开始查找
        for i in (_itemList.startIndex..<_itemList.endIndex).reversed() {
            let item = _itemList[i]
            if item.itemTag == at {
                // 锚点找到
                targetItemIndex = i
                break
            }
        }

        return updateItem(itemClass, withIndex: targetItemIndex, data: data, dsl: dsl)
    }

    /// 在指定位置更新/插入item
    @discardableResult
    func updateItem<T: DslItem>(_ itemClass: T.Type = T.self, withIndex at: Int, data: [Any?]? = nil, dsl: ((T) -> Void)? = nil) -> [T] {
        if let item = _itemList.get(at) {
            if type(of: item).description() == itemClass.description() {
                var oldItemList: [T] = [] //已存在的旧item
                for i in at..<_itemList.endIndex {
                    let item = _itemList[i]
                    if type(of: item).description() == itemClass.description() {
                        oldItemList.add(item as! T)
                    }
                }
                return updateItem(itemClass, withIndex: at, oldItemList: oldItemList, data: data, dsl: dsl)
            }
        }
        return updateItem(itemClass, withIndex: at, oldItemList: [], data: data, dsl: dsl)
    }

    ///在at位置后面, 更新指定类型itemClass的item
    @discardableResult
    func updateItem<T: DslItem>(_ itemClass: T.Type = T.self, atItem at: DslItem?, data: [Any?]? = nil, dsl: ((T) -> Void)? = nil) -> [T] {
        if let atItem = at {
            //有锚点
            var anchorIndex = -2 //是否找到了锚点
            var oldItemList: [T] = [] //已存在的旧item

            for i in _itemList.startIndex..<_itemList.endIndex {
                let item = _itemList[i]

                if item == atItem {
                    anchorIndex = i
                } else if anchorIndex >= 0 {
                    //找到锚点后的下一个
                    if type(of: item).description() == itemClass.description() {
                        // 已经存在相同类型的item
                        oldItemList.add(item as! T)
                    } else {
                        break
                    }
                }
            }

            return updateItem(itemClass, withIndex: anchorIndex + 1, oldItemList: oldItemList, data: data, dsl: dsl)
        } else {
            //无锚点
            return updateItem(itemClass, withIndex: -1, oldItemList: [], data: data, dsl: dsl)
        }
    }

    /// 更新一批item
    ///
    /// - Parameters:
    ///   - itemClass: 需要更新的item类型
    ///   - withIndex: 在指定的列表位置, 如果位置无效, 则插入到列表最后
    ///   - oldItemList: 列表上已经存在的旧item
    ///   - data: 需要更新的数据数量, nil表示更新/插入一条. 数据会被赋值给itemData
    ///   - dsl: 初始化
    /// - Returns:
    @discardableResult
    func updateItem<T: DslItem>(_ itemClass: T.Type = T.self, withIndex at: Int, oldItemList: [T], data: [Any?]? = nil, dsl: ((T) -> Void)? = nil) -> [T] {
        var result: [T] = []

        if let data = data {
            //批量更新

            let oldCount = oldItemList.count
            let newCount = data.count

            //1.先移除多余的
            let removeCount = oldCount - newCount//需要删除的数量
            //let removeList: [DslItem] = [] //需要移除的item集合
            if removeCount > 0 {
                for i in (newCount...oldCount - 1).reversed() {
                    _itemList.remove(oldItemList[i]) //移除多余的item
                }
            }

            //2.更新已存在的
            let updateCount = min(oldCount, newCount)
            if updateCount > 0 {
                for i in (0..<updateCount) {
                    let dataItem = data[i]
                    let item = oldItemList[i]

                    let targetItem = item as! T
                    targetItem.itemData = dataItem
                    result.add(targetItem)
                    dsl?(targetItem)
                    targetItem.itemUpdate = true
                }
            }

            //3.增加新增的
            let addCount = newCount - oldCount
            if addCount > 0 {
                for i in (0..<addCount) {
                    let dataItem = data[updateCount + i]
                    let newItem = itemClass.init()
                    newItem.itemData = dataItem
                    result.add(newItem)
                    insertItem(newItem, at + updateCount + i, dsl)
                }
            }
        } else {
            //单条更新
            if let item = _itemList.get(at) {
                if type(of: item).description() == itemClass.description() {
                    //目标位置已存在item, 则直接更新此item
                    let targetItem = item as! T
                    result.add(targetItem)
                    dsl?(targetItem)
                    targetItem.itemUpdate = true
                    return result
                }
            }

            //类型不一样, 则直接插入
            let newItem = itemClass.init()
            result.add(newItem)
            insertItem(newItem, at, dsl)
        }

        return result
    }
}