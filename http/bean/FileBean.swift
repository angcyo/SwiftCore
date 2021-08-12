//
// Created by angcyo on 21/08/12.
//

import Foundation

// MARK: - FileBean
struct FileBean: Codable {
    var id: Int? = nil
    var createTime: String? = nil
    var createUserId: Int? = nil
    var updateTime: String? = nil
    var updateUserId: Int? = nil
    var userGroupId: Int? = nil
    var userId: Int? = nil
    var commonFileId: Int? = nil //文件id
    var fileType: Int? = nil //文件类型
    var filePath: String? = nil //路径, 需要加host才能访问
    var fileTypeName: String? = nil //文件类型名

    enum CodingKeys: String, CodingKey {
        case id
        case createTime
        case createUserId
        case updateTime
        case updateUserId
        case userGroupId
        case userId
        case commonFileId
        case fileType
        case filePath
        case fileTypeName
    }
}