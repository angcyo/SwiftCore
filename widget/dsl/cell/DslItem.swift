//
// Created by wayto on 2021/8/2.
//

import Foundation
import UIKit

/// 数据和界面关联的item
class DslItem: NSObject {

    /// cell 界面
    /// 如果是在DslTableView中, 则必须是UITableViewCell的子类
    var itemCell: AnyClass? = nil

    /// data 数据
    var itemData: Any? = nil

    /// itemCell 可复用的标识
    var identifier: String {
        NSStringFromClass(itemCell!)
    }

    init(_ cell: AnyClass, _ data: Any? = nil) {
        itemCell = cell
        itemData = data
    }
}