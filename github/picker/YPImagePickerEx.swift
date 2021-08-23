//
// Created by angcyo on 21/08/20.
//

import Foundation
import YPImagePicker

///https://github.com/Yummypets/YPImagePicker

extension YPImagePicker {

}

extension UIImage {
    /// 保存图片到相册
    func trySaveImage(inAlbumNamed: String) {
        YPPhotoSaver_.trySaveImage(self, inAlbumNamed: inAlbumNamed)
    }
}

func _pickerConfiguration() -> YPImagePickerConfiguration {
    var config = YPImagePickerConfiguration()
    config.colors.tintColor = Res.color.colorAccent
    config.albumName = Bundle.displayName()

    config.screens = [.library, .photo, .video]
    config.library.mediaType = .photoAndVideo
    config.library.defaultMultipleSelection = false //多选
    config.library.maxNumberOfItems = 1
    config.library.minNumberOfItems = 1
    config.library.preselectedItems = nil //预选中
    config.startOnScreen = .library //默认显示界面 图库

    config.showsPhotoFilters = false //开启图片滤镜
    config.showsVideoTrimmer = false //开启视频剪辑
    config.showsCrop = .none//.rectangle(ratio: 1.0)
    return config
}

/// 选择图片和视频
func picker() {
    var config = _pickerConfiguration()
    let picker = YPImagePicker(configuration: config)
    picker.didFinishPicking { [unowned picker] items, cancelled in
        if let video = items.singleVideo {
            print(video.fromCamera)
            print(video.thumbnail)
            print(video.url)
        }
        debugPrint(items)
        picker.dismiss(animated: true, completion: nil)
    }
    show(picker, animated: true, completion: nil)
}

/// 选择图片
///
/// - Parameters:
///   - camera: 是否要拍照
///   - crop:  是否要裁剪
func pickerPhoto(camera: Bool = true, crop: Bool = true, _ action: @escaping (YPMediaPhoto) -> Void) {
    var config = _pickerConfiguration()

    config.screens = [.library]
    config.library.mediaType = .photo

    if crop {
        config.showsCrop = .rectangle(ratio: 1)
    }
    if camera {
        config.screens = [.library, .photo]
    }
    let picker = YPImagePicker(configuration: config)
    picker.didFinishPicking { [unowned picker] items, cancelled in
        if let photo = items.singlePhoto {
            print(photo.fromCamera) // Image source (camera or library) 是否是拍照
            print(photo.image) // Final image selected by the user 图片返回
            print(photo.originalImage) // original image selected by the user, unfiltered 原始图片
            print(photo.modifiedImage) // Transformed image, can be nil 修改过滤后的图片
            print(photo.exifMeta) // Print exif meta data of original image. 元数据
            print(photo.url) //
            action(photo)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    show(picker, animated: true, completion: nil)
}

/// 选择视频
func pickerVideo(camera: Bool = true, crop: Bool = false, _ action: @escaping (YPMediaVideo) -> Void) {
    var config = _pickerConfiguration()

    config.screens = [.library]
    config.library.mediaType = .video

    if crop {
        config.showsVideoTrimmer = true //开启视频剪辑
    }
    if camera {
        config.screens = [.library, .video]
    }

    let picker = YPImagePicker(configuration: config)
    picker.didFinishPicking { [unowned picker] items, _ in
        if let video = items.singleVideo {
            print(video.fromCamera)
            print(video.thumbnail) //封面
            print(video.url)
            //file:///private/var/mobile/Containers/Data/Application/15702A22-9838-439C-9FC2-8C32C2260851/tmp/5E4EE18E-F94E-45FD-BE70-437E002A5997.mov
            action(video)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    show(picker, animated: true, completion: nil)
}


/* exifMeta
Optional(["Depth": 8, "DPIHeight": 72, "DPIWidth": 72, "{Exif}": {
    ColorSpace = 1;
    ComponentsConfiguration =     (
        1,
        2,
        3,
        0
    );
    ExifVersion =     (
        2,
        2,
        1
    );
    FlashPixVersion =     (
        1,
        0
    );
    PixelXDimension = 888;
    PixelYDimension = 1920;
    SceneCaptureType = 0;
}, "{JFIF}": {
    DensityUnit = 0;
    JFIFVersion =     (
        1,
        0,
        1
    );
    XDensity = 72;
    YDensity = 72;
}, "PixelHeight": 1920, "PixelWidth": 888, "{TIFF}": {
    Orientation = 1;
    ResolutionUnit = 2;
    XResolution = 72;
    YResolution = 72;
}, "ProfileName": sRGB IEC61966-2.1, "Orientation": 1, "ColorModel": RGB])
 */
