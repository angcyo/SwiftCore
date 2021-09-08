//
//  ImageViewEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/28.
//

import Foundation
import UIKit
import AlamofireImage


///https://github.com/Alamofire/AlamofireImage

/// image 支持[UIImage] 支持本地图片, 支持在线图片
typealias AnyImage = Any

extension UIImageView {

    /// 显示网络图片
    func setImageUrl(_ url: String?) {
        if nilOrEmpty(url) {
            image = nil
        } else {
            L.d("加载图片:\(url)")
            af.setImage(withURL: URL(string: url!)!,
                    cacheKey: url,
                    placeholderImage: image)
        }
    }

    /// 显示头像
    func setAvatarUrl(_ url: AnyImage?, name: String? = nil) {
        if url == nil {
            if nilOrEmpty(name) {
                image = nil
            } else {
                if bounds.isEmpty {
                    doMain {
                        self.setAvatarUrl(url, name: name)
                    }
                } else {
                    let nameImage = name?.toImage(rect: bounds) ?? image
                    image = nameImage
                }
            }
        } else {
            if bounds.isEmpty {
                doMain {
                    self.setAvatarUrl(url, name: name)
                }
            } else {
                if let url = url as? String {
                    L.d("加载图片:\(url)")
                    let nameImage = name?.toImage(rect: bounds) ?? image
                    af.setImage(withURL: URL(string: url)!,
                            cacheKey: url,
                            placeholderImage: nameImage,
                            progress: { (progress: Progress) in
                                L.d("加载进度:\(progress.fractionCompleted * 100)% \(progress):\(url)")
                            },
                            completion: { (data: AFIDataResponse<UIImage>) in
                                L.d("加载进度完成:\(url)")
                                self.setNeedsLayout()
                            })
                } else {
                    setImage(url, name: name)
                }
            }
        }
    }

    /// image 支持[UIImage] 支持本地图片, 支持在线图片
    func setImage(_ image: AnyImage?, name: String? = nil) {
        if let img = image {
            if let imgStr = img as? String {
                if imgStr.starts(with: "http") {
                    setAvatarUrl(imgStr, name: name)
                } else {
                    self.image = UIImage(named: imgStr)
                }
            } else if let imgObj = img as? UIImage {
                self.image = imgObj
            } else {
                L.w("不支持的图片类型:\(type(of: img))")
            }
        } else {
            self.image = nil
        }
    }
}

/// image 支持[UIImage] 支持本地图片, 支持在线图片
func img(_ image: AnyImage? = nil, tintColor: UIColor? = nil) -> UIImageView {
    let view = UIImageView()
    view.setImage(image)

    if let tintColor = tintColor {
        view.image = view.image?.withTintColor(tintColor)
    }
    view.tintColor = tintColor //这个属性似乎无效果

    //圆角
    //view.layer.contentsRect
    //view.layer.masksToBounds

    //当使用scaleAspectFill, 而不使用clipsToBounds时, 图片会超出控件frame显示
    view.clipsToBounds = true

    // 内容模式 https://www.jianshu.com/p/e1f8e4664faf
    view.contentMode = .scaleAspectFill

    return view
}

/// 等比缩放到控件size
func scaleImageView(_ image: AnyImage? = nil, tintColor: UIColor? = nil, size: CGFloat? = nil) -> UIImageView {
    let view = img(image, tintColor: tintColor)
    view.contentMode = .scaleAspectFit
    if let size = size {
        view.frame = rect(size, size)
    }
    return view
}

/// 等比填充到控件size
func fillImageView(_ image: AnyImage? = nil, tintColor: UIColor? = nil, size: CGFloat? = nil) -> UIImageView {
    let view = img(image, tintColor: tintColor)
    view.contentMode = .scaleAspectFill
    if let size = size {
        view.frame = rect(size, size)
    }
    return view
}

func image(_ image: AnyImage? = nil, tintColor: UIColor? = nil) -> UIImageView {
    img(image, tintColor: tintColor)
}

/// 图标
func icon(_ image: AnyImage? = nil, tintColor: UIColor? = Res.color.iconColor) -> UIImageView {
    let view = img(image, tintColor: tintColor)
    view.contentMode = .center
    return view
}

func iconView(_ image: AnyImage? = nil, tintColor: UIColor? = Res.color.iconColor) -> UIImageView {
    icon(image, tintColor: tintColor)
}

func imageView(size: CGFloat? = nil, radius: CGFloat = Res.size.roundLittle) -> UIImageView {
    let view = image()
    view.setRadius(radius)
    if let size = size {
        view.frame = rect(size, size)
    }
    return view
}

/// 创建一个圆形头像
/// - Parameters:
///   - size:  头像大小
///   - borderColor: 边框颜色
/// - Returns:
func avatarView(size: CGFloat = Res.size.avatar,
                borderColor: UIColor = UIColor.white) -> UIImageView {
    let view = image()
    view.frame = rect(size, size)
    view.clipsToBounds = true
    view.contentMode = .scaleAspectFill
    view.setRound(size / 2)
    view.setBorder(UIColor.white, radii: size / 2)
    return view
}
