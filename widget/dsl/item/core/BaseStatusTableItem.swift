//
// Created by angcyo on 21/09/04.
//

import Foundation
import UIKit
import NVActivityIndicatorView

///  状态切换控制item, 比如 情感图切换, 加载更多

open class BaseStatusTableItem: DslTableItem, IStatusItem {

    /// 已经通知了刷新, 等到刷新结束
    var _isRefreshPending: Bool = false

    /// 当前状态
    var itemStatus: ItemStatus = .ITEM_STATUS_NONE {
        willSet {
            if itemStatus != newValue {
                itemUpdate = true

                if itemStatusEnable {
                    if newValue != .ITEM_STATUS_REFRESH {
                        _isRefreshPending = false
                    }
                    _dslRecyclerView?.needsReload = true
                }
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

    /// 刷新回调
    var onItemRefresh: ((DslCell) -> Void)? = nil

    override func initItem() {
        super.initItem()
        itemSectionName = "status"

        //点击事件
        onItemClick = {
            if self.itemStatus == .ITEM_STATUS_ERROR {
                self.itemStatus = .ITEM_STATUS_REFRESH
                self._dslRecyclerView?.needsReload = true

                //回调
                if let index = self.itemIndex, let cell = self._dslRecyclerView?.getCellForRow(at: index) {
                    self.onItemRefresh?(cell)
                }
            }
        }
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellConfigOf(StatusCellConfig.self) {
            $0.updateStatus(self, itemStatus)
        }
    }

    override func bindCellWillDisplay(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCellWillDisplay(cell, indexPath)
        cell.cellConfigOf(StatusCellConfig.self) {
            if itemStatus == .ITEM_STATUS_REFRESH {
                $0.indicator.startAnimating()
            }
        }
        if !_isRefreshPending && itemStatus == .ITEM_STATUS_REFRESH {
            _isRefreshPending = true
            onItemRefresh?(cell)
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

    /// 错误布局
    let error: UIView = labelView("~出错吶, 点击重试~")

    /// 无更多布局
    let noMore: UIView = labelView("~没吶~")

    func getRootView(_ cell: UIView) -> UIView {
        cell.cellContentView
    }

    func initCellConfig(_ cell: UIView) {
        cell.backgroundColor = .clear

        cell.cellContentView.render(indicator)
        cell.cellContentView.render(error)
        cell.cellContentView.render(noMore)

        with(indicator) {
            $0.makeCenter()
            $0.makeWidthHeight(size: indicatorSize)
        }

        with(error) {
            $0.makeCenter()
        }

        with(noMore) {
            $0.makeCenter()
        }
    }

    /// 根据状态更新视图
    func updateStatus(_ item: BaseStatusTableItem, _ status: ItemStatus) {
        //do
        indicator.setHidden(status != .ITEM_STATUS_REFRESH)
        if status != .ITEM_STATUS_REFRESH {
            indicator.stopAnimating()
        }

        error.setHidden(status != .ITEM_STATUS_ERROR)
        if status == .ITEM_STATUS_ERROR {
            if let tip = item.itemData as? String, let error = error as? UILabel {
                error.setText(tip)
            }
        }

        noMore.setHidden(status != .ITEM_STATUS_NO_MORE)
        if status == .ITEM_STATUS_NO_MORE {
            if let tip = item.itemData as? String, let noMore = noMore as? UILabel {
                noMore.setText(tip)
            }
        }
    }
}