//
// Created by angcyo on 21/09/10.
//

import Foundation

class SectionItemProvide {

    /// 所有的数据集合, 但非全部在界面上显示. 包含界面上的所有item和隐藏的item
    var _itemList: [DslItem] = []

    /// 界面
    let recyclerView: DslRecycleView

    init(_ recyclerView: DslRecycleView) {
        self.recyclerView = recyclerView
    }

    // MARK: item操作

    @discardableResult
    func load<Item: DslItem>(_ item: Item, _ dsl: ((Item) -> Void)? = nil) -> Item {
        addItem(item, dsl)
    }

    @discardableResult
    func addItem<Item: DslItem>(_ item: Item, _ dsl: ((Item) -> Void)? = nil) -> Item {
        _itemList.append(item)
        //init
        dsl?(item)
        recyclerView.needsReload = true
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
        recyclerView.needsReload = true
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
            recyclerView.needsReload = true
            return item
        }
        return nil
    }

    // MARK: load data

    /// 设置空集合
    func onSetEmptyList(_ error: Error? = nil, data: Any? = nil) {
        _itemList.removeAll()
        if recyclerView.getItemList(false).isEmpty {
            //空数据
            if let error = error {
                recyclerView.toStatus(.ITEM_STATUS_ERROR, data: data ?? error)
            } else {
                recyclerView.toStatus(.ITEM_STATUS_EMPTY, data: data)
            }
        }
    }

    func onSetLoadMore(_ status: ItemStatus = .ITEM_STATUS_REFRESH, data: Any? = nil, enable: Bool = true) {
        if recyclerView.loadMoreItem?.itemStatus == status && status == .ITEM_STATUS_REFRESH {
            //已经是刷新状态, 则清空状态
            recyclerView.loadMoreItem?.itemStatus = .ITEM_STATUS_NONE
        }
        recyclerView.toLoadMore(status, data: data, enable: enable)
    }
}

// MARK: 更新

extension SectionItemProvide {

    /// 从后面查找锚点item, 如果第一个class对应的item不存在, 则找第二个class对应的item, 以此类推
    func findAnchor(_ itemClass: AnyClass..., end: Bool = true) -> DslItem? {
        var result: DslItem? = nil

        var index = 0
        while (index < itemClass.endIndex) {
            let cls: AnyClass = itemClass[index]

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
    func updateItem<T: DslItem>(_ itemClass: T.Type = T.self, withIndex at: Int, oldItemList: [DslItem], data: [Any?]? = nil, dsl: ((T) -> Void)? = nil) -> [T] {
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
                    targetItem.itemUpdate = targetItem.isItemUpdateFromData(dataItem)
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

