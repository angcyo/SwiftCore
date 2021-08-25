//
// Created by angcyo on 21/08/12.
//

import Foundation

/*
 {
    "fileSize" : 375969,
    "updateUserId" : 1,
    "clientIp" : null,
    "filePath" : "\/xfile\/filestore\/user_group_9\/2021-08-25\/311d8125-0ead-4e7a-9e3b-29420d238239.png",
    "clientAddr" : null,
    "updateTime" : "2021-08-25 09:19:17",
    "deleted" : null,
    "originalName" : "fileName",
    "fileName" : "311d8125-0ead-4e7a-9e3b-29420d238239",
    "id" : 394,
    "md5Code" : "29aea1e372b6fb844f62fefaa688edfb",
    "realDiskPath" : "\/home\/kaiyang\/filestore\/user_group_9\/2021-08-25\/311d8125-0ead-4e7a-9e3b-29420d238239.png",
    "userGroupId" : 9,
    "fileMark" : null,
    "diskPath" : "\/user_group_9\/2021-08-25\/311d8125-0ead-4e7a-9e3b-29420d238239.png",
    "createTime" : "2021-08-25 09:19:17",
    "createDate" : "2021-08-25",
    "fileSuffix" : ".png",
    "createUserId" : 1,
    "fileTitle" : null
  }
 */

// MARK: - FileBean

struct FileBean: Codable {
    var fileSize: Int?
    var updateUserId: Int?
    var filePath: String? //路径, 需要加host才能访问
    var updateTime: String?
    var originalName: String?
    var fileName: String?
    var id: Int?
    var md5Code: String?
    var realDiskPath: String?
    var userGroupId: Int?
    var diskPath: String?
    var createTime: String?
    var createDate: String?
    var fileSuffix: String?
    var createUserId: Int?

    var userId: Int? = nil
    var commonFileId: Int? = nil //文件id
    var fileType: Int? = nil //文件类型
    var fileTypeName: String? = nil //文件类型名

    enum CodingKeys: String, CodingKey {
        case fileSize
        case updateUserId
        case filePath
        case updateTime
        case originalName
        case fileName
        case id
        case md5Code
        case realDiskPath
        case userGroupId
        case diskPath
        case createTime
        case createDate
        case fileSuffix
        case createUserId

        case userId
        case commonFileId
        case fileType
        case fileTypeName
    }
}
