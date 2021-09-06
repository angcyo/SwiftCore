//
// Created by angcyo on 21/09/06.
//

import Foundation

/// 默认数据拦截器

class DefaultSectionInterceptor: ISectionInterceptor {

    var order: InterceptorOrder = .INTERCEPTOR_ORDER_MEDIUM

    func onInterceptor(_ params: InterceptorParams) {
        var _itemList: [DslItem] = []

        for item in params.requestItems {

            //过滤
            if item.itemHidden {
                continue
            }

            //数组
            _itemList.append(item)
        }

        params.resultItems.addAll(_itemList)
    }
}