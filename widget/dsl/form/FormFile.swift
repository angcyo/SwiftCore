//
// Created by angcyo on 21/08/24.
//

import Foundation

//MARK: FormFile

protocol FormFile {

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

func addFormFile(key: String, value: FormFile) {
    FormFileHelper.formFile.removeValue(forKey: key)
    FormFileHelper.formFile.add([key: value])
}

func removeFormFile(key: String) {
    FormFileHelper.formFile.removeValue(forKey: key)
}