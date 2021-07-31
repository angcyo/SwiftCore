//
// Created by wayto on 2021/7/31.
//

import Foundation

extension Array where Element: Equatable {

    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}