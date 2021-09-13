//
// Created by angcyo on 21/09/09.
//

import Foundation
import UIKit
import SwiftMessages

///["Documents", ".com.apple.mobile_container_manager.metadata.plist", "Library", "SystemData", "tmp"]

extension FileManager {

    func listNames(atPath path: String) -> [String] {
        let fileNames = try? contentsOfDirectory(atPath: path)
        return fileNames ?? []
    }
}

/// 文件浏览对话框

class FileBrowserDialog: BaseDialog {

    /// "/var/mobile/Containers/Data/Application/D1D29368-F11B-47D0-98E3-584D8363617B"
    let initPath = NSHomeDirectory() //"/"
    let pathLabel = paddingLabel(color: Res.text.subTitle.color)
    let dslTableView = DslTableView()
    let line = hLine()

    override func initDialog() {
        super.initDialog()
        //关闭默认的拖拽隐藏
        hideOnDrag = false

        //backgroundColor = .green

        let defaultOffset = UIScreen.height / 3
        translationTo(y: defaultOffset) //默认降到屏幕1/3的位置
        //initGesture()

        render(pathLabel) {
            $0.backgroundColor = .white
            $0.singleLine(lineBreakMode: .byTruncatingMiddle)
            $0.leftInset = Res.size.x
            $0.rightInset = Res.size.x
            $0.makeTopIn(offsetTop: self.topSafeInsets, priority: .required)
            $0.makeHeight(Res.size.itemMinHeight)
            $0.setRoundTop()
        }
        render(line) {
            $0.makeGravityLeft()
            $0.makeGravityRight()
            $0.makeGravityBottom(self.pathLabel)
        }
        render(dslTableView) {
            $0.backgroundColor = .white
            $0.makeGravityLeft()
            $0.makeGravityRight()
            $0.makeGravityBottom()
            $0.makeTopToBottomOf(self.pathLabel)
        }

        //dslTableView.contentInsetAdjustmentBehavior = .never
        dslTableView.toStatusRefreshIfNeeded()

        //滚动监听
        dslTableView.onScrollViewDidScroll = {
            let ty = self.transform.ty
            self.translationTo(y: ty - $0.contentOffset.y, maxY: self.height)

            if $0.contentOffset.y < 0 {
                //手指向下滑动
                $0.contentOffset = .zero
            } else {
                //手指向上滑动
                if self.transform.ty > 0 {
                    $0.contentOffset = .zero
                }
            }
        }
        //滚动结束
        dslTableView.onScrollViewDidEndScroll = { _ in
            if self.dslTableView.lastVelocity.y < -3 || self.transformY >= self.height / 2 {
                //手指向下拖拽
                self.toClose()
            } else {
                self.toOpen()
            }
        }

        pathLabel.onClick { _ in
            self.loadPath(self.currentPath.deletingLastPathComponent)
        }
    }

    var _lastTranslationY: CGFloat = 0

    /// 拖拽手势
    func initGesture() {
        onPan(bag: gestureDisposeBag, [.changed, .ended, .cancelled]) {
            let velocity = $0.velocity(in: self)
            let translation = $0.translation(in: self)

            let dy = translation.y - self._lastTranslationY
            self._lastTranslationY = translation.y

            //L.d($0)
            L.i("velocity:\(velocity) translation:\(translation)")
            if $0.state == .changed {
                let ty = self.transform.ty
                self.translationTo(y: ty + dy, maxY: self.height)
            } else {
                self._lastTranslationY = 0

                if velocity.y > 0 || self.transformY >= self.height / 2 {
                    //手指向下拖拽
                    self.toClose()
                } else {
                    self.toOpen()
                }
            }
        }
    }

    /// 关闭面板
    func toClose() {
        let ty = transform.ty
        let max = height
        valueAnimation(from: ty, to: max) {
            self.translationTo(y: $0.animationValue, maxY: max)
            if $0.isAnimationFinish {
                self.hideDialog()
            }
        }
    }

    /// 打开面板
    func toOpen() {
        let ty = transform.ty
        let min: CGFloat = 0
        let max = height
        valueAnimation(from: ty, to: min) {
            self.translationTo(y: $0.animationValue, maxY: max)
        }
    }

    override func onDialogShowInner() {
        super.onDialogShowInner()
        loadPath(initPath)
    }

