//
// Created by wayto on 2021/8/2.
//

import Foundation
import UIKit

class DslTableCell: UITableViewCell {

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

    /// [自动赋值]
    weak var _item: DslItem? = nil

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        //debugPrint("setEditing:\(editing):\(animated)")
        (_item as? DslTableItem)?._itemEditing = editing
        (_item as? DslTableItem)?.onEditing?(editing, animated)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        debugPrint("setHighlighted:\(highlighted):\(animated)")
        (_item as? DslTableItem)?._itemHighlighted = highlighted
        (_item as? DslTableItem)?.onHighlighted?(highlighted, animated)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        debugPrint("setSelected:\(selected):\(animated)")
        (_item as? DslTableItem)?._itemSelected = selected
        (_item as? DslTableItem)?.onSelected?(selected, animated)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}