//
// Created by angcyo on 21/08/18.
//

import Foundation
import UIKit

class PIRippleView: UIView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        logObjNewLine("touchesBegan:\(touches):\(event):\(isUserInteractionEnabled)")

        for touch in touches {
            let location = touch.location(in: self)
            //rippleBorder(location, color: UIColor.red)
            rippleFill(location, color: UIColor.white)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        logObjNewLine("touchesMoved:\(touches):\(event)")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        logObjNewLine("touchesEnded:\(touches):\(event)")
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        logObjNewLine("touchesCancelled:\(touches):\(event)")
    }

    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        super.touchesEstimatedPropertiesUpdated(touches)
        logObjNewLine("touchesEstimatedPropertiesUpdated:\(touches)")
    }
}