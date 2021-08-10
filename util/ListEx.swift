//
// Created by wayto on 2021/7/31.
//

import Foundation

extension Array where Element: Equatable {

    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }

    func indexOf(_ object: Element) -> Int {
        let index = firstIndex(of: object)
        return index ?? -1
    }
}

func nilOrEmpty(_ value: Array<Any>?) -> Bool {
    value == nil || value?.isEmpty == true
}

func nilOrEmpty(_ value: Dictionary<String, Any>?) -> Bool {
    value == nil || value?.isEmpty == true
}