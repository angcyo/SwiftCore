//
// Created by angcyo on 21/08/28.
//

import Foundation
import Lantern
import UIKit
import AlamofireImage

/// 花灯
/// https://github.com/fcbox/Lantern
/// https://github.com/fcbox/Lantern/blob/master/%E5%9F%BA%E7%A1%80%E7%94%A8%E6%B3%95.md

/// 图片加载
fileprivate func _reloadCellContext(image: AnyImage?, cell: LanternCell, index: Int, currentIndex: Int) {
    if let lanternCell = cell as? LanternImageCell {
        let indexPath = IndexPath(item: index, section: 0)
        let img = image

        //加载图片
        if let imgStr = img as? String {
            if imgStr.starts(with: "http") {
                lanternCell.imageView.af.setImage(withURL: URL(string: imgStr)!) { (data: AlamofireImage.AFIDataResponse<UIImage>) in
                    lanternCell.setNeedsLayout()
                }
            } else {
                lanternCell.imageView.image = UIImage(named: imgStr)
            }
        } else {
            lanternCell.imageView.setImage(img)
        }
    }
}

/// 使用花灯预览图片和视频
@discardableResult
func lantern(_ images: [AnyImage], index: Int = 0) -> Lantern {
    let lantern = Lantern()
    // 数字样式的页码指示器
    lantern.pageIndicator = LanternNumberPageIndicator()
    lantern.numberOfItems = {
        images.count
    }
    // 数据加载
    lantern.reloadCellAtIndex = { context in
        _reloadCellContext(image: images[context.index], cell: context.cell, index: context.index, currentIndex: context.currentIndex)
    }
    lantern.pageIndex = index
    lantern.show()
    return lantern
}

func lantern(_ image: AnyImage?) {
    guard let img = image else {
        return
    }
    lantern([img], index: 0)
}

/// 放大和缩小的动画

@discardableResult
func lantern(_ recyclerView: DslRecycleView, images: [AnyImage]? = nil, indexPath: IndexPath) -> Lantern {
    let lantern = Lantern()
    let images = images ?? recyclerView.allItemImage()
    // 数字样式的页码指示器
    lantern.pageIndicator = LanternNumberPageIndicator()
    lantern.numberOfItems = {
        images.count
    }
    // 数据加载
    lantern.reloadCellAtIndex = { context in
        _reloadCellContext(image: images[context.index], cell: context.cell, index: context.index, currentIndex: context.currentIndex)
    }
    // 使用Zoom动画
    lantern.transitionAnimator = LanternZoomAnimator(previousView: { index -> UIView? in
        let path = IndexPath(item: index, section: indexPath.section)
        let result: UIView?
        if let tableView = recyclerView as? UITableView {
            result = tableView.cellForRow(at: path)
        } else if let collectionView = recyclerView as? UICollectionView {
            result = collectionView.cellForItem(at: path)
        } else {
            result = nil
        }
        return result
    })
    lantern.pageIndex = indexPath.row
    lantern.show()
    return lantern
}