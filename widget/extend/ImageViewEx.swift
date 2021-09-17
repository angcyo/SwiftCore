//
//  ImageViewEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/28.
//

import Foundation
import UIKit
import AlamofireImage
import YPImagePicker

///https://github.com/Alamofire/AlamofireImage

/// image 支持[UIImage] 支持本地图片, 支持在线图片, 支持[YPMediaItem]
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
            } else if let mediaItem = img as? YPMediaItem {
                switch mediaItem {
                case .photo(let photo):
                    self.image = photo.image
                case .video(let video):
                    self.image = video.thumbnail
                }
            } else {
                L.w("不支持的图片类型:\(type(of: img))")
            }
        } else {
            self.image = nil
        }
    }
}

extension UIImage {

    /// 着色
    func tintColor(_ color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            self.draw(at: .zero)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: .sourceAtop)
        }
    }

    /// 压缩size
    func toSize(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        self.draw(in: cgRect(0, 0, size.width, size.height))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        defer {
            UIGraphicsEndImageContext()
        }
        return resultImage
    }

    /// 压缩图片到指定大小 b https://www.jianshu.com/p/99c3e6a6c033
    func compressQualityWithMaxLength(_ maxLength: CGFloat) -> Data {
        var compression: CGFloat = 1
        var data = toJpegData(compression)!
        /*while (data.count > maxLength && compression > 0) {
            compression -= 0.02;
            data = toJpegData(compression) // When compression less than a value, this code dose not work
        }*/

        if (data.count.toCGFloat() < maxLength) {
            return data
        }

        var max: CGFloat = 1
        var min: CGFloat = 0

        for i in 0..<6 {
            compression = (max + min) / 2
            data = toJpegData(compression)!
            if (data.count.toCGFloat() < maxLength * 0.9) {
                min = compression
            } else if (data.count.toCGFloat() > maxLength) {
                max = compression
            } else {
                break
            }
        }
        return data
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

/// 等比缩放到控件size, 不剪切
func scaleImageView(_ image: AnyImage? = nil, tintColor: UIColor? = nil, size: CGFloat? = nil) -> UIImageView {
    let view = img(image, tintColor: tintColor)
    view.contentMode = .scaleAspectFit
    if let size = size {
        view.frame = rect(size, size)
    }
    return view
}

/// 等比填充到控件size, 可能剪切
func fillImageView(_ image: AnyImage? = nil, tintColor: UIColor? = nil, size: CGFloat? = nil) -> UIImageView {
    let view = img(image, tintColor: tintColor)
    view.contentMode = .scaleAspectFill
    if let size = size {
        view.frame = rect(size, size)
    }
    return view
}

/// 变形撑满view
func fitImageView(_ image: AnyImage? = nil, tintColor: UIColor? = nil, size: CGFloat? = nil) -> UIImageView {
    let view = img(image, tintColor: tintColor)
    view.contentMode = .scaleAspectFit
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
