//
// Created by angcyo on 21/08/05.
//

import Foundation
import UIKit

/// section
class DslSection: NSObject {

    /// section 下的 items
    var items: [DslItem] = []

    var firstItem: DslItem? {
        items.first
    }

    var lastItem: DslItem? {
        items.last
    }
}

extension DslItem {

    /// section中只有一个item
    func isSectionOnlyOne() -> Bool {
        if let section = _itemSection {
            return section.items.count == 1
        } else {
            return false
        }
    }

    /// 是否是section中的第一个
    func isSectionFirst() -> Bool {
        if let section = _itemSection {
            return section.firstItem == self
        } else {
            return false
        }
    }

    /// 是否是section中的最后一个
    func isSectionLast() -> Bool {
        if let section = _itemSection {
            return section.lastItem == self
        } else {
            return false
        }
    }
}