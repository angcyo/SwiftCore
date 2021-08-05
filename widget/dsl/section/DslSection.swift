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