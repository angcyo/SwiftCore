//
// Created by wayto on 2021/7/28.
//

import Foundation
import UIKit

extension Bundle {

    /// 从main bundle 中读取value
    static func get(_ key: String) -> Any? {
        Bundle.main.infoDictionary?[key]
    }

    /// 获取build
    static func versionCode() -> Int {
        Int(get("CFBundleVersion") as! String) ?? -1
    }

    /// 获取版本
    static func versionName() -> String {
        get("CFBundleShortVersionString") as! String
    }

    /// 获取显示的名字
    static func displayName() -> String {
        get("CFBundleDisplayName") as! String
    }

    /// 获取应用名
    static func appName() -> String {
        get("CFBundleName") as! String
    }

    static func bundleId() -> String {
        //Bundle.main.bundleIdentifier
        get("CFBundleIdentifier") as! String
    }

    /// 从 info plist 中读取value
    static func getPlist(_ key: String) -> Any? {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let data = NSDictionary(contentsOfFile: path)
        return data?[key]
    }

    /// 获取bundle 中的图片
    static func image(_ fileName: String) -> UIImage? {
//        guard let path = Bundle.main.path(forResource: fileName, ofType: nil)else {
//            return nil
//        }
        UIImage(named: fileName)
    }
}

func bundleOf(_ key: String) -> Any? {
    Bundle.get(key)
}