//
// Created by angcyo on 21/08/24.
//

import Foundation
import Alamofire

/// 文件上传和下载
struct HttpFile {

    /// 文件上传的接口
    static var UPLOAD_API = ""
    static var UPLOAD_KEY = "file"

    /// 上传文件
    ///
    /// - Parameters:
    ///   - url:  接口地址
    ///   - data:  需要上传的数据
    ///   - withName: key名
    ///   - fileName: 文件名
    ///   - mimeType: 文件类型
    ///   - onEnd: 结束的回调
    /// - Returns:
    @discardableResult
    static func upload(url: String = UPLOAD_API, data: Data,
                       withName: String = UPLOAD_KEY, fileName: String? = nil, mimeType: String? = nil,
                       query: Parameters? = nil,
                       onEnd: @escaping (_ fileBean: FileBean?, _ error: Error?) -> Void) -> UploadRequest {
        let formData = MultipartFormData()

        let fileName = fileName ?? "\(data.toMd5()).png"
        let mimeType = mimeType ?? data.mimeType()

        print(threadName(), "上传:", fileName, mimeType)

        formData.append(data, withName: withName, fileName: fileName, mimeType: mimeType)
        return Http.upload(connectUrl(url: url), multipartFormData: formData, query: query)
                .uploadProgress {
                    print(threadName(), "上传进度:", $0, "\($0.fractionCompleted * 100)%")
                }
                .validateAuth()
                .validateCode()
                .requestBean { (bean: HttpBean<FileBean>?, error: Error?) in
                    onEnd(bean?.data, error)
                } as! UploadRequest
    }

    @discardableResult
    static func upload(url: String = UPLOAD_API, fileURL: URL,
                       withName: String = UPLOAD_KEY, fileName: String? = nil, mimeType: String? = nil,
                       query: Parameters? = nil,
                       onEnd: @escaping (_ fileBean: FileBean?, _ error: Error?) -> Void) -> UploadRequest {
        let formData = MultipartFormData()

        let fileName = fileName ?? fileURL.lastPathComponent
        let mimeType = mimeType ?? fileURL.path.mimeType()

        print(threadName(), "上传:", fileName, mimeType)

        formData.append(fileURL, withName: withName, fileName: fileName, mimeType: mimeType)
        return Http.upload(connectUrl(url: url), multipartFormData: formData, query: query)
                .uploadProgress {
                    print(threadName(), "上传进度:", $0, "\($0.fractionCompleted * 100)%")
                }
                .validateAuth()
                .validateCode()
                .requestBean { (bean: HttpBean<FileBean>?, error: Error?) in
                    onEnd(bean?.data, error)
                } as! UploadRequest
    }

    /// 秒传检查
    @discardableResult
    static func uploadCheck(url: String = UPLOAD_API, md5: String, onEnd: @escaping (_ fileBean: FileBean?, _ error: Error?) -> Void) -> DataRequest {
        Api.post(connectUrl(url: url), query: ["md5Code": md5])
                .validateAuth()
                .validateCode()
                .requestBean { (bean: HttpBean<FileBean>?, error: Error?) in
                    if let data = bean?.data {
                        print("秒传:\(md5)返回:\(data)")
                    }
                    onEnd(bean?.data, error)
                }
    }
}
