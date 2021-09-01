//
// Created by angcyo on 21/08/24.
//

import Foundation
import SwiftyJSON

/// 表单文件解析, 上传, 塞入新值
class FormFileHelper {

    /// 表单文件, 将文件md5和对象对应存放在此
    /// md5用于在表单obtain中作为文件对象的占位, 文件上传完之后,替换掉
    static var formFile: [String: FormFile] = [:]

    /// 上传缓存, md5 : FileBean
    static var formFileBean: [String: FileBean] = [:]

    /// 当前值, 是否包含需要上传的文件, value 不包含分隔符
    static func haveFormFile(md5: String) -> Bool {
        for key in formFile.keys {
            if md5 == key {
                return true
            }
        }
        return false
    }

    static func haveFormFile(md5List: [String]) -> Bool {
        var have = false
        for md5 in md5List {
            have = haveFormFile(md5: md5)
            if have {
                break
            }
        }
        return have
    }

    static func findFormFile(md5: String) -> FormFile? {
        for key in formFile.keys {
            if md5 == key {
                return formFile[md5]
            }
        }
        return nil
    }

    //MARK: 成员

    /// 上传的接口地址
    var url: String? = nil

    var _targetJson: JSON? = nil

    /// 结束的回调,子线程回调
    var onUploadEnd: ((JSON?, Error?) -> Void)? = nil

    /// 回调获取对应的查询参数
    var onConfigQueryParameters: ((_ md5: String) -> [String: Any])? = nil

    /// 开始上传
    func startUpload(json: JSON) {
        _targetJson = json
        _parseFile()
        doBack {
            self._startUploadInner()
        }
    }

    //MARK: 准备

    /// json路径下, 需要上传的文件md5值和deepKey集合
    var needUploadValue: [String: [String]] = [:]
    /// 需要上传的所有文件md5, 扁平化, 方便枚举
    var needUploadFile: [String] = []

    /// 从对象中, 解析出需要上传的文件信息
    func _parseFile() {
        _targetJson?.each { deepKey, value in
            if value.object is String {
                let valueList = value.stringValue.splitString(separator: FormParams.SPILT)
                if FormFileHelper.haveFormFile(md5List: valueList) {
                    needUploadValue.add([deepKey: valueList])
                    needUploadFile.addAll(valueList)
                }
            }
        }
    }

    /// 正在上传的
    var _uploadIndex: Int = 0

    func _startUploadInner() {
        let count = needUploadFile.count
        if _uploadIndex >= count {
            // 上传结束
            _uploadEnd()
        } else {
            let md5 = needUploadFile[_uploadIndex] //md5

            if let _ = FormFileHelper.formFileBean[md5] {
                // 已有缓存
                self._next()
            } else if let formFile = FormFileHelper.findFormFile(md5: md5) {
                _checkFile(md5: md5) {
                    if let bean = $0 {
                        //秒传完成, 下一个
                        FormFileHelper.formFileBean.add([md5: bean])
                        self._next()
                    } else {
                        if formFile is Data {
                            HttpFile.upload(url: self.url ?? HttpFile.UPLOAD_API, data: formFile as! Data, query: self.onConfigQueryParameters?(md5)) { fileBean, error in
                                if let error = error {
                                    //上传失败
                                    self.onUploadEnd?(self._targetJson, error)
                                } else {
                                    //下一个
                                    FormFileHelper.formFileBean.add([md5: fileBean!])
                                    self._next()
                                }
                            }
                        } else if formFile is URL {
                            HttpFile.upload(url: self.url ?? HttpFile.UPLOAD_API, fileURL: formFile as! URL, query: self.onConfigQueryParameters?(md5)) { fileBean, error in
                                if let error = error {
                                    //上传失败
                                    self.onUploadEnd?(self._targetJson, error)
                                } else {
                                    //下一个
                                    FormFileHelper.formFileBean.add([md5: fileBean!])
                                    self._next()
                                }
                            }
                        } else {
                            //未知类型
                            self._next()
                        }
                    }
                }
            } else {
                //非需要上传的文件
                _next()
            }
        }
    }

    func _next() {
        _uploadIndex += 1
        doBack {
            if let _ = self._targetJson {
                self._startUploadInner()
            } else {
                self.onUploadEnd?(nil, error("json为空,取消上传."))
            }
        }
    }

    func _checkFile(md5: String, onEnd: @escaping (FileBean?) -> Void) {
        HttpFile.uploadCheck(url: url ?? HttpFile.UPLOAD_API, md5: md5) { fileBean, error in
            onEnd(fileBean)
        }
    }

    /// 上传结束之后, 替换原来的占位值.
    func _uploadEnd() {
        needUploadValue.forEach { deepKey, md5List in
            var value = ""
            md5List.forEachIndex { md5, index in
                let fileId: String
                if let bean = FormFileHelper.formFileBean[md5] {
                    // 上传文件成功后的bean
                    fileId = bean.id?.toString() ?? ""
                } else {
                    // 原值
                    fileId = md5
                }
                if index > 0 {
                    value.append(FormParams.MULTI_SPILT)
                }
                value.append(fileId)
            }

            // 赋值到json
            _targetJson?.put(deepKey, value)
        }

        //子线程回调
        if let json = _targetJson {
            onUploadEnd?(json, nil)
        } else {
            onUploadEnd?(nil, error("json为空,取消上传."))
        }
    }
}
