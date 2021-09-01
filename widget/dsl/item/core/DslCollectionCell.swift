//
// Created by angcyo on 21/08/09.
//

import Foundation
import UIKit

class DslCollectionCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        L.w("\(threadName())->销毁:\(self)")
    }

    override var contentView: UIView {
        super.contentView
    }

    func initCell() {

    }

    // 重写此方法, 在复用之前准备cell
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepareForReuse")
    }
}