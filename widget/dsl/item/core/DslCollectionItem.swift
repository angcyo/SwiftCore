//
// Created by angcyo on 21/08/09.
//

import Foundation
import UIKit
import TangramKit

/// 作用于 [UICollectionView]

class DslCollectionItem: DslItem {

    /// span 占用宽度的多少分之一
    /// -1表示占满宽度,
    /// 不指定则使用[itemWidth]指定的宽度
    var itemSpan: Int? = nil//UITableView.automaticDimension

    /// section margin
    var itemSectionEdgeInset: UIEdgeInsets? = nil

    /// section 中item的列间距
    var itemSectionInteritemSpacing: CGFloat? = nil

    /// section 中item的行间距
    var itemSectionLineSpacing: CGFloat? = nil

    public required init() {
        super.init()
    }

    override func initItem() {
        super.initItem()
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)
    }
}

class DslCollectionCell: UICollectionViewCell, IDslCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        L.i("创建cell:\(self):\(frame):\(reuseIdentifier)")
        initCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        L.i("创建cell:\(self):\(coder)")
        initCell()
    }

    deinit {
        L.w("->销毁:\(self)")
    }

    ///  自定义的cell需要放在这里
    override var contentView: UIView {
        super.contentView
    }

    /// 初始化对象, 设置控件初始化位置等
    func initCell() {

    }

    /// [自动赋值]
    weak var _item: DslItem? = nil

    /// 请重写此方法
    func getCellConfig() -> IDslCellConfig? {
        nil
    }

    // 重写此方法, 在复用之前准备cell
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepareForReuse")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
    }

    /// 添加控件到内容视图中
    @discardableResult
    func renderCell<T: UIView>(_ view: T, _ action: ((T) -> Void)? = nil) -> T {
        contentView.render(view, action)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    override func sizeToFit() {
        super.sizeToFit()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        super.systemLayoutSizeFitting(targetSize)
    }

    /// 计算cell的size
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        if let item = _item {
            if item.itemHeight == UITableView.automaticDimension {
                // 自适应高度
                let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
                attributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            }
        }

        return attributes
    }
}