//
// Created by wayto on 2021/8/2.
//

import Foundation
import UIKit

class DslTableCell: UITableViewCell, DslCell {

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //cellIdentifier = reuseIdentifier ?? NSStringFromClass(Self.self)
        debugPrint("创建cell:\(self):\(style.rawValue):\(reuseIdentifier)")

        initCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        debugPrint("\(threadName())->销毁:\(self)")
    }

    ///  自定义的cell需要放在这里
    override var contentView: UIView {
        super.contentView
    }

    // 初始化对象
    func initCell() {

        // 右边图标样式
        accessoryType = .none
        //右箭头
        //accessoryType = .disclosureIndicator

        // 选中样式
        selectionStyle = .default
    }

    // 重写此方法, 在复用之前准备cell
    override func prepareForReuse() {
        super.prepareForReuse()
        debugPrint("prepareForReuse")
    }

    /// [自动赋值] @selector(createTableViewCell:cellForRowAt:item:)
    weak var _item: DslItem? = nil

    func onBindCell(_ tableView: DslTableView, _ indexPath: IndexPath, _ item: DslItem) {
        debugPrint("onBindCell:\(indexPath)")
        item.itemUpdate = false
        item.onBindCell?(self, indexPath)
    }

    /*override var contentView: UIView {
        //debugPrint("contentView:\(self)")
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }*/

    override func awakeFromNib() {
        super.awakeFromNib()
        debugPrint("awakeFromNib")
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        //debugPrint("setEditing:\(editing):\(animated)")
        _item?._itemEditing = editing
        _item?.onEditing?(editing, animated)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        debugPrint("setHighlighted:\(highlighted):\(animated)")
        _item?._itemHighlighted = highlighted
        _item?.onHighlighted?(highlighted, animated)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        debugPrint("setSelected:\(selected):\(animated)")
        _item?._itemSelected = selected
        _item?.onSelected?(selected, animated)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}