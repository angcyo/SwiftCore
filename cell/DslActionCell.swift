//
// Created by angcyo on 21/08/02.
//

import Foundation
import UIKit

struct DslActionData {
    var image: UIImage? = nil
    var text: String? = nil
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

    override func onBindCell(_ tableView: DslTableView, _ indexPath: IndexPath, _ item: DslItem) {
        super.onBindCell(tableView, indexPath, item)
        if let data = item.itemData as? DslActionData {
            imageView?.image = data.image
            textLabel?.text = data.text
            detailTextLabel?.text = data.detailText
        }
    }
}