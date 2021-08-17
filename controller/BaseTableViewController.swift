//
// Created by angcyo on 21/08/06.
//

import Foundation
import UIKit

class BaseTableViewController: BaseViewController {

    lazy var dslTableView: DslTableView = {
        createTableView()
    }()

    /// 清理选中状态
    var clearsSelectionOnViewWillAppear: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //dslTableView = DslTableView()
        initTableView(tableView: dslTableView)
    }

    /// 创建视图
    func createTableView() -> DslTableView {
        DslTableView(frame: .zero, style: .plain)
        //.apply {
        //let insets = view.safeAreaInsets
        //debugPrint($0)
        //$0.safeAreaLayoutGuide.topAnchor.constraint(equalTo: navController.navigationBar.bottomAnchor)
        //$0.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor)
        //}
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if clearsSelectionOnViewWillAppear {
            dslTableView.cancelSelected()
        }
    }
}