//
// Created by wayto on 2021/7/30.
//

import Foundation
import UIKit
import RxSwift

/// base by Rx
class BaseViewController: UIViewController, Navigation {

    //Rx 自动取消订阅,
    lazy var disposeBag: DisposeBag = {
        DisposeBag()
    }()

    /// 数据/对象存储
    var controllerData: [Any] = []

    init() {
        super.init(nibName: nil, bundle: nil)
        debugPrint("\(threadName())->创建:\(self):\(modalPresentationStyle.rawValue)") //pageSheet
        initController()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: 状态栏

    /// 状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // 白色字体的状态栏
        //.lightContent
        //黑色字体
        //.darkContent
        //默认
        .default
    }

    override var prefersStatusBarHidden: Bool {
        super.prefersStatusBarHidden
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        super.preferredStatusBarUpdateAnimation
    }

    var showNavigationBar: Bool = true

    /// 此方法会在[viewDidLoad]之后触发
    func initController() {
        //init
        debugPrint("initController:\(self):\(view.bounds)")
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

    override func loadView() {
        super.loadView()
        debugPrint("\(threadName())->加载试图:\(self)")
    }

    /// 加载试图
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("viewDidLoad:\(self):\(view.bounds)")
    }

    /// 试图将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    /// 试图已显示
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    /// 试图将要消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    /// 试图已消失
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> ())?) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    override func dismiss(animated flag: Bool, completion: (() -> ())?) {
        super.dismiss(animated: flag, completion: completion)
    }

    override func show(_ vc: UIViewController, sender: Any?) {
        super.show(vc, sender: sender)
    }

    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        super.showDetailViewController(vc, sender: sender)
    }

    /// Swift 的ARC, 在创建对象之后, 没有被引用会立马被回收.
    /// https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html
    deinit {
        debugPrint("\(threadName())->销毁:\(self)")
    }
}