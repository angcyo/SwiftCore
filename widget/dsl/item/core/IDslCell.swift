//
// Created by angcyo on 21/08/18.
//

import Foundation
import UIKit

/// 扩展cell时的基协议, 方便继承查找
protocol IDslCell {

/*    /// 协议中需要访问的泛型, 需要在此声明. 用了泛型, 协议就没办法强转类型了.
    associatedtype CellConfig: IDslCellConfig

    /// 实现类
    var cellConfig: CellConfig { get set }*/

    ///改用方法的形式声明
    func getCellConfig() -> IDslCellConfig?
}

/// cell中界面的配置
protocol IDslCellConfig {

    /// 初始化 [UITableCell]或者[UICollectionCell]
    func initCellConfig(_ cell: UIView)

    /// 获取跟视图, 此视图会被renderToCell
    func getRootView() -> UIView
}

/// 扩展
extension IDslCell {

    /// 将[IDslCell]渲染到[UITableCell]或者[UICollectionCell]中
    func renderToCell(_ cell: Any, _ root: UIView) {
        if let tableCell = cell as? UITableViewCell {
            tableCell.contentView.render(root)
        } else if let collectionCell = cell as? UICollectionViewCell {
            collectionCell.contentView.render(root)
        }
    }
}