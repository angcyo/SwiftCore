//
// Created by angcyo on 21/08/18.
//

import Foundation
import UIKit

/// 扩展cell时的基协议, 方便继承查找
protocol IDslCell {

}

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