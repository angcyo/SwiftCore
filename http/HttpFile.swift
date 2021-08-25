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
    @discardableResult
    static func upload(data: Data, withName: String = UPLOAD_KEY, fileName: String? = nil, mimeType: String? = nil, onEnd: @escaping (_ fileBean: FileBean?, _ error: Error?) -> Void) -> UploadRequest {
        let formData = MultipartFormData()

        let fileName = fileName ?? "\(data.toMd5()).png"
        let mimeType = mimeType ?? data.mimeType()

        print(threadName(), "上传:", fileName, mimeType)

        formData.append(data, withName: withName, fileName: fileName, mimeType: mimeType)
        return Http.upload(connectUrl(url: UPLOAD_API), multipartFormData: formData)
                .uploadProgress {
                    print(threadName(), "上传进度:", $0)
                }
                .validateAuth()
                .validateCode()
                .requestBean { (bean: HttpBean<FileBean>?, error: Error?) in
                    onEnd(bean?.data, error)
                } as! UploadRequest
    }

    @discardableResult
    static func upload(fileURL: URL, withName: String = UPLOAD_KEY, fileName: String? = nil, mimeType: String? = nil, onEnd: @escaping (_ fileBean: FileBean?, _ error: Error?) -> Void) -> UploadRequest {
        let formData = MultipartFormData()

        let fileName = fileName ?? fileURL.lastPathComponent
        let mimeType = mimeType ?? fileURL.path.mimeType()

        print(threadName(), "上传:", fileName, mimeType)

        formData.append(fileURL, withName: withName, fileName: fileName, mimeType: mimeType)
        return Http.upload(connectUrl(url: UPLOAD_API), multipartFormData: formData)
                .uploadProgress {
                    print(threadName(), "上传进度:", $0)
                }
                .validateAuth()
                .validateCode()
                .requestBean { (bean: HttpBean<FileBean>?, error: Error?) in
                    onEnd(bean?.data, error)
                } as! UploadRequest
    }

    /// 秒传检查
    @discardableResult
    static func uploadCheck(md5: String, onEnd: @escaping (_ fileBean: FileBean?, _ error: Error?) -> Void) -> DataRequest {
        Api.post(connectUrl(url: UPLOAD_API), query: ["md5Code": md5])
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
