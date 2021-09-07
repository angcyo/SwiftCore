//
// Created by angcyo on 21/08/06.
//

import Foundation
import UIKit
import RxKeyboard
import RxSwift

class BaseTableViewController: BaseViewController {

    lazy var dslTableView: DslTableView = {
        createTableView()
    }()

    /// 清理选中状态
    var clearsSelectionOnViewWillAppear: Bool = false

    /// 激活键盘监听
    var enableSoftInput: Bool = true {
        didSet {
            initKeyboard()
        }
    }

    /// 是否激活下拉刷新
    var enableRefresh: Bool = false {
        didSet {
            initRefresh()
        }
    }

    /// 创建视图
    func createTableView() -> DslTableView {
        DslTableView(frame: .zero, style: .plain)
        //.apply {
        //let insets = view.safeAreaInsets
        //print($0)
        //$0.safeAreaLayoutGuide.topAnchor.constraint(equalTo: navController.navigationBar.bottomAnchor)
        //$0.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor)
        //}
    }

    override func initControllerView() {
        super.initControllerView()
        //dslTableView = DslTableView()
        initTableView(tableView: dslTableView)
        initKeyboard()
        initRefresh()
    }

    /// 初始化
    func initTableView(tableView: DslTableView) {
        view.render(tableView)
        if tableView.frame.isEmpty {
            tableView.make {
                $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)

                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                //$0.bottom.equalTo(UIScreen.height)//view.safeAreaLayoutGuide.snp.bottom
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }
    }

    /// 键盘监听Bag
    lazy var keyboardBag: DisposeBag = {
        DisposeBag()
    }()

    /// 监听键盘
    func initKeyboard() {
        keyboardBag = DisposeBag()
        if enableSoftInput {
            //键盘监听
            RxKeyboard.instance.visibleHeight.drive(onNext: { height in
                let tableView = self.dslTableView
                let inset = tableView.contentInset
                tableView.contentInset = inset.resetBottom(height.toFloat())

                //滚动到具有接收者的当前行
                if let cell = tableView.findFirstResponder()?.findAttachedTableCell() {
                    if let index = tableView.indexPath(for: cell) {
                        tableView.scrollToRow(at: index, at: .top, animated: true)
                    }
                }
            }).disposed(by: keyboardBag)
        }
    }

    lazy var refreshControl: UIRefreshControl = {
        UIRefreshControl()
    }()

    func initRefresh() {
        if enableRefresh {
            dslTableView.refreshControl = refreshControl
            refreshControl.removeTarget(nil, action: nil, for: .valueChanged)
            refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        }
    }

    /// 刷新的回调
    @objc func onRefresh(_ sender: Any) {
        L.i("触发刷新:\(sender)")
        doMain(2) {
            self.refreshControl.endRefreshing()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if clearsSelectionOnViewWillAppear {
            dslTableView.cancelSelected()
        }
    }

    /*override func sceneDidBecomeActive(_ scene: UIScene) {
        super.sceneDidBecomeActive(scene)

        if enableSoftInput {
            let inset = dslTableView.contentInset
            doMain {
                self.dslTableView.contentInset = inset
            }
        }
    }*/
}