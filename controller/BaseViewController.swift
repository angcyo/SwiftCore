//
// Created by wayto on 2021/7/30.
//

import Foundation
import UIKit
import RxSwift

/// base by Rx
open class BaseViewController: UIViewController, INavigation {

    //Rx 自动取消订阅,
    lazy var disposeBag: DisposeBag = {
        DisposeBag()
    }()

    /// 数据/对象存储
    var controllerData: [Any] = []

    public init() {
        super.init(nibName: nil, bundle: nil)
        //bounds:(0.0, 0.0, 375.0, 812.0)
        L.i("->创建:\(self):\(modalPresentationStyle.rawValue)") //pageSheet
        initController()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: 状态栏

    /// 状态栏样式
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        // 白色字体的状态栏
        //.lightContent
        //黑色字体
        //.darkContent
        //默认
        .default
    }

    open override var prefersStatusBarHidden: Bool {
        super.prefersStatusBarHidden
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        super.preferredStatusBarUpdateAnimation
    }

    //MARK: INavigation

    var showNavigationBar: Bool = true
    var showToolbar: Bool = false

    /// 构造方法中回调, 请勿在此方法中使用view, 否则会触发viewDidLoad
    func initController() {
        //init
    }

    /// 保存对象, 防止被ARC回收. 通常delegate都需要保存起来
    func holdObj(_ obj: Any) {
        controllerData.append(obj)
    }

    /// 隐藏导航栏下的阴影
    func hideNavigationShadow() {
        setNavigationShadowColor(UIColor.clear)
    }

    func ensureNavigationStyle() {
        if navigationItem.standardAppearance == nil {
            navigationItem.standardAppearance = UINavigationBarAppearance()
        }
    }

    func setNavigationShadowColor(_ color: UIColor?) {
        ensureNavigationStyle()
        navigationItem.standardAppearance?.shadowColor = color
    }

    /// 当界面需要显示时, 更新导航栏
    func updateNavigationStyle(navigation: UINavigationController) {
        //do
        //navigation.setNavigationBarHidden(!showNavigationBar, animated: false)
        //navigation.setToolbarHidden(!showToolbar, animated: false)
    }

    open override func loadView() {
        super.loadView()
        L.d("->\(self):\(view.bounds):\(view.safeAreaInsets):\(view.safeAreaLayoutGuide)")
    }

    /// 加载试图
    open override func viewDidLoad() {
        super.viewDidLoad()
        L.d("->\(self):\(view.bounds):\(view.safeAreaInsets):\(view.safeAreaLayoutGuide)")
        initControllerView()
    }

    /// 重写此方法, 实现视图布局
    func initControllerView() {
        //L.i("initController:\(self):bounds:\(view.bounds)")
        view.backgroundColor = Res.color.controllerBackgroundColor
    }

    /// 试图将要显示, 从后台切回来时, 不会触发. 只会触发Scene相关的生命周期
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        L.d("\(self):\(view.bounds):\(view.safeAreaInsets):\(view.safeAreaLayoutGuide)")

        //update style
        if let navigation = navigationController {
            updateNavigationStyle(navigation: navigation)
        }
    }

    /// 试图已显示
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        L.i("\(self):\(view.bounds):\(view.safeAreaInsets):\(view.safeAreaLayoutGuide)")
    }

    /// 试图将要消失
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        L.d("\(self):\(view.bounds):\(view.safeAreaInsets):\(view.safeAreaLayoutGuide)")
    }

    /// 试图已消失
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        L.i("viewDidDisappear:\(self):\(view.bounds):\(view.safeAreaInsets):\(view.safeAreaLayoutGuide)")
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    open override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> ())?) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    open override func dismiss(animated flag: Bool, completion: (() -> ())?) {
        super.dismiss(animated: flag, completion: completion)
    }

    open override func show(_ vc: UIViewController, sender: Any?) {
        super.show(vc, sender: sender)
    }

    open override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        super.showDetailViewController(vc, sender: sender)
    }

    /// Swift 的ARC, 在创建对象之后, 没有被引用会立马被回收.
    /// https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
    deinit {
        L.w("->销毁:\(self)")
    }
}