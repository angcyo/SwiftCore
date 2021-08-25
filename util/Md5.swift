//
// Created by angcyo on 21/08/24.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG
import CryptoKit

///https://stackoverflow.com/questions/32163848/how-can-i-convert-a-string-to-an-md5-hash-in-ios-using-swift/32166735
func md5(string: String) -> Data {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    let messageData = string.data(using: .utf8)!
    var digestData = Data(count: length)

    _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
        messageData.withUnsafeBytes { messageBytes -> UInt8 in
            if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                let messageLength = CC_LONG(messageData.count)
                CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
            }
            return 0
        }
    }
    return digestData
}

func md5String(string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}

extension String {

    ///md5Hex: 8b1a9953c4611296a827abf8c47804d7
    func toMd5() -> String {
        let md5Data = md5(string: self)
        let md5Hex = md5Data.map {
            String(format: "%02hhx", $0)
        }.joined()
        return md5Hex
    }

    ///md5Base64: ixqZU8RhEpaoJ6v4xHgE1w==
    func toBase64() -> String {
        let md5Data = md5(string: self)
        return md5Data.base64EncodedString()
    }

    ///https://stackoverflow.com/questions/31859185/how-to-convert-a-base64string-to-string-in-swift

    /// 将base64字符串解码
    func base64Decode() -> Data {
        Data(base64Encoded: self)!
    }

    func base64DecodeString() -> String {
        base64Decode().toString()
    }
}

extension Data {
    func toMd5() -> String {
        let digest = Insecure.MD5.hash(data: self)
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }

    func toBase64() -> String {
        let md5Data = self
        return md5Data.base64EncodedString()
    }
}