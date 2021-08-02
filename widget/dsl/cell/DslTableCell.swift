//
// Created by wayto on 2021/8/2.
//

import Foundation
import UIKit

class DslTableCell: UITableViewCell, DslCell {

    var cellIsRegister: Bool = false

    var cellIdentifier: String = "DslTableCell"

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellIdentifier = reuseIdentifier ?? cellIdentifier
        debugPrint("初始化cell:\(self):\(style.rawValue):\(cellIdentifier)")

        initCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func initCell() {
        //no op
    }

    func onBindCell(_ tableView: DslTableView, _ indexPath: IndexPath, _ item: DslItem, _ data: Any?) {
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
        debugPrint("setSelected")
    }
}