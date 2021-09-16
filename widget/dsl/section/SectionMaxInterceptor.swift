//
// Created by angcyo on 21/09/06.
//

import Foundation

/// 限制界面最大显示的数量

class SectionMaxInterceptor: BaseSectionInterceptor {

    /// 允许显示的最大数量
    var maxCount: Int = 9

    /// 未达到最大显示数量时, 追加的item集合
    var appendItems: [DslItem] = []

    override init() {
        super.init()
        order = .INTERCEPTOR_ORDER_HIGH * 50
    }

    override func onInterceptor(_ params: InterceptorParams) {
        var _itemList: [DslItem] = []

        if params.requestItems.count <= maxCount {
            _itemList.addAll(params.requestItems)
        } else {
            for i in 0..<maxCount {
                _itemList.add(params.requestItems[i])
            }
        }

        if params.requestItems.count < maxCount {
            _itemList.addAll(appendItems)
        }

        //result
        params.resultItems.addAll(_itemList)
    }
}