    override func createMessageView() -> BaseDialogView {
        //super.createMessageView()

        let messageView = BaseDialogView()
        messageView.respectSafeArea = false
        messageView.bounceAnimationOffset = 0
        messageView.backgroundHeight = UIScreen.height

        //click close self
        messageView.onClick { _ in
            self.toClose()
        }

        /*messageView.backgroundHeight = nil
        messageView.respectSafeArea = true //是否考虑安全区域

        let backgroundView = CornerRoundingView()
        backgroundView.cornerRadius = Res.size.roundMax
        backgroundView.roundedCorners = [.allCorners]
        backgroundView.layer.masksToBounds = true
        backgroundView.backgroundColor = Res.color.bg
        messageView.installBackgroundView(backgroundView,
                insets: insets(left: Res.size.xx, right: Res.size.xx))

        //messageView.backgroundColor = Res.color.warning //Res.color.bg
        //messageView.backgroundView.layoutMargins = insets(size: 40) //

        messageView.configureDropShadow()*/

        messageView.setContentView(self)

        with(self) {
            $0.makeGravityLeft()
            $0.makeGravityRight()
            $0.makeGravityTop()
            $0.makeGravityBottom()
            //$0.makeHeight(UIScreen.height)
        }

        return messageView
    }

    override func configMessage(swiftMessage: SwiftMessages) {
        super.configMessage(swiftMessage: swiftMessage)
        swiftMessage.defaultConfig.presentationContext = .window(windowLevel: .alert)
    }

    //MARK: file 操作

    /// 当前加载的路径
    var currentPath: String = ""
    let fileManager = FileManager.default

    /// 加载路径
    func loadPath(_ path: String) {
        L.i("加载路径:\(path)")
        let names = fileManager.listNames(atPath: path)
        pathLabel.setText(path)
        currentPath = path

        var list = [FileBrowserBean]()
        for name in names {
            let bean = FileBrowserBean()
            bean.fileName = name
            bean.fileType = name.pathExtension

            let atPath = currentPath + "/" + name
            bean.displayName = fileManager.displayName(atPath: atPath)

            var isDirectory: ObjCBool = false
            let exist = fileManager.fileExists(atPath: atPath, isDirectory: &isDirectory)
            bean.isExists = exist
            bean.isReadable = fileManager.isReadableFile(atPath: atPath)
            bean.isWritable = fileManager.isWritableFile(atPath: atPath)
            bean.isExecutable = fileManager.isExecutableFile(atPath: atPath)
            bean.isDeletable = fileManager.isDeletableFile(atPath: atPath)
            let attributes = try? fileManager.attributesOfItem(atPath: atPath)
            bean.ownerAccountName = attributes?[.ownerAccountName] as? String
            bean.modificationDate = attributes?[.modificationDate] as? Date
            bean.type = attributes?[.type] as? String

            //L.d("\(name) exist:\(exist) isDirectory:\(isDirectory) \(atPath.pathExtension) \(attributes?[.modificationDate])")
            //L.d(attributes)

            if isDirectory.boolValue {
                bean.fileSize = fileManager.listNames(atPath: atPath).count
            } else {
                bean.fileSize = attributes?[.size] as? Int ?? 0
            }
            bean.isFolder = isDirectory.boolValue

            list.add(bean)
        }

        list.sort { l, r in
            //自然升序, 值越大越在后面
            if l.isFolder != r.isFolder {
                if l.isFolder {
                    return true
                } else if r.isFolder {
                    return false
                }
            }
            return l.fileName ?? "" < r.fileName ?? ""
        }

        dslTableView.defaultItemProvide.loadDataEnd(FileBrowserTableItem.self, dataList: list) {
            let bean = $0.itemData as? FileBrowserBean
            $0.onItemSelected = { selected, _ in
                if selected, let bean = bean {

                    let path: String
                    if self.currentPath.endWith("/") {
                        path = self.currentPath + bean.fileName!
                    } else {
                        path = self.currentPath + "/" + bean.fileName!
                    }
                    L.d(path)

                    if bean.isFolder == true {
                        self.loadPath(path)
                    } else {
                        //showUrl(path)
                        let vc = DocumentViewController(url: path.toFileURL())
                        show(vc)
                    }
                }
            }
        }
    }
}

/// 显示文件浏览对话框
func showFileBrowserDialog() {
    let dialog = FileBrowserDialog()
    dialog.showDialog()
}