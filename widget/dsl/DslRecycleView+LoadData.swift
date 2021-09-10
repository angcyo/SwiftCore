//
// Created by angcyo on 21/09/10.
//

import Foundation

/// 列表数据加载扩展

extension SectionItemProvide {

    /// 通过数据列表,更新[DslItem]列表
    func loadDataEnd<T: DslItem>(_ itemClass: T.Type = T.self,
                                 dataList: [Any?]?, error: Error? = nil,
                                 page: HttpPage = .singlePage /*默认单页更新, 即更新整个列表*/,
                                 dsl: ((T) -> Void)? = nil) {
        if page.currentRequestPage <= page.firstPage {
            //首页数据
            if let error = error {
                onSetEmptyList(error, data: error)
            } else if nilOrEmpty(dataList) {
                //空数据
                onSetEmptyList()
            } else {
                let newCount = dataList?.count ?? 0
                updateItem(itemClass, withIndex: 0, oldItemList: _itemList, data: dataList, dsl: dsl)
                recyclerView.toStatusContent()
                if newCount >= page.requestSize {
                    //激活加载更多
                    onSetLoadMore()
                } else {
                    onSetLoadMore(enable: false)
                }
            }
        } else {
            //分页
            recyclerView.toStatusContent()
            if let error = error {
                onSetLoadMore(.ITEM_STATUS_ERROR, data: error)
            } else if nilOrEmpty(dataList) {
                //空数据
                onSetLoadMore(.ITEM_STATUS_NO_MORE)
            } else {
                //计算出旧的数据
                let newCount = dataList?.count ?? 0
                let start = (page.currentRequestPage - page.firstPage) * page.requestSize
                let end = _itemList.endIndex
                var oldItemList = [DslItem]()
                for i in start...end {
                    if let item = _itemList.get(i) {
                        oldItemList.add(item)
                    }
                }

                //开始 CRUD
                updateItem(itemClass, withIndex: 0, oldItemList: oldItemList, data: dataList, dsl: dsl)
                if newCount >= page.requestSize {
                    //激活加载更多
                    onSetLoadMore()
                } else {
                    onSetLoadMore(.ITEM_STATUS_NO_MORE)
                }
            }
        }
    }
}