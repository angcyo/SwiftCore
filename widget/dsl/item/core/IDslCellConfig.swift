//
// Created by angcyo on 21/08/18.
//

import Foundation
import UIKit

/// cell中界面的配置
protocol IDslCellConfig {

    /// 初始化 [UITableCell]或者[UICollectionCell]
    func initCellConfig(_ cell: UIView)
}