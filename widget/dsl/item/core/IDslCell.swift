//
// Created by angcyo on 21/08/18.
//

import Foundation
import UIKit

/// 扩展cell时的基协议, 方便继承查找
public protocol IDslCell: AnyObject {

    /// [自动赋值]
    var _item: DslItem? { get set }

/*    /// 协议中需要访问的泛型, 需要在此声明. 用了泛型, 协议就没办法强转类型了.
    associatedtype CellConfig: IDslCellConfig

    /// 实现类
    var cellConfig: CellConfig { get set }*/

    ///改用方法的形式声明
    func getCellConfig() -> IDslCellConfig?
}

/// cell中界面的配置
public protocol IDslCellConfig {

    /// 获取跟视图, 此视图会被renderToCell
    func getRootView(_ cell: UIView) -> UIView

    /// 初始化 [UITableCell]或者[UICollectionCell]
    func initCellConfig(_ cell: UIView)
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

extension UIView {

    /// 内容控件
    var cellContentView: UIView {
        get {
            if let tableCell = self as? UITableViewCell {
                return tableCell.contentView
            } else if let collectionCell = self as? UICollectionViewCell {
                return collectionCell.contentView
            } else {
                return self
            }
        }
    }
}