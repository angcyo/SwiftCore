//
//  NotificationCenterEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/28.
//

import Foundation
import UIKit

// MARK: Notification Center

/****************	Notification Center	****************/

class NotifyObserver {

    /// dsl
    var onNotify: ((Any?) -> Void)? = nil

    /// 回调
    @objc func onNotifyInner(notify: Notification) {
        onNotify?(notify.object)
    }
}

/// 观察一个通知
func observerNotify(_ name: String, obj: Any? = nil, _ action: @escaping (Any?) -> Void) -> Any {
    let observer = NotifyObserver()
    observer.onNotify = action
    NotificationCenter.default.addObserver(observer,
            selector: #selector(NotifyObserver.onNotifyInner(notify:)),
            name: NSNotification.Name(rawValue: name),
            object: obj)
    return observer
}

/// 监听一次通知
func observerNotifyOnce(_ name: String, obj: Any? = nil, _ action: @escaping (Any?) -> Void) {
    var observer: Any? = nil
    observer = observerNotify(name, obj: obj) { obj in
        removeNotify(observer)
        action(obj)
    }
}

/// 发送一个通知
func postNotify(_ name: String, obj: Any? = nil) {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: obj)
}

/// 移除通知监听
func removeNotify(_ observer: Any?) {
    guard let observer = observer else {
        return
    }
    NotificationCenter.default.removeObserver(observer)
}