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

class DslActionTableItem: DslTableItem {
    override func initItem() {
        itemCell = DslActionTableCell.self
        itemHeight = 50
        enableSelect()
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        guard let cell = cell as? DslActionTableCell else {
            return
        }

        if let data = itemData as? DslActionData {
            cell.imageView?.image = data.image
            cell.textLabel?.text = data.text
            cell.detailTextLabel?.text = data.detailText
        }
    }
}

/// 系统标准样式的cell
class DslActionTableCell: DslTableCell {

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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}