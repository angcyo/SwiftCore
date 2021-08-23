//
// Created by angcyo on 21/08/23.
//

import Foundation

//typealias IItem = Equatable & IItemProtocol

protocol IItem {

    /// 转换成界面显示的文本
    func itemToString() -> String?

    /// 转换成表单提交的数据
    func itemToValue() -> Any?
}

extension String: IItem {

    func itemToString() -> String? {
        self
    }

    func itemToValue() -> Any? {
        self
    }
}

/*
extension Array where Element: IItem {

    func findItemIndex(_ item: IItem) -> Int {
        var index = -1
        forEachIndex {
            if item.equalTo(other: $0) {
                index = $1
            }
        }
        return index
    }

    func findItem(_ item: IItem) -> IItem? {
        var result: IItem? = nil
        forEachIndex { i, index in
            if item.equalTo(other: i) {
                result = i
            }
        }
        return result
    }
}
*/
