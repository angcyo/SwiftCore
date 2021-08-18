//
// Created by angcyo on 21/08/18.
//

import Foundation
import UIKit
import TangramKit

protocol IFormEditCell: IDslCell {
    var formEditCellConfig: FormEditCellConfig { get set }
}

class FormEditCellConfig: IDslCellConfig {

    let root = frameLayout()
    let wrap = horizontal()
    let label = labelView(size: Res.text.label.size, color: Res.text.subTitle.color)
    let text = textFieldView(borderStyle: .none)
    let line = lineView()

    func initCellConfig(_ cell: UIView) {

        root.mWwH()

        wrap.setPadding(Res.size.x)
        wrap.mWwH(minHeight: Res.size.itemMinHeight)
        wrap.setGravity(TGGravity.vert.center)

        wrap.render(label) {
            $0.wrap_content(minWidth: Res.size.itemMinLabelWidth)
        }

        wrap.render(text) {
            $0.mWwH(minHeight: Res.size.minHeight)
        }

        root.render(wrap)
        root.render(line) {
            $0.mWwH(height: Res.size.line)
            $0.setMarginHorizontal(Res.size.x)
            $0.frameGravityBottom()
        }
    }
}