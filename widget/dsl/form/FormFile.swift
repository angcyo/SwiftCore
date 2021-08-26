//
// Created by angcyo on 21/08/24.
//

import Foundation
import UIKit

//MARK: FormFile

protocol FormFile {

}

extension UIImage: FormFile {
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

func addFormFile(key: String, value: FormFile) {
    removeFormFile(key: key)
    FormFileHelper.formFile.add([key: value])
}

func removeFormFile(key: String) {
    FormFileHelper.formFile.removeValue(forKey: key)
}