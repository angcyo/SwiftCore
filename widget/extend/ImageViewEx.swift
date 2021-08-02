//
//  ImageViewEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/28.
//

import Foundation
import UIKit
import AlamofireImage

/// image 支持[UIImage] 支持本地图片, 支持在线图片
func img(_ image: Any? = nil, tintColor: UIColor? = nil) -> UIImageView {
    let view = UIImageView()
    if let img = image {
        if img is String {
            let imgStr = img as! String
            if imgStr.starts(with: "http") {
                view.af.setImage(withURL: URL(string: imgStr)!,
                        cacheKey: imgStr,
                        placeholderImage: view.image)
            } else {
                view.image = UIImage(named: imgStr)
            }
        } else if img is UIImage {
            view.image = img as! UIImage
        }
    }

    if let tintColor = tintColor {
        view.image = view.image?.withTintColor(tintColor)
    }
    view.tintColor = tintColor //这个属性似乎无效果

    //圆角
    //view.layer.contentsRect
    //view.layer.masksToBounds

    // 内容模式
    view.contentMode = .scaleAspectFit

    return view
}
