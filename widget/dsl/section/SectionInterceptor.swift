//
// Created by angcyo on 21/09/06.
//

import Foundation

/// section helper 数据拦截器, 用来输出在界面上显示的item

typealias InterceptorOrder = Int

extension InterceptorOrder {
    static let INTERCEPTOR_ORDER_LOW = 100
    static let INTERCEPTOR_ORDER_MEDIUM = 500
    static let INTERCEPTOR_ORDER_HIGH = 1000
}

protocol ISectionInterceptor {

    /// 拦截器的顺序, 值越大, 执行越后面
    var order: InterceptorOrder { get set }

    /// 开始拦截数据, 过滤完之后,
    func onInterceptor(_ params: InterceptorParams)
}

class InterceptorParams {

    //MARK: 输入参数

    /// 视图
    var dslRecyclerView: DslRecycleView? = nil

    /// 过去请求的数据源
    var requestItems: [DslItem] = []


    //MARK: 输出参数

    /// 过去后的数据集合, 返回参数
    var resultItems: [DslItem] = []

    /// 中断后续的拦截器处理, 返回参数
    var interrupt: Bool = false
}