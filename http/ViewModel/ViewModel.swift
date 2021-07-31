//
// Created by wayto on 2021/7/31.
//

import Foundation

/// vm
class ViewModel: NSObject {

    required override init() {
        //no op
    }

    /// Swift 的ARC, 在创建对象之后, 没有被引用会立马被回收.
    /// https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
    deinit {
        debugPrint("销毁:\(self)")
    }
}