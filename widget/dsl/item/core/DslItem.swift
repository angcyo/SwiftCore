//
// Created by wayto on 2021/8/2.
//

import Foundation
import UIKit
import RxSwift

/// 数据和界面关联的item
open class DslItem: NSObject, IDslItem {

    /// cell 界面, 必须
    /// 如果是在DslTableView中, 则必须是UITableViewCell的子类
    /// 如果是在DslCollectionView中, 则必须是UICollectionViewCell的子类
    /// 如果未配置, 会自动根据Item的类名获取对应的Cell类.
    var itemCell: AnyClass? = nil

    /// itemCell 可复用的标识
    var identifier: String {
        if itemCell == nil {
            L.e("请配置[itemCell]")
        }
        if let cellClass = itemCell {
            return NSStringFromClass(cellClass)
        } else {
            fatalError("请配置[itemCell]")
        }
    }

    /// 标识, 可以用来find
    var itemTag: String? = nil

    /// data 数据
    var itemData: Any? = nil

    /// 分组, 相同的sectionName会分配在同一个section中, 分组只和上下item之间判断
    var itemSectionName: String = "default"

    /// 是否隐藏item
    var itemHidden: Bool = false {
        willSet {
            if itemHidden != newValue {
                _dslRecyclerView?.needsReload = true
            }
        }
    }

    /// 是否需要更新item, 在diff判断时使用, 在[@selector(bindCell:::)]之后取消
    var itemUpdate: Bool = false {
        willSet {
            if newValue {
                _dslRecyclerView?.needsReload = true
            }
        }
    }

    /// [自动赋值] 绑定的[DslTableView]视图 [@selector(createTableViewCell:cellForRowAt:item:)]
    var _dslRecyclerView: DslRecycleView? = nil

    /// [自动赋值] 分组完成之后, 所在的section.
    var _itemSection: DslSection? = nil

    /// index
    var itemIndex: IndexPath? {
        if let section = _itemSection, let tableView = _dslRecyclerView {
            //在第几个section中, 从0开始
            let s = tableView.sectionHelper.sectionList.indexOf(section)
            //在section中的第几个
            let r = section.items.indexOf(self)
            return IndexPath(row: r, section: s)
        } else {
            return nil
        }
    }

    //MARK: change

    //// item内容是否发生改变
    var itemChange: Bool = false {
        didSet {
            if itemChange {
                itemChangeAction()
            }
        }
    }

    public required override init() {
        super.init()
        initItem()
    }

    /// 初始化
    init(_ cell: AnyClass, _ data: Any? = nil) {
        super.init()
        itemCell = cell
        itemData = data
        initItem()
    }

    func initItem() {
        if itemCell == nil {
            itemCell = cellClass()
        }
    }

    //MARK: - cell界面绑定

    /// item与cell绑定
    /// @selector(createTableViewCell:cellForRowAt:item:)
    func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        L.d("绑定cell:\(cell):\(indexPath)")
        onBindCell?(cell, indexPath)
        bindCellOverride(cell, indexPath)

        /*guard let cell = cell as? DslCell else {
            return
        }*/

        /*cell.cellOf(MeHeaderTableCell.self) {
        }*/
    }

    func bindCellOverride(_ cell: DslCell, _ indexPath: IndexPath) {
        if let view = cell as? UIView {
            bindItemGesture(view)
        }
        onBindCellOverride?(cell, indexPath)
    }

    var onBindCell: ((_ cell: DslCell, _ indexPath: IndexPath) -> Void)? = nil
    var onBindCellOverride: ((_ cell: DslCell, _ indexPath: IndexPath) -> Void)? = nil

    /// cell即将显示
    /// @selector(tableView:willDisplay:forRowAt:)
    func bindCellWillDisplay(_ cell: DslCell, _ indexPath: IndexPath) {
        L.d("cell可见:\(cell):\(indexPath)")
    }

    /// cell即将不可见
    /// @selector(tableView:didEndDisplaying:forRowAt:)
    func bindCellDidEndDisplaying(_ cell: DslCell, _ indexPath: IndexPath) {
        L.d("cell不可见:\(cell):\(indexPath)")
    }

    //MARK: - Rx

    //Rx 自动取消订阅,
    lazy var disposeBag: DisposeBag = {
        DisposeBag()
    }()

    /// 手势订阅
    lazy var gestureDisposeBag: DisposeBag = {
        DisposeBag()
    }()

    /// 取消所有订阅
    func reset() {
        disposeBag = DisposeBag()
        gestureDisposeBag = DisposeBag()
    }

    //MARK: 事件回调, 无法自动触发. 需要手动触发调用

    /// 点击事件的回调
    var onItemClick: (() -> Void)? = nil

    /// 长按事件的回调
    var onItemLongClick: (() -> Void)? = nil

    /// MARK: change

    /// item 内容改变后
    var onItemChange: ((DslItem) -> Void)? = nil

    func itemChangeAction() {
        onItemChange?(self)

        // trigger
        itemChangeUpdateOther()
    }

    /// 定向更新
    func itemChangeUpdateOther() {
        if let updateList = isItemInUpdateList, let recyclerView = _dslRecyclerView {
            recyclerView._itemList.forEach {
                if updateList($0) {
                    // 需要更新
                    $0.onItemUpdateFrom?(self)
                    $0.itemUpdate = true
                }
            }
        }
    }

    //// 当当前item内容改变后, 需要更新的其他item
    var isItemInUpdateList: ((DslItem) -> Bool)? = nil

    /// 来自其他内容改变的item, 触发的更新自己
    var onItemUpdateFrom: ((DslItem) -> Void)? = nil
}

