//
// Created by angcyo on 21/08/05.
//

import Foundation
import UIKit

/// 通过diff 用来更新数据源

class SectionHelper {

    /// 片段集合
    var sectionList: [DslSection] = []

    /// 过滤后的item集合
    var visibleItems: [DslItem] = []

    /// 数据拦截器
    var interceptorList: [ISectionInterceptor] = [DefaultSectionInterceptor(),
                                                  StatusSectionInterceptor(),
                                                  LoadMoreSectionInterceptor()]

    /// 创建一个数据快照
    func createSnapshot(_ recyclerView: DslRecycleView, _ items: [DslItem]) -> NSDiffableDataSourceSnapshot<DslSection, DslItem> {
        var _sectionList: [DslSection] = []
        var _itemList: [DslItem] = []

        _itemList.addAll(items)
        if !interceptorList.isEmpty {
            //1. 先排序
            interceptorList.sort { l, r in
                //自然升序, 值越大越在后面
                l.order < r.order
            }

            for interceptor in interceptorList {
                let params = InterceptorParams()
                params.dslRecyclerView = recyclerView
                params.requestItems.addAll(_itemList)
                interceptor.onInterceptor(params)

                //交换数据
                _itemList.reset(params.resultItems)

                //中断后续的拦截器
                if params.interrupt {
                    break
                }
            }
        }

        // 开始数据分组以及diff
        var section: DslSection? = nil
        var lastSectionName: String? = nil

        for item in _itemList {
            //分组
            if item.itemSectionName == lastSectionName {
                //same section
                if section == nil {
                    section = item._itemSection ?? DslSection()
                    section!.items.removeAll()
                    _sectionList.append(section!)
                }
            } else {
                //new section
                section = item._itemSection ?? DslSection()
                section!.items.removeAll()
                _sectionList.append(section!)
            }
            section!.items.append(item)
            item._itemSection = section
            lastSectionName = item.itemSectionName
        }

        sectionList = _sectionList
        visibleItems = _itemList

        // 创建快照并返回
        var snapshot = NSDiffableDataSourceSnapshot<DslSection, DslItem>()
        snapshot.appendSections(_sectionList)
        for section in _sectionList {
            snapshot.appendItems(section.items, toSection: section)
        }

        // 需要更新的item集合
        var _updateItemList: [DslItem] = []
        for item in _itemList {
            if item.itemUpdate {
                _updateItemList.append(item)
            }
        }
        snapshot.reloadItems(_updateItemList)

        // 注册cell
        recyclerView.registerItemCell(visibleItems)

        // 返回
        return snapshot
    }
}