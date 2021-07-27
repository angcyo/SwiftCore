//
//  SwiftEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/27.
//

import Foundation

extension NSObject {

    /**模拟kotlin的apply*/
    func apply<This: NSObject>(_ action: (This) -> Void) -> This {
        let this = self as! This
        action(this)
        return this
    }

    /**模拟kotlin的run*/
    func run<This: NSObject, Result>(_ action: (This) -> Result) -> Result {
        let this = self as! This
        let result = action(this)
        return result
    }
}
