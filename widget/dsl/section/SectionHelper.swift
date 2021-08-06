//
// Created by angcyo on 21/08/05.
//

import Foundation
import UIKit

class SectionHelper {

    /// 片段集合
    var sectionList: [DslSection] = []

    /// 过滤后的item集合
    var visibleItems: [DslItem] = []

    /// 创建一个数据快照
    func createSnapshot(_ items: [DslItem]) -> NSDiffableDataSourceSnapshot<DslSection, DslItem> {
        var _sectionList: [DslSection] = []
        var _itemList: [DslItem] = []

        var section: DslSection? = nil
        var lastSectionName: String? = nil

        for item in items {

            //过滤
            if item.itemHidden {
                continue
            }

            //数组
            _itemList.append(item)

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

        // 返回
        return snapshot
    }
}