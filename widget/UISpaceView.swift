//
// Created by wayto on 2021/7/29.
//

import Foundation
import UIKit

/// 空隙控件
class UISpaceView: UIView {

    convenience init(width: Int) {
        self.init(width, 1)
    }

    convenience init(height: Int) {
        self.init(1, height)
    }

    init(_ width: Int, _ height: Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("....draw")
    }
}