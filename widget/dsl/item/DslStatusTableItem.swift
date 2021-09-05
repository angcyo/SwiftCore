//
// Created by angcyo on 21/09/04.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class DslStatusTableItem: DslItem {

    override func initItem() {
        super.initItem()
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellOf(DslStatusTableCell.self) {
            $0.indicator.startAnimating()
        }
    }
}

class DslStatusTableCell: DslTableCell {

    /// 进度指示器
    let indicator = NVActivityIndicatorView(frame: .zero,
            type: .lineSpinFadeLoader,
            color: Res.color.colorAccent,
            padding: 0)

    override func initCell() {
        //super.initCell()

        backgroundColor = .clear

        //contentView.render(view)
        contentView.render(indicator)

        with(indicator) {
            $0.makeCenter()
            $0.makeWidthHeight(size: 30)
        }
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