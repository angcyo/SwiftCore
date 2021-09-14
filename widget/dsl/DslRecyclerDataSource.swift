//
// Created by angcyo on 21/09/10.
//

import Foundation

/// 数据源

class DslRecyclerDataSource {

    ///item提供器
    var itemProvideList: [SectionItemProvide] = []

    /// 界面
    let recyclerView: DslRecycleView

    /// 默认的数据提供器
    var defaultSectionItemProvide: SectionItemProvide

    init(_ recyclerView: DslRecycleView) {
        self.recyclerView = recyclerView
        defaultSectionItemProvide = SectionItemProvide(self.recyclerView)
        //itemProvideList.insert(defaultSectionItemProvide, at: 0)
        itemProvideList.add(defaultSectionItemProvide)
    }

    /// 获取所有数据
    func getAllItem() -> [DslItem] {
        var result: [DslItem] = []
        itemProvideList.forEach {
            result.addAll($0._itemList)
        }
        return result
    }

    func clearAllItems() {
        itemProvideList.forEach {
            $0._itemList.removeAll()
        }
        updateDataSource()
    }

    /// 开始更新界面
    func updateDataSource(_ now: Bool = false) {
        if now {
            recyclerView.loadData(getAllItem())
        } else {
            recyclerView.needsReload = true
        }
    }

    func addItemProvide(_ itemProvide: SectionItemProvide, index: Int = .max) {
        itemProvideList.insert(itemProvide, at: index.clamp(0, itemProvideList.endIndex))
        recyclerView.needsReload = true
    }
}