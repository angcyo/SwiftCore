//
// Created by angcyo on 21/09/15.
//

import Foundation
import UIKit

///https://stackoverflow.com/questions/48178076/uirefreshcontrol-layout-wrong-in-uiscrollview-with-left-right-contentinset

class UIRefreshControlFix: UIRefreshControl {

    override var frame: CGRect {
        get {
            super.frame
        }
        set {
            var newFrame = newValue
            if let superScrollView = superview as? UIScrollView {
                newFrame.origin.x = superScrollView.frame.minX - superScrollView.contentInset.left
            }
            super.frame = newFrame
        }
    }

}