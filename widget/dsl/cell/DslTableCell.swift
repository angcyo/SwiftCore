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

    // 初始化对象
    func initCell() {
        accessoryType = .none
        //右箭头
        //accessoryType = .disclosureIndicator
    }

    // 重写此方法, 在复用之前准备cell
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func onBindCell(_ tableView: DslTableView, _ indexPath: IndexPath, _ item: DslItem) {
        debugPrint("onBindCell:\(indexPath)")
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        debugPrint("setSelected:\(selected):\(animated)")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}