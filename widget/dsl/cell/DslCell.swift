//
// Created by wayto on 2021/8/2.
//

import Foundation

/// Cell只包含界面元素, 所有操作在对应的DslItem中进行
@objc protocol DslCell {

    func initCell()

    var _item: DslItem? { get set }

    @objc optional func onBindTableCell(_ tableView: DslTableView, _ indexPath: IndexPath, _ item: DslItem)

    @objc optional func onBindCollectionCell(_ tableView: DslCollectionView, _ indexPath: IndexPath, _ item: DslItem)

}