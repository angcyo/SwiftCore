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
        DslTableView(frame: view.bounds, style: .plain)
    }

    /// 初始化
    func initTableView(tableView: DslTableView) {
        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if clearsSelectionOnViewWillAppear {
            dslTableView.cancelSelected()
        }
    }
}