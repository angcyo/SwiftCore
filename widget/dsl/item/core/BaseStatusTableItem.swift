//
// Created by angcyo on 21/09/04.
//

import Foundation
import UIKit
import NVActivityIndicatorView

///  状态切换控制item, 比如 情感图切换, 加载更多

open class BaseStatusTableItem: DslTableItem, IStatusItem {

    /// 当前状态
    var itemStatus: ItemStatus = .ITEM_STATUS_NONE {
        willSet {
            if itemStatusEnable && itemStatus != newValue {
                _dslRecyclerView?.needsReload = true
            }
        }
    }

    /// 是否激活组件
    var itemStatusEnable: Bool = false {
        willSet {
            if itemStatusEnable != newValue {
                _dslRecyclerView?.needsReload = true
            }
        }
    }

    override func initItem() {
        super.initItem()
        itemSectionName = "status"
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellConfigOf(StatusCellConfig.self) {
            $0.updateStatus(itemStatus)
        }
    }

    override func bindCellWillDisplay(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCellWillDisplay(cell, indexPath)
        cell.cellConfigOf(StatusCellConfig.self) {
            $0.indicator.startAnimating()
        }
    }

    override func bindCellDidEndDisplaying(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCellDidEndDisplaying(cell, indexPath)
        cell.cellConfigOf(StatusCellConfig.self) {
            $0.indicator.stopAnimating()
        }
    }
}

class BaseStatusTableCell: DslTableCell {

    let cellConfig = StatusCellConfig()

    override func getCellConfig() -> IDslCellConfig? {
        cellConfig
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        L.d("\(frame)")
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        L.d("\(frame)")
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        if let view = findAttachedTableView() {
            return cgSize(targetSize.width, view.height - view.rectForHeader(inSection: 0).height - view.rectForHeader(inSection: 0).height)
        } else {
            return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        }
    }
}

//MARK: cell 界面声明, 用于兼容UITableView和UICollectionView

class StatusCellConfig: IDslCellConfig {

    /// 进度指示器
    let indicator = NVActivityIndicatorView(frame: .zero,
            type: .lineSpinFadeLoader,
            color: Res.color.colorAccent,
            padding: 0)

    /// 指示器的大小
    var indicatorSize: CGFloat = 30

    func getRootView(_ cell: UIView) -> UIView {
        cell.cellContentView
    }

    func initCellConfig(_ cell: UIView) {
        cell.backgroundColor = .clear

        cell.cellContentView.render(indicator)

        with(indicator) {
            $0.makeCenter()
            $0.makeWidthHeight(size: indicatorSize)
        }
    }

    /// 根据状态更新视图
    func updateStatus(_ status: ItemStatus) {
        //do
    }
}