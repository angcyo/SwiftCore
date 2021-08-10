//
// Created by angcyo on 21/08/10.
//

import Foundation

extension String {

    /// 如果为空时则返回[empty]
    func ifEmpty(_ empty: String) -> String {
        if self.isEmpty || self.lowercased() == "null" {
            return empty
        }
        return self
    }

    func splitString(separator: Character, maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true) -> [String] {
        let array = split(separator: separator, maxSplits: maxSplits, omittingEmptySubsequences: omittingEmptySubsequences)
        /*var result = [String]()
        for item in array {
            result.append("\(item)")
        }*/
        return array.compactMap {
            "\($0)"
        }
    }
}

func nilOrEmpty(_ value: String?) -> Bool {
    value == nil || value?.isEmpty == true
}