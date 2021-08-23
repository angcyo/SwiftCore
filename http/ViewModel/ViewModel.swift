//
// Created by wayto on 2021/7/31.
//

import Foundation
import RxSwift

/// vm
class ViewModel: NSObject {

    //let liveData = liveData("")

    required override init() {
        super.init()
        debugPrint("创建:\(self)")
    }

    /// Swift 的ARC, 在创建对象之后, 没有被引用会立马被回收.
    /// https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
    deinit {
        debugPrint("销毁:\(self)")
    }

    //Rx 自动取消订阅,
    lazy var disposeBag: DisposeBag = {
        DisposeBag()
    }()

    /// 取消所有订阅
    func reset() {
        disposeBag = DisposeBag()
    }
}