//
// Created by angcyo on 21/09/06.
//

import Foundation

/// 支持状态切换的item

typealias ItemStatus = Int

extension ItemStatus {
    /// 正常
    static let ITEM_STATUS_NONE = 0x1
    /// 刷新中
    static let ITEM_STATUS_REFRESH = 0x1000
    /// 异常
    static let ITEM_STATUS_ERROR = 0x10000
    /// 无更多
    static let ITEM_STATUS_NO_MORE = 0x100000
}

protocol IStatusItem: IDslItem {

    /// 当前状态
    var itemStatus: ItemStatus { get set }

    /// 是否激活组件
    var itemStatusEnable: Bool { get set }
}