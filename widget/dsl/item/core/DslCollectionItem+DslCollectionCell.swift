//
// Created by angcyo on 21/08/09.
//

import Foundation
import UIKit
import TangramKit

/// 作用于 [UICollectionView]

open class DslCollectionItem: DslItem {

    /// span 占用宽度的多少分之一
    /// -1表示占满宽度,
    /// 不指定则使用[itemWidth]指定的宽度
    var itemSpan: Int? = 1//UITableView.automaticDimension

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

open class DslCollectionCell: UICollectionViewCell, IDslCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        L.i("创建cell:\(self):\(frame):\(reuseIdentifier)")
        initCell()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        L.i("创建cell:\(self):\(coder)")
        initCell()
    }

    deinit {
        L.w("->销毁:\(self)")
    }

    ///  自定义的cell需要放在这里
    open override var contentView: UIView {
        super.contentView
    }

    /// 初始化对象, 设置控件初始化位置等
    open func initCell() {
        //IDslCell
        if let cellConfig = getCellConfig() {
            cellConfig.initCellConfig(self)
            renderToCell(self, cellConfig.getRootView(self))
        }
    }

    /// [自动赋值]
    public weak var _item: DslItem? = nil

    /// 请重写此方法
    public func getCellConfig() -> IDslCellConfig? {
        nil
    }

    // 重写此方法, 在复用之前准备cell
    open override func prepareForReuse() {
        super.prepareForReuse()
        print("prepareForReuse")
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
    }

    /// 添加控件到内容视图中
    @discardableResult
    open func renderCell<T: UIView>(_ view: T, _ action: ((T) -> Void)? = nil) -> T {
        contentView.render(view, action)
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    open override func sizeToFit() {
        super.sizeToFit()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
    }

    //触发[sizeThatFits]
    open override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        super.systemLayoutSizeFitting(targetSize)
    }

    /// 计算cell的size, 此方法会触发[systemLayoutSizeFitting]
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        if let item = _item {
            var width = layoutAttributes.frame.width
            var height: CGFloat = layoutAttributes.frame.height

            let recyclerView = (findAttachedCollectionView() as? DslCollectionView)

            //宽度自适应计算
            if item.itemWidth == UITableView.automaticDimension {
                width = recyclerView?.maxContextWidth ?? UIScreen.width
                //宽度自适应
                width = min(width, attributes.frame.width)

                item._itemWidthCache = width
            } else if item.itemWidth > 0 {
                width = item.itemWidth
            }

            //高度自适应计算
            if item.itemHeight == UITableView.automaticDimension {
                // 自适应高度
                let targetSize = CGSize(width: width, height: 0)
                let size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
                height = size.height

                item._itemHeightCache = height
            } else if item.itemHeight > 0 {
                height = item.itemHeight
            }

            let size = CGSize(width: width, height: height)
            attributes.frame.size = size
        }

        return attributes
    }
}