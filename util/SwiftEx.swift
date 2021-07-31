//
//  SwiftEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/27.
//

import Foundation

extension NSObject {

    /// 模拟kotlin的apply
    @discardableResult
    func apply<T: NSObject>(_ action: (T) -> Void) -> T {
        let this = self as! T
        action(this)
        return this
    }

    /// 模拟kotlin的run
    @discardableResult
    func run<This, Result>(_ action: (This) -> Result) -> Result {
        let this = self as! This
        let result = action(this)
        return result
    }

    // MARK:返回className

    var className: String {
        get {
            //"Wayto_GBSecurity_iOS.LoginController"
            let name = type(of: self).description()
            if (name.contains(".")) {
                return name.components(separatedBy: ".")[1];
            } else {
                return name;
            }
        }
    }
}

