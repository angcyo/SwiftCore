//
// Created by angcyo on 21/08/10.
//

import Foundation
import SwiftyJSON

class FormParams {

    /// 从字符串中分割多个值
    static let SPILT: Character = "|"

    /// 多参数拼接分隔符
    static let MULTI_SPILT: Character = ";"

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
    ///   - key: 支持.号分割的路径, 如果key是]结尾, 则默认追加到数组中
    ///   - value: 支持JSON类型的数据
    ///   - putToArray: 是否将[value]追加到key对应的数组中
    func put(_ key: String, _ value: Any?, putToArray: Bool = false) {
        jsonData.put(key, value, putToArray: putToArray)
    }

    /// 返回表单请求需要的参数
    func params() -> [String: Any]? {
        jsonData.dictionaryObject
    }

    /// 表单数据温控
    func isEmpty() -> Bool {
        jsonData.isJsonEmpty()
    }
}

extension FormParams {

    /// 上传表单文件
    @discardableResult
    func uploadFile(url: String? = nil, onEnd: @escaping (Error?) -> Void) -> FormFileHelper {
        let helper = FormFileHelper()
        helper.url = url
        helper.onUploadEnd = { json, error in
            if let json = json, error == nil {
                //成功
                self.jsonData = json
                onEnd(nil)
            } else {
                onEnd(error)
            }
        }
        helper.startUpload(json: jsonData)
        return helper
    }
}