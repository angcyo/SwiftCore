# 2021-07-31

手势推荐库:

```
# https://github.com/RxSwiftCommunity/RxGesture
pod "RxGesture"
```

On iOS, RxGesture supports:

```
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
```