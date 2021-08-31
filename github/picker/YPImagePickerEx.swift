//
// Created by angcyo on 21/08/20.
//

import Foundation
import YPImagePicker
import AVFoundation


///https://github.com/Yummypets/YPImagePicker

extension YPImagePicker {

}

extension YPMediaItem {
    func log() {
        switch self {
        case .photo(let photo):
            photo.log()
        case .video(let video):
            video.log()
        }
    }
}

extension YPMediaPhoto {
    func log() {
        var log = "\n"
        log += "来自摄像头:\(fromCamera)\n"
        log += "原始的图片:\(originalImage)\n"
        log += "修改的图片:\(modifiedImage)\n"
        log += "url:\(url)\n"
        log += "asset:\(asset)\n"
        log += "exifMeta:\(exifMeta)\n"
        L.i(log)
    }
}

extension YPMediaVideo {
    func log() {
        var log = "\n"
        log += "来自摄像头:\(fromCamera)\n"
        log += "缩略图:\(thumbnail)\n"

        //file:///private/var/mobile/Containers/Data/Application/15702A22-9838-439C-9FC2-8C32C2260851/tmp/5E4EE18E-F94E-45FD-BE70-437E002A5997.mov
        log += "url:\(url)\n"
        log += "asset:\(asset)\n"
        L.i(log)
    }
}

extension UIImage {
    /// 保存图片到相册
    func trySaveImage(inAlbumNamed: String) {
        YPPhotoSaver_.trySaveImage(self, inAlbumNamed: inAlbumNamed)
    }
}

func _pickerConfiguration() -> YPImagePickerConfiguration {
    var config = YPImagePickerConfiguration()

    //general
    config.colors.tintColor = Res.color.colorAccent
    config.albumName = Bundle.displayName()
    config.screens = [.library, .photo, .video] //功能组件
    config.startOnScreen = .library //默认显示界面 图库
    config.shouldSaveNewPicturesToAlbum = false //不保存新照片,防止污染相册
    config.onlySquareImagesFromCamera = false //强制输出为正方形
    config.usesFrontCamera = false //默认前置摄像头
    config.targetImageSize = .original //目标图片尺寸

    config.showsPhotoFilters = false //开启图片滤镜
    config.showsVideoTrimmer = false //开启视频剪辑
    config.showsCrop = .none//.rectangle(ratio: 1.0)

    //library
    config.library.mediaType = .photoAndVideo
    config.library.defaultMultipleSelection = false //多选
    config.library.onlySquare = false //强制方形
    config.library.isSquareByDefault = false //默认剪切框设置为方形
    config.library.maxNumberOfItems = 1
    config.library.minNumberOfItems = 1
    config.library.preselectedItems = nil //预选中items
    config.library.itemOverlayType = .none

    //video
    config.video.compression = AVAssetExportPresetHighestQuality
    config.video.fileType = .mov
    config.video.recordingTimeLimit = 60.0
    config.video.libraryTimeLimit = 60.0
    config.video.minimumTimeLimit = 3.0
    config.video.trimmerMaxDuration = 60.0
    config.video.trimmerMinDuration = 3.0

    return config
}

/// 自定义选择, 选择图片和视频
func picker(_ configDsl: ((YPImagePickerConfiguration) -> Void)? = nil, _ action: @escaping (_ items: [YPMediaItem], _ cancelled: Bool) -> Void) {
    let config = _pickerConfiguration()
    configDsl?(config)
    let picker = YPImagePicker(configuration: config)
    picker.didFinishPicking { [unowned picker] items, cancelled in
        //print(items)
        for item in items {
            item.log()
        }
        action(items, cancelled)
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
            photo.log()
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
            video.log()
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
