//
// Created by angcyo on 21/09/17.
//

import Foundation
import UIKit

/// 显示图片的item, 目前支持单图

protocol IImageItem: IDslItem {

    /// var imageItemConfig = ImageItemConfig()
    var imageItemConfig: ImageItemConfig { get set }

}

class ImageItemConfig {

    /// 实现的图片
    var itemImage: AnyImage? = nil

    /// 内容模式
    var itemContentMode: UIView.ContentMode = .scaleAspectFill
}

extension IImageItem {

    /// 初始化
    func initImageItem(_ image: UIImageView) {
        image.setImage(imageItemConfig.itemImage)
        image.contentMode = imageItemConfig.itemContentMode
    }
}