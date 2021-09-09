//
// Created by angcyo on 21/09/09.
//

import Foundation

class AccelerateDecelerateInterpolator: Interpolator {

    func getInterpolation(input: CGFloat) -> CGFloat {
        cos((input + 1) * .pi) / 2.0 + 0.5
    }
}