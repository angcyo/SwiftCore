//
// Created by wayto on 2021/8/2.
//

import Foundation
import UIKit
import RxSwift

/// 数据和界面关联的item
class DslItem: NSObject, IDslItem {

    /// cell 界面, 必须
    /// 如果是在DslTableView中, 则必须是UITableViewCell的子类
    /// 如果是在DslCollectionView中, 则必须是UICollectionViewCell的子类
    var itemCell: AnyClass? = nil

    /// itemCell 可复用的标识
    var identifier: String {
        if itemCell == nil {
            debugPrint("请配置[itemCell]")
        }
        return NSStringFromClass(itemCell!)
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

    /// 是否需要更新item, 在diff判断时使用, 在[@selector(onBindCell:::)]中取消
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
    var itemIndexOfSection: IndexPath? {
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

    override init() {
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
    func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        debugPrint("绑定cell:\(cell):\(indexPath)")
        onBindCell?(cell, indexPath)
        bindCellOverride(cell, indexPath)

        //bindItemGesture(cell)

        /*guard let cell = cell as? DslCell else {
            return
        }*/
    }

    func bindCellOverride(_ cell: DslCell, _ indexPath: IndexPath) {
        onBindCellOverride?(cell, indexPath)
    }

    var onBindCell: ((_ cell: DslCell, _ indexPath: IndexPath) -> Void)? = nil
    var onBindCellOverride: ((_ cell: DslCell, _ indexPath: IndexPath) -> Void)? = nil

    //MARK: - Rx

    //Rx 自动取消订阅,
    lazy var disposeBag: DisposeBag = {
        DisposeBag()
    }()

    /// 取消所有订阅
    func reset() {
        disposeBag = DisposeBag()
    }

    //MARK: 事件回调, 无法自动触发. 需要手动触发调用

    /// 点击事件的回调
    var onItemClick: (() -> Void)? = nil

    /// 长按事件的回调
    var onItemLongClick: (() -> Void)? = nil
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
}

extension DslItem {

    /// 绑定点击, 长按事件回调
    func bindItemGesture(_ view: UIView) {
        bindItemClick(view)
        bindItemLongClick(view)
    }

    func bindItemClick(_ view: UIView) {
        if let click = onItemClick {
            view.onClick(bag: disposeBag) { _ in
                click()
            }
        }
    }

    func bindItemLongClick(_ view: UIView) {
        if let longClick = onItemLongClick {
            view.onLongClick(bag: disposeBag) { _ in
                longClick()
            }
        }
    }
}