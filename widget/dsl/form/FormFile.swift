//
// Created by angcyo on 21/08/24.
//

import Foundation
import UIKit

//MARK: FormFile

protocol FormFile {

}

extension UIImage: FormFile {

    /// 返回对应的数据md5值,
    func toFormFile() -> String {
        toData()?.toFormFile() ?? ""
    }
}

extension Data: FormFile {
    func toFormFile() -> String {
        let md5 = toMd5()
        addFormFile(key: md5, value: self)
        return md5
    }
}

extension URL: FormFile {
    func toFormFile() -> String {
        let md5 = "\(self)".toMd5()
        addFormFile(key: md5, value: self)
        return md5
    }
}

/// md5 和 数据, 保存起来. 等待上传
func addFormFile(key: String, value: FormFile) {
    removeFormFile(key: key)
    FormFileHelper.formFile.add([key: value])
}

/// 移除待上传数据
func removeFormFile(key: String) {
    FormFileHelper.formFile.removeValue(forKey: key)
}

/// 获取md5, 对应的上传成功后的文件结构
func getFormFileBean(key: String) -> FileBean? {
    FormFileHelper.formFileBean[key]
}