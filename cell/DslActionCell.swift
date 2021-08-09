//
// Created by angcyo on 21/08/02.
//

import Foundation
import UIKit

struct DslActionData {
    /// 左边的图片
    var image: UIImage? = nil
    /// 左边的文本
    var text: String? = nil
    /// 右边的文本
    var detailText: String? = nil
}

/// 系统标准样式的cell
class DslActionCell: DslTableCell {

    override init(style: UIKit.UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func initCell() {
        super.initCell()
        //右箭头
        accessoryType = .disclosureIndicator
    }

    override func onBindTableCell(_ tableView: DslTableView, _ indexPath: IndexPath, _ item: DslItem) {
        super.onBindTableCell(tableView, indexPath, item)
        if let data = item.itemData as? DslActionData {
            imageView?.image = data.image
            textLabel?.text = data.text
            detailTextLabel?.text = data.detailText
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension DslItem {
    static var actionCell: DslTableItem {
        let item = DslTableItem(DslActionCell.self)
        item.itemHeight = 50
        item.enableSelect()
        return item
    }
}