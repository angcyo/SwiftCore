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
        return firstIndexOf(object)
    }

    func firstIndexOf(_ object: Element) -> Int {
        let index = firstIndex(of: object)
        return index ?? -1
    }

    func lastIndexOf(_ object: Element) -> Int {
        let index = lastIndex(of: object)
        return index ?? -1
    }
}

extension Array {
    func forEachIndex(_ action: (Element, Int) -> Void) {
        for i in self.indices {
            action(self[i], i)
        }
    }
}

func nilOrEmpty(_ value: Array<Any?>?) -> Bool {
    value == nil || value?.isEmpty == true
}

/*func nilOrEmpty(_ value: Set<Hashable?>?) -> Bool {
    value == nil || value?.isEmpty == true
}*/

func nilOrEmpty(_ value: Dictionary<String, Any?>?) -> Bool {
    value == nil || value?.isEmpty == true
}