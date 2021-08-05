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