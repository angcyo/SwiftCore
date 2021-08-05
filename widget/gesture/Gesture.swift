//
// Created by wayto on 2021/8/3.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture

///https://github.com/RxSwiftCommunity/RxGesture

/* 单击
 view.rx
  .tapGesture()
  .when(.recognized)
  .subscribe(onNext: { _ in
    //react to taps
  })
  .disposed(by: stepBag)
 */

/* 多个手势
 view.rx
  .anyGesture(.tap(), .swipe([.up, .down]))
  .when(.recognized)
  .subscribe(onNext: { _ in
    //dismiss presented photo
  })
  .disposed(by: stepBag)
 */

/*

view.rx.tapGesture()           -> ControlEvent<UITapGestureRecognizer>
view.rx.pinchGesture()         -> ControlEvent<UIPinchGestureRecognizer>
view.rx.swipeGesture(.left)    -> ControlEvent<UISwipeGestureRecognizer>
view.rx.panGesture()           -> ControlEvent<UIPanGestureRecognizer>
view.rx.longPressGesture()     -> ControlEvent<UILongPressGestureRecognizer>
view.rx.rotationGesture()      -> ControlEvent<UIRotationGestureRecognizer>
view.rx.screenEdgePanGesture() -> ControlEvent<UIScreenEdgePanGestureRecognizer>
view.rx.hoverGesture()         -> ControlEvent<UIHoverGestureRecognizer>

view.rx.anyGesture(.tap(), ...)           -> ControlEvent<UIGestureRecognizer>
view.rx.anyGesture(.pinch(), ...)         -> ControlEvent<UIGestureRecognizer>
view.rx.anyGesture(.swipe(.left), ...)    -> ControlEvent<UIGestureRecognizer>
view.rx.anyGesture(.pan(), ...)           -> ControlEvent<UIGestureRecognizer>
view.rx.anyGesture(.longPress(), ...)     -> ControlEvent<UIGestureRecognizer>
view.rx.anyGesture(.rotation(), ...)      -> ControlEvent<UIGestureRecognizer>
view.rx.anyGesture(.screenEdgePan(), ...) -> ControlEvent<UIGestureRecognizer>
view.rx.anyGesture(.hover(), ...)         -> ControlEvent<UIGestureRecognizer>

 */

extension UIView {

    /// 点击事件
    func onClick(bag: DisposeBag, _ action: @escaping (UITapGestureRecognizer) -> Void) {
        rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { event in
                    action(event)
                })
                .disposed(by: bag)
    }
}