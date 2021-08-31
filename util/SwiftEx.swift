//
//  SwiftEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/27.
//

import Foundation

extension String {
    func toClass() -> AnyClass? {
        NSClassFromString(self)
    }
}

@discardableResult
public func with<T>(_ value: T, _ modifier: (inout T) -> Void) -> T {
    var value = value
    modifier(&value)
    return value
}

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

    /// 返回全包名类名 //"Wayto_GBSecurity_iOS.LoginController"
    var className: String {
        get {
            type(of: self).description()
        }
    }

    /// 返回无包名的类名 //"LoginController"
    var simpleClassName: String {
        get {
            //NSStringFromClass(type(of: self))
            let name = type(of: self).description()
            if (name.contains(".")) {
                return name.components(separatedBy: ".")[1];
            } else {
                return name;
            }
        }
    }

    /// 判断对象是否是指定的类
    func isEqualClassName(_ cls: AnyClass) -> Bool {
        let type = type(of: self)
        if type.description() == cls.description() {
            return true
        }
        return false
    }

    // MARK: 对象扩展

    /// 设置对象数据
    func setObject(_ key: inout  String, _ value: Any?, _ policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, &key, value, policy)
    }

    /// 获取对象数据
    func getObject(_ key: inout String) -> Any? {
        objc_getAssociatedObject(self, &key)
    }
}

/// 打印xxx
func logIvarList(_ cls: AnyClass?) {
    var count: UInt32 = 0
    if let ivars = class_copyIvarList(cls, &count) {
        for i in 0..<count {
            let ivar = ivars[Int(i)];
            print("name:\(ivar_getName(ivar)) type:\(ivar_getTypeEncoding(ivar))")
        }
    }
}




