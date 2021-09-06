//
// Created by angcyo on 21/09/06.
//

import Foundation

/// 情感图/加载更多数据拦截器

class StatusSectionInterceptor: ISectionInterceptor {

    var order: InterceptorOrder = -1

    func onInterceptor(_ params: InterceptorParams) {
        if let recyclerView = params.dslRecyclerView {
            if let statusItem = recyclerView.statusItem, statusItem.itemStatusEnable && !statusItem.isItemHidden {
                if let item = statusItem as? DslItem, statusItem.itemStatus != .ITEM_STATUS_NONE {
                    params.resultItems.add(item)
                    params.interrupt = true
                    return
                } else {
                    // 正常状态, 显示内容, 否则显示情感图
                }
            }
        }

        params.resultItems.reset(params.requestItems)
    }
}