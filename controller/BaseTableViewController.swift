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
    }

    /// 初始化
    func initTableView(tableView: DslTableView) {
        view.addSubview(tableView)
        if tableView.bounds.isEmpty {
            tableView.make { maker in
                maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                //maker.bottom.equalTo(UIScreen.height)//view.safeAreaLayoutGuide.snp.bottom
                maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                maker.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                maker.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            }
        }
    }

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if clearsSelectionOnViewWillAppear {
            dslTableView.cancelSelected()
        }
    }
}