extension DslItem {

    /// 获取对应名称的cell
    func cellClass() -> AnyClass? {
        var name = className
        name.removeLast(4)
        let cellName = name + "Cell"
        let cls: AnyClass? = cellName.toClass()
        return cls
    }

    /// 判断当前item,是否是列表中的最后一个
    func isLastItem() -> Bool {
        var result = false

        if let anchorIndex = itemIndex, let tableView = _dslRecyclerView as? UITableView {
            result = anchorIndex.section == tableView.numberOfSections - 1 &&
                    anchorIndex.row == tableView.numberOfRows(inSection: anchorIndex.section) - 1
        }

        return result
    }

    /// 获取当前cell开始, 之前cell的所有高度
    func beforeCellHeight() -> CGFloat {
        var result: CGFloat = 0

        if let anchorIndex = itemIndex, let tableView = _dslRecyclerView as? UITableView {

            // 循环获取section
            for s in 0..<tableView.numberOfSections {
                if s > anchorIndex.section {
                    // 到达
                    break
                } else {
                    var interrupt = false //结束
                    let headerHeight = tableView.rectForHeader(inSection: s).height
                    result += headerHeight
                    for r in 0..<tableView.numberOfRows(inSection: s) {
                        // 循环获取row
                        if s == anchorIndex.section && r >= anchorIndex.row {
                            //到达
                            interrupt = true
                            break
                        } else {
                            let cellHeight = tableView.rectForRow(at: indexPath(row: r, section: s)).height
                            result += cellHeight
                        }
                    }
                    if interrupt {
                        break
                    } else {
                        let footerHeight = tableView.rectForFooter(inSection: s).height
                        result += footerHeight
                    }
                }
            }

        }

        return result
    }

    /// 获取当前cell开始, 之前cell中最大的宽度
    func beforeCellMaxWidth() -> CGFloat {
        var result: CGFloat = 0

        if let anchorIndex = itemIndex, let tableView = _dslRecyclerView as? UITableView {

            // 循环获取section
            for s in 0..<tableView.numberOfSections {
                if s > anchorIndex.section {
                    // 到达
                    break
                } else {
                    var interrupt = false //结束
                    for r in 0..<tableView.numberOfRows(inSection: s) {
                        // 循环获取row
                        if s == anchorIndex.section && r >= anchorIndex.row {
                            //到达
                            interrupt = true
                            break
                        } else {
                            let cellWidth = tableView.rectForRow(at: indexPath(row: r, section: s)).width
                            result = max(result, cellWidth)
                        }
                    }
                    if interrupt {
                        break
                    }
                }
            }
        }

        return result
    }
}

extension DslItem {

    /// 绑定点击, 长按事件回调
    @objc func bindItemGesture(_ view: UIView) {
        gestureDisposeBag = DisposeBag() //重置手势监听
        view.clearGestureRecognizers() //移除所有手势识别器, 防止被复用

        if onItemClick != nil {
            bindItemClick(view)
        }

        if onItemLongClick != nil {
            bindItemLongClick(view)
        }
    }

    func bindItemClick(_ view: UIView) {
        view.onClick(bag: gestureDisposeBag) { _ in
            self.onItemClick?()
        }
    }

    func bindItemLongClick(_ view: UIView) {
        view.onLongClick(bag: gestureDisposeBag) { _ in
            self.onItemLongClick?()
        }
    }

    /// 绑定点击事件
    func bindClick(_ view: UIView, action: (() -> Void)?) {
        view.onClick(bag: gestureDisposeBag) { _ in
            action?()
        }
    }

    func bindLongClick(_ view: UIView, action: (() -> Void)?) {
        view.onLongClick(bag: gestureDisposeBag) { _ in
            action?()
        }
    }
}