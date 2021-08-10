//
// Created by wayto on 2021/8/2.
//

import Foundation
import UIKit

/// Cell只包含界面元素, 所有操作在对应的DslItem中进行
protocol DslCell {
}

extension UITableViewCell: DslCell {

    /// 获取当前cell直属UITableView的UIView
    var itemCellView: UIView {
        var result: UIView = self
        var parentView: UIView? = self
        while (parentView != nil) {
            let p = parentView?.superview

            if (p is UITableView) {
                result = parentView!
                parentView = nil
            } else {
                parentView = p
            }
        }
        return result
    }
}

extension UICollectionViewCell: DslCell {

    /// 获取当前cell直属UICollectionView的UIView
    var itemCellView: UIView {
        var result: UIView = self
        var parentView: UIView? = self
        while (parentView != nil) {
            let p = parentView?.superview

            if (p is UICollectionView) {
                result = parentView!
                parentView = nil
            } else {
                parentView = p
            }
        }
        return result
    }
}