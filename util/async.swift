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
func doMain(_ delay: Float = 0, _ qos: DispatchQoS = .userInitiated, action: @escaping () -> Void) {
    //print(delay)
    DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(delay), qos: qos, execute: action)
}

/**后台执行*/
func doBack(_ delay: Float = 0, _ qos: DispatchQoS = .background, action: @escaping () -> Void) {
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
