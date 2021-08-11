//
// Created by wayto on 2021/7/30.
//

import Foundation
import Toast_Swift

/// 快速显示一个toast
func toast(_ message: String?,
           duration: TimeInterval = ToastManager.shared.duration,
           position: ToastPosition = ToastManager.shared.position,
           title: String? = nil,
           image: UIImage? = nil,
           style: ToastStyle = ToastManager.shared.style,
           completion: ((_ didTap: Bool) -> Void)? = nil) {
    UIApplication.mainWindow?.makeToast(message,
            duration: duration,
            position: position,
            title: title,
            image: image,
            style: style,
            completion: completion)
}

func toastTop(_ message: String?,
              duration: TimeInterval = ToastManager.shared.duration,
              position: ToastPosition = .top,
              title: String? = nil,
              image: UIImage? = nil,
              style: ToastStyle = ToastManager.shared.style,
              completion: ((_ didTap: Bool) -> Void)? = nil) {
    UIApplication.mainWindow?.makeToast(message,
            duration: duration,
            position: position,
            title: title,
            image: image,
            style: style,
            completion: completion)
}