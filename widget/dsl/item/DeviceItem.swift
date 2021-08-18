//
// Created by angcyo on 21/08/17.
//

import Foundation
import UIKit
import TangramKit

class DeviceItem: DslTableItem {
    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        guard let cell = cell as? DeviceCell else {
            return
        }

        //"开阳安防平台/Wayto.GBSecurity.iOS/com.angcyo.app
        //1.0/1 w:375.0 h:812.0 s:3.0"
        cell.text.text = buildString {
            $0.append(Bundle.displayName())
            $0.append("/")
            $0.append(Bundle.appName())
            $0.append("\n")

            $0.append(Bundle.bundleId())
            $0.append("/")
            $0.append("\(Bundle.versionName())/\(Bundle.versionCode()) ")
            $0.append("w:\(UIScreen.width) h:\(UIScreen.height) s:\(UIScreen.scale_)")
            $0.append("\n")

            $0.append("statusBar:")
            $0.append(UIApplication.statusBarFrame)
            $0.append("\n")

            //$0.append("windowSafeArea:")
            $0.append(UIApplication.sceneWindow?.safeAreaInsets)
        }
    }
}

class DeviceCell: DslTableCell {

    let root = linearLayout()
    let text = labelView()

    override func initCell() {
        super.initCell()

        root.cacheRect()
        root.mWwH()
        root.setPadding(Res.size.leftMargin)
        //root.tg_gravity = .center

        root.render(text) {
            $0.textAlignment = .center
            $0.mWwH()
        }
        renderCell(root)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        root.sizeThatFits(CGSize(width: targetSize.width - safeAreaInsets.left - safeAreaInsets.right, height: targetSize.height))
    }
}