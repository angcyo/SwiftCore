//
// Created by angcyo on 21/09/08.
//

import Foundation
import RxSwift

///# https://github.com/ReactiveX/RxSwift
///pod 'RxSwift', '6.2.0'
/// https://beeth0ven.github.io/RxSwift-Chinese-Documentation/


///调度器
///https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/schedulers.html

/// 主线程操作UI, 否则会异常
/// Modifications to the layout engine must not be performed from a background thread after it has been accessed from the main thread.


/// 主线程调度
func mainScheduler() -> MainScheduler {
    MainScheduler.instance
}

func operationScheduler(operationQueue: OperationQueue, queuePriority: Operation.QueuePriority = .normal) -> OperationQueueScheduler {
    OperationQueueScheduler(operationQueue: operationQueue, queuePriority: queuePriority)
}

/// 串行调度
func serialScheduler() -> SerialDispatchQueueScheduler {
    SerialDispatchQueueScheduler(qos: .userInitiated)
}

/// 并行调度
func concurrentScheduler() -> ConcurrentDispatchQueueScheduler {
    ConcurrentDispatchQueueScheduler(qos: .userInitiated)
}

extension PrimitiveSequence {

    /// 延迟
    func delay(_ milliseconds: Int = 0, scheduler: SchedulerType = serialScheduler()) -> PrimitiveSequence<Trait, Element> {
        delay(.milliseconds(milliseconds), scheduler: scheduler)
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait {

    /// 延迟执行
    func onDelay(_ milliseconds: Int = 0,
                 scheduler: SchedulerType = serialScheduler(),
                 action: (() -> Void)? = nil) -> PrimitiveSequence<Trait, Element> {
        primitiveSequence.delay(milliseconds, scheduler: scheduler).map {
            action?()
            return $0
        }
    }
}

struct Rx {

    /// 延迟一段时间执行
    static func onDelay(_ milliseconds: Int = 0,
                        scheduler: SchedulerType = SerialDispatchQueueScheduler(qos: .userInitiated),
                        action: (() -> Void)? = nil) -> Single<Double> {
        Observable.just(nowTime, scheduler: scheduler).asSingle()
                .delay(milliseconds, scheduler: scheduler)
                .map {
                    action?()
                    return $0
                }
                .subscribe(on: scheduler)
                .observe(on: scheduler)
    }

    /// 后台执行
    @discardableResult
    static func onBack(_ milliseconds: Int,
                       scheduler: SchedulerType = SerialDispatchQueueScheduler(qos: .userInitiated),
                       action: (() -> Void)? = nil) -> Disposable {
        onDelay(milliseconds, scheduler: scheduler, action: action).subscribe()
    }
}
