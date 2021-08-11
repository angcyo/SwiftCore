//
// Created by angcyo on 21/08/10.
//

import Foundation
import SwiftyJSON

class FormParams {

    /// 使用可见的item, 进行数据操作. hidden的不处理
    /// [UITableView.visibleCells]
    var userVisibleItem: Bool = true

    /// 临时存储的item
    var formItem: IFormItem? = nil

    /// 数据存储
    var jsonData = JSON()
}

extension FormParams {

    /// - Parameters:
    ///   - key: 支持.号分割的路径
    ///   - value:
    ///   - putToArray: 是否将[value]追加到key对应的数组中
    func put(_ key: String, _ value: Any, putToArray: Bool = false) {
        let keyList = key.splitString(separator: ".")
        jsonData.ensurePath(keyList)

        //value
        let _value: JSON
        if let value = value as? JSON {
            _value = value
        } else {
            _value = JSON(value)
        }

        //put
        if putToArray {
            jsonData.add(keyList, value: _value)
        } else {
            jsonData[keyList] = _value
        }
    }
}