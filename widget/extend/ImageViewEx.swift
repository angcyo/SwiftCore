//
//  ImageViewEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/28.
//

import Foundation
import UIKit
import AlamofireImage

extension UIImageView {

    /// 显示网络图片
    func setImageUrl(_ url: String?) {
        if nilOrEmpty(url) {
            image = nil
        } else {
            debugPrint("加载图片:\(url)")
            af.setImage(withURL: URL(string: url!)!,
                    cacheKey: url,
                    placeholderImage: image)
        }
    }

    /// 显示头像
    func setAvatarUrl(_ url: String?, name: String) {
        if nilOrEmpty(url) {
            image = nil
        } else {
            if bounds.isEmpty {
                doMain {
                    self.setAvatarUrl(url, name: name)
                }
            } else {
                let nameImage = name.toImage(rect: bounds)
                af.setImage(withURL: URL(string: url!)!,
                        cacheKey: url,
                        placeholderImage: nameImage)
            }
        }
    }
}

/// image 支持[UIImage] 支持本地图片, 支持在线图片
func img(_ image: Any? = nil, tintColor: UIColor? = nil) -> UIImageView {
    let view = UIImageView()
    if let img = image {
        if img is String {
            let imgStr = img as! String
            if imgStr.starts(with: "http") {
                debugPrint("加载图片:\(imgStr)")
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

    //当使用scaleAspectFill, 而不使用clipsToBounds时, 图片会超出控件frame显示
    view.clipsToBounds = true

    // 内容模式
    view.contentMode = .scaleAspectFill

    return view
}

func image(_ image: Any? = nil, tintColor: UIColor? = nil) -> UIImageView {
    img(image, tintColor: tintColor)
}

/// 图标
func icon(_ image: Any? = nil, tintColor: UIColor? = nil) -> UIImageView {
    let view = img(image, tintColor: tintColor)
    view.contentMode = .center
    return view
}

/// 创建一个圆形头像
/// - Parameters:
///   - size:  头像大小
///   - borderColor: 边框颜色
/// - Returns:
func avatarView(size: Float = Res.size.avatar,
                borderColor: UIColor = UIColor.white) -> UIImageView {
    let view = image()
    view.frame = rect(size, size)
    view.clipsToBounds = true
    view.contentMode = .scaleAspectFill
    view.setRound(size / 2)
    view.setBorder(UIColor.white, radii: size / 2)
    return view
}
