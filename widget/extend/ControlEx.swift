//
// Created by angcyo on 21/08/20.
//

import Foundation
import UIKit

extension UIControl {

    /// 事件监听
    /// - Parameters:
    ///   - event:
    ///   - hold: 用来保持 Observer, 否则会被ARC回收
    ///   - action:
    /// - Returns:
    @discardableResult
    func onEvent(_ event: UIControl.Event, hold: NSObject? = nil, _ action: @escaping (UIResponder) -> Void) -> TargetObserver {
        let observer = TargetObserver()
        observer.onAction = action

        addTarget(observer,
                action: #selector(TargetObserver.onActionInner(sender:)),
                for: event)

        var key = "Event_\(event)"
        hold?.setObject(&key, observer)
        return observer
    }

    /// 移除监听
    func removeAllTarget(_ target: Any?, action: Selector? = nil, for controlEvents: UIControl.Event = .allEvents) {
        removeTarget(target, action: action, for: controlEvents)
    }
}