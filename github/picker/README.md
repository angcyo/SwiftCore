# 2021-08-20

需要引入库:

```groovy
# https://github.com/Yummypets/YPImagePicker
pod 'YPImagePicker' # 4.5.0
```

`YPImagePicker` 依赖↓

```
Installing PryntTrimmerView (4.0.2)
Installing SteviaLayout (4.7.3)
Installing YPImagePicker (4.5.0)
```

注意:

> [access] This app has crashed because it attempted to access privacy-sensitive data without a usage description.  The app's Info.plist must contain an NSCameraUsageDescription key with a string value explaining to the user how the app uses this data.

> [access] This app has crashed because it attempted to access privacy-sensitive data without a usage description.  The app's Info.plist must contain an NSPhotoLibraryUsageDescription key with a string value explaining to the user how the app uses this data.

> [access] This app has crashed because it attempted to access privacy-sensitive data without a usage description.  The app's Info.plist must contain an NSMicrophoneUsageDescription key with a string value explaining to the user how the app uses this data.

需要在`plist`文件中加入`摄像头`,`图库`,`麦克风`使用描述:

```
<key>NSCameraUsageDescription</key>
<string>使用相机用于拍照</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>使用图库用于选择照片</string>
<key>NSMicrophoneUsageDescription</key>
<string>录制视频需要使用麦克风</string>
```