//
// Created by angcyo on 21/08/09.
//

import Foundation
import UIKit
import TangramKit

///
open class DslTableItem: DslItem {

    //MARK: [DslTableView] 代理配置
    var itemIndentationLevel: Int = 0
    var itemCanEdit: Bool = false
    var itemCanMove: Bool = false
    var itemCanHighlight: Bool = false
    var itemCanSelect: Bool = false
    var itemCanDeselect: Bool = false

    /// 激活item的选择
    func enableSelect(_ enable: Bool = true) {
        itemCanHighlight = enable
        itemCanSelect = enable
        itemCanDeselect = enable
    }

    //MARK: [DslTableView] 代理配置-Item

    var itemHeight: CGFloat = UITableView.automaticDimension
    var itemEstimatedHeight: CGFloat = Res.size.itemMinHeight

    //MARK: [DslTableView] 代理配置-Header
    var itemHeaderView: UIView? = nil
    var itemHeaderTitle: String? = nil
    var itemHeaderHeight: CGFloat? = nil //UITableView.automaticDimension
    var itemHeaderEstimatedHeight: CGFloat? = nil // = Res.size.leftMargin.toCGFloat() //UITableView.automaticDimension

    //MARK: [DslTableView] 代理配置-Footer
    var itemFooterView: UIView? = nil
    var itemFooterTitle: String? = nil
    var itemFooterHeight: CGFloat? = nil //UITableView.automaticDimension
    var itemFooterEstimatedHeight: CGFloat? = nil //0.0000001 //UITableView.automaticDimension

    //MARK: 界面回调 [DslTableCell]

    /// [自动赋值]
    var _itemEditing: Bool = false
    /// [自动赋值]
    var _itemHighlighted: Bool = false
    /// [自动赋值]
    var _itemSelected: Bool = false

    var onEditing: ((_ editing: Bool, _ animated: Bool) -> Void)? = nil
    var onHighlighted: ((_ highlighted: Bool, _ animated: Bool) -> Void)? = nil
    var onSelected: ((_ selected: Bool, _ animated: Bool) -> Void)? = nil

    public required init() {
        super.init()
    }

    override func initItem() {
        super.initItem()
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)
        _bindTableCell(cell, indexPath)
    }

    func _bindTableCell(_ cell: DslCell, _ indexPath: IndexPath) {
        //bind
        guard let cell = cell as? DslTableCell else {
            return
        }
        cell._item = self
    }
}

class DslTableCell: UITableViewCell, IDslCell {

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //cellIdentifier = reuseIdentifier ?? NSStringFromClass(Self.self)
        L.i("创建cell:\(self):\(style.rawValue):\(reuseIdentifier)")
        initCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        L.i("创建cell:\(self):\(coder)")
        initCell()
    }

    deinit {
        L.w("\(threadName())->销毁:\(self)")
    }

    ///  自定义的cell需要放在这里
    override var contentView: UIView {
        super.contentView
    }

    // 初始化对象, 设置控件初始化位置等
    func initCell() {

        // 右边图标样式
        accessoryType = .none
        //右箭头
        //accessoryType = .disclosureIndicator

        // 选中样式
        selectionStyle = .default

        //IDslCell
        if let cellConfig = getCellConfig() {
            cellConfig.initCellConfig(self)
            renderToCell(self, cellConfig.getRootView(self))
        }
    }

    /// 请重写此方法
    func getCellConfig() -> IDslCellConfig? {
        nil
    }

    /// 添加控件到内容视图中
    @discardableResult
    func renderCell<T: UIView>(_ view: T, _ action: ((T) -> Void)? = nil) -> T {
        contentView.render(view, action)
    }

    // 重写此方法, 在复用之前准备cell
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepareForReuse")
    }

    /*override var contentView: UIView {
        //print("contentView:\(self)")
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }*/

    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
    }

    /// [自动赋值]
    weak var _item: DslItem? = nil

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        //print("setEditing:\(editing):\(animated)")

        if let item = _item as? DslTableItem {
            item._itemEditing = editing
            item.onEditing?(editing, animated)
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        print("setHighlighted:\(highlighted):\(animated)")

        if let item = _item as? DslTableItem {
            item._itemHighlighted = highlighted
            item.onHighlighted?(highlighted, animated)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("setSelected:\(selected):\(animated)")

        if let item = _item as? DslTableItem {
            item._itemSelected = selected
            item.onSelected?(selected, animated)
        }
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

    /// UILayoutPriority.defaultLow.rawValue 250
    /// UILayoutPriority.sceneSizeStayPut.rawValue 500
    /// UILayoutPriority.defaultHigh.rawValue 750
    /// horizontalFittingPriority 默认是 UILayoutPriority.required.rawValue 1000
    /// verticalFittingPriority 默认时 UILayoutPriority.fittingSizeLevel.rawValue 50
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        //IDslCell
        if let cellConfig = getCellConfig() {
            let rootView = cellConfig.getRootView(self)
            if rootView is TGBaseLayout {
                return rootView.sizeThatFits(CGSize(width: targetSize.width - safeAreaInsets.left - safeAreaInsets.right, height: targetSize.height))
            }
        }
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
}