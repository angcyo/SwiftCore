//
// Created by wayto on 2021/7/30.
//

import Foundation
import UIKit
import RxSwift

/// base
class BaseUIViewController: UIViewController {

    //Rx 自动取消订阅,
    lazy var disposeBag: DisposeBag = {
        DisposeBag()
    }()

    /// 数据/对象存储
    var controllerData: [Any] = []

    /// 保存对象, 防止被ARC回收. 通常delegate都需要保存起来
    func holdObj(_ obj: Any) {
        controllerData.append(obj)
    }

    override func loadView() {
        super.loadView()
        debugPrint("加载试图:\(self)")
    }

    /// 加载试图
    override func viewDidLoad() {
        super.viewDidLoad()
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
        debugPrint("销毁:\(self)")
    }
}