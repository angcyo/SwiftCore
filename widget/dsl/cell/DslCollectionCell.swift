//
// Created by angcyo on 21/08/09.
//

import Foundation
import UIKit

class DslCollectionCell: UICollectionViewCell, DslCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        debugPrint("\(threadName())->销毁:\(self)")
    }

    override var contentView: UIView {
        super.contentView
    }

    func initCell() {

    }

    // 重写此方法, 在复用之前准备cell
    override func prepareForReuse() {
        super.prepareForReuse()
        debugPrint("prepareForReuse")
    }

    /// [自动赋值] @selector(createTableViewCell:cellForRowAt:item:)
    weak var _item: DslItem? = nil

    func onBindCollectionCell(_ tableView: DslCollectionView, _ indexPath: IndexPath, _ item: DslItem) {
        debugPrint("onBindCollectionCell:\(indexPath)")
        item.itemUpdate = false
        item.onBindCollectionCell?(self, indexPath)
    }
}