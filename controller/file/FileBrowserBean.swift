//
// Created by angcyo on 21/09/09.
//

import Foundation

class FileBrowserBean {
    var fileName: String? = nil
    var fileType: String? = nil
    var filePath: String? = nil

    ///显示的名字
    var displayName: String? = nil
    var ownerAccountName: String? = nil
    ///修改时间
    var modificationDate: Date? = nil
    var type: String? = nil

    ///文件大小b, 文件夹中表示子项数量
    var fileSize: Int = 0

    var isFolder: Bool = false
    var isExists: Bool = false
    var isReadable: Bool = false
    var isWritable: Bool = false
    var isExecutable: Bool = false
    var isDeletable: Bool = false
}