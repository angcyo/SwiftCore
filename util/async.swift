//
//  async.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/27.
//

import Foundation

/**
 主线程执行
 - Parameters:
   - delay: 延迟时长, 秒. 支持小数.
   - qos: 调度质量要求
   - action: 执行回调*/
func doMain(_ delay: Float = 0, _ qos: DispatchQoS = .userInitiated, action: @escaping @convention(block) () -> Void) {
    //print(delay)
    if delay <= 0 {
        DispatchQueue.main.async(qos: qos, execute: action)
    } else {
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(delay), qos: qos, execute: action)
    }
}

/**后台执行*/
func doBack(_ delay: Float = 0, _ qos: DispatchQoS = .background, action: @escaping @convention(block) () -> Void) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + TimeInterval(delay), qos: qos, execute: action)
}

/// 在子线程等待异步方法结束, 再继续执行
func syncWith(_ async: @escaping (DispatchSemaphore) -> Void) {
    let semaphore = DispatchSemaphore(value: 0)
    DispatchQueue.global(qos: .background).async {
        async(semaphore)
    }
    semaphore.wait()
    //semaphore.signal() //请记得调用
}

/// GCD定时器倒计时
///
/// - Parameters:
///   - timeInterval: 间隔时间, 秒
///   - repeatCount: 重复次数
///   - handler: 循环事件,闭包参数: 1.timer 2.剩余执行次数
@discardableResult
func dispatchTimer(timeInterval: Double, repeatCount: Int, handler: @escaping (DispatchSourceTimer?, Int) -> Void) -> DispatchSourceTimer? {
    if repeatCount <= 0 {
        return nil
    }
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    var count = repeatCount
    timer.schedule(deadline: .now(), repeating: timeInterval)
    timer.setEventHandler {
        count -= 1
        DispatchQueue.main.async {
            handler(timer, count)
        }
        if count == 0 {
            timer.cancel()
        }
    }
    timer.resume()
    return timer
}

/// GCD实现定时器
///
/// - Parameters:
///   - timeInterval: 间隔时间
///   - handler: 事件
///   - needRepeat: 是否重复
func dispatchTimer(timeInterval: Double, handler: @escaping (DispatchSourceTimer?) -> Void, needRepeat: Bool) {

    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    timer.schedule(deadline: .now(), repeating: timeInterval)
    timer.setEventHandler {
        DispatchQueue.main.async {
            if needRepeat {
                handler(timer)
            } else {
                timer.cancel()
                handler(nil)
            }
        }
    }
    timer.resume()

}