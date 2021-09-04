//
// Created by angcyo on 21/08/17.
//

import Foundation
import UIKit
import TangramKit

class DslDeviceTableItem: DslTableItem {

    /// 设备信息
    var itemDeviceInfo: String? = nil

    override func initItem() {
        super.initItem()
        onItemClick = {
            //showFileBrowser()
            //showFileExplorer()
            if let info = self.itemDeviceInfo {
                copyData(info)
                toast("复制:\(info)")
            }
        }
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellOf(DslDeviceTableCell.self) {
            //"开阳安防平台/Wayto.GBSecurity.iOS/com.angcyo.app
            //1.0/1 w:375.0 h:812.0 s:3.0"

            if itemDeviceInfo == nil {
                itemDeviceInfo = buildString {
                    $0.append(Bundle.displayName())
                    $0.append("/")
                    $0.append(Bundle.appName())

                    $0.append("\n")
                    $0.append(Bundle.bundleId())
                    $0.append("/")
                    $0.append("\(Bundle.versionName())/\(Bundle.versionCode()) ")
                    $0.append("w:\(UIScreen.width) h:\(UIScreen.height) s:\(UIScreen.scale_)")

                    if let frame = UIApplication.statusBarFrame {
                        $0.append("\n")
                        $0.append("statusBar:")
                        $0.append(frame)
                    }

                    if let frame = UIApplication.findNavigationController()?.navigationBar.frame {
                        $0.append("\n")
                        $0.append("navigationBar:")
                        $0.append(frame)
                    }

                    if let frame = UIApplication.findNavigationController()?.toolbar.frame {
                        $0.append("\n")
                        $0.append("toolbar:")
                        $0.append(frame)
                    }

                    $0.append("\n")
                    let insets = UIApplication.sceneWindow?.safeAreaInsets ?? .zero
                    $0.append("windowSafeArea: l:\(insets.left) t:\(insets.top) r:\(insets.right) b:\(insets.bottom)")
                    //$0.append(UIApplication.sceneWindow?.safeAreaInsets)

                    $0.append("\n")
                    let insets2 = UIApplication.sceneWindow?.layoutMargins ?? .zero
                    $0.append("windowLayoutMargins: l:\(insets2.left) t:\(insets2.top) r:\(insets2.right) b:\(insets2.bottom)")

                    $0.append("\n")
                    let device = UIDevice.current
                    $0.append("\(device.name)/\(device.model)/\(device.localizedModel)/\(device.systemName)/\(device.systemVersion)")

                    $0.append("\n")
                    $0.append("\(device.batteryLevel)/\(device.batteryState.rawValue)/\(device.proximityState)/\(device.isMultitaskingSupported)/\(device.userInterfaceIdiom.rawValue)")

                    $0.append("\n")
                    $0.append(device.identifierForVendor ?? "--")
                }
            }

            $0.text.text = itemDeviceInfo

            if let tableView = _dslRecyclerView as? UITableView {
                let cellMaxWidth = beforeCellMaxWidth()
                let textHeight = $0.sizeOfTextHeight(cellMaxWidth)
                if isLastItem() {
                    let beforeHeight = beforeCellHeight()
                    let height = tableView.bounds.height - beforeHeight
                    itemHeight = max(height, textHeight)
                } else {
                    itemHeight = textHeight
                }
            }
        }
    }
}

class DslDeviceTableCell: DslTableCell {

    let root = frameLayout()
    let text = labelView(size: Res.text.min.size)

    override func initCell() {
        super.initCell()

        backgroundColor = .clear

        root.cacheRect()
        root.match_parent()
        root.setPadding(Res.size.leftMargin)
        //root.tg_gravity = .center

        //root.backgroundColor = UIColor.red
        //text.backgroundColor = UIColor.green

        root.render(text) {
            $0.textAlignment = .center
            $0.mWwH()
            $0.tg_bottom.equal(0) //底部对齐
        }
        renderCell(root)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        root.sizeThatFits(CGSize(width: targetSize.width - safeAreaInsets.left - safeAreaInsets.right, height: targetSize.height))
    }

    /// 获取文本控件的高度
    func sizeOfTextHeight(_ cellWidth: CGFloat) -> CGFloat {
        text.sizeOf(cgSize(cellWidth - Res.size.leftMargin * 2, .max)).height + Res.size.leftMargin * 2
    }
}