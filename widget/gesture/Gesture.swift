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
        rx.tapGesture { (gesture: UITapGestureRecognizer, delegate: GenericRxGestureRecognizerDelegate<UITapGestureRecognizer>) in
                    delegate.touchReceptionPolicy = .custom { (gesture: UITapGestureRecognizer, touch: RxGestureTouch) in
                        TargetObserver.shouldReceiveTouch(gesture, shouldReceive: touch)
                    }
                }
                .when(.recognized) //UIGestureRecognizer.State
                .subscribe(onNext: { event in
                    action(event)
                })
                .disposed(by: bag)
    }

    /// 长按事件
    func onLongClick(bag: DisposeBag, _ states: [RxGestureRecognizerState] = [.recognized], _ action: @escaping (UILongPressGestureRecognizer) -> Void) {
        rx.longPressGesture()
                .filter { gesture in
                    states.contains(gesture.state)
                }
                .subscribe(onNext: { event in
                    action(event)
                })
                .disposed(by: bag)
    }

    /// 捏合手势
    func onPinch(bag: DisposeBag, _ states: [RxGestureRecognizerState] = [.recognized], _ action: @escaping (UIPinchGestureRecognizer) -> Void) {
        rx.pinchGesture()
                .filter { gesture in
                    states.contains(gesture.state)
                }
                .subscribe(onNext: { event in
                    action(event)
                })
                .disposed(by: bag)
    }

    /// 轻扫手势, 通常用来实现侧滑菜单
    func onSwipe(_ directions: SwipeDirection = .left, bag: DisposeBag, _ states: [RxGestureRecognizerState] = [.recognized], _ action: @escaping (UISwipeGestureRecognizer) -> Void) {
        rx.swipeGesture(directions)
                .filter { gesture in
                    states.contains(gesture.state)
                }
                .subscribe(onNext: { event in
                    action(event)
                })
                .disposed(by: bag)
    }

    /// 平移手势, 拖动/拖拽手势
    func onPan(bag: DisposeBag, _ states: [RxGestureRecognizerState] = [.recognized], _ action: @escaping (UIPanGestureRecognizer) -> Void) {
        rx.panGesture()
                .filter { gesture in
                    states.contains(gesture.state)
                }
                .subscribe(onNext: { event in
                    action(event)
                })
                .disposed(by: bag)
    }

    /// 边界平移手势
    func onEdgePan(bag: DisposeBag, _ states: [RxGestureRecognizerState] = [.recognized], _ action: @escaping (UIScreenEdgePanGestureRecognizer) -> Void) {
        rx.screenEdgePanGesture()
                .filter { gesture in
                    states.contains(gesture.state)
                }
                .subscribe(onNext: { event in
                    action(event)
                })
                .disposed(by: bag)
    }

    /// 旋转手势
    func onRotation(bag: DisposeBag, _ states: [RxGestureRecognizerState] = [.recognized], _ action: @escaping (UIRotationGestureRecognizer) -> Void) {
        rx.rotationGesture()
                .filter { gesture in
                    states.contains(gesture.state)
                }
                .subscribe(onNext: { event in
                    action(event)
                })
                .disposed(by: bag)
    }
}