//
// Created by angcyo on 21/08/24.
//

import Foundation

extension URL {

    func isHttp() -> Bool {
        scheme?.starts(with: "http") == true
    }

    func isFile() -> Bool {
        isFileURL
    }

    ///absoluteString "http://test.kaiyang.wayto.com.cn/kaiyangQys/kyQys/getAuth?faceOcrResultId=1&backOcrResultId=2"
    ///host "test.kaiyang.wayto.com.cn"
    ///path "/kaiyangQys/kyQys/getAuth"
    ///query "faceOcrResultId=1&backOcrResultId=2"
    ///scheme "http"
    ///port nil
    ///url "http://test.kaiyang.wayto.com.cn/kaiyangQys/kyQys/getAuth?faceOcrResultId=1&backOcrResultId=2"
}