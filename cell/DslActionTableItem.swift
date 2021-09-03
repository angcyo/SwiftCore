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
        super.initItem()
        itemHeight = 50
        enableSelect()
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellOf(DslActionTableCell.self) {
            if let data = itemData as? DslActionData {
                $0.imageView?.image = data.image
                $0.textLabel?.text = data.text
                $0.detailTextLabel?.text = data.detailText
            }
        }
    }

    override func bindItemGesture(_ view: UIView) {
        //no
    }

    /// 显示内容
    func setAction(image: UIImage? = nil, text: String? = nil, detailText: String? = nil) {
        itemData = DslActionData(image: image, text: text, detailText: detailText)
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