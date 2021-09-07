//
// Created by angcyo on 21/09/06.
//

import Foundation

/// 加载更多数据拦截器

class LoadMoreSectionInterceptor: ISectionInterceptor {

    var order: InterceptorOrder = .INTERCEPTOR_ORDER_HIGH * 2

    func onInterceptor(_ params: InterceptorParams) {
        params.resultItems.reset(params.requestItems)

        if let recyclerView = params.dslRecyclerView {
            if let loadMoreItem = recyclerView.loadMoreItem, loadMoreItem.itemStatusEnable && !loadMoreItem.isItemHidden {
                if let item = loadMoreItem as? DslItem {
                    params.resultItems.add(item)
                }
            }
        }
    }
}