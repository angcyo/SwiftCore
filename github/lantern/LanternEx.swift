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

/// 使用花灯预览图片和视频
func lantern(_ images: [Any], index: Int = 0) {
    let lantern = Lantern()
    lantern.numberOfItems = {
        images.count
    }
    lantern.reloadCellAtIndex = { context in
        if let lanternCell = context.cell as? LanternImageCell {
            let indexPath = IndexPath(item: context.index, section: 0)
            let img = images[indexPath.item]

            //加载图片
            if let imgStr = img as? String {
                if imgStr.starts(with: "http") {
                    lanternCell.imageView.af.setImage(withURL: URL(string: imgStr)!) { (data: AlamofireImage.AFIDataResponse<UIImage>) in
                        lanternCell.setNeedsLayout()
                    }
                } else {
                    lanternCell.imageView.image = UIImage(named: imgStr)
                }
            } else if let imgObj = img as? UIImage {
                lanternCell.imageView.image = imgObj
            } else {
                L.w("不支持的图片类型:\(type(of: img))")
            }
        }
    }
    lantern.pageIndex = index
    lantern.show()
}
