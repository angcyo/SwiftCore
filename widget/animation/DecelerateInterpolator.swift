//
// Created by angcyo on 21/09/09.
//

import Foundation

class DecelerateInterpolator: Interpolator {

    private let mFactor: CGFloat

    init(_ factor: CGFloat = 1) {
        mFactor = factor
    }

    /// input [0~1]
    func getInterpolation(input: CGFloat) -> CGFloat {
        var result: CGFloat
        if (mFactor == 1.0) {
            result = (1.0 - (1.0 - input) * (1.0 - input))
        } else {
            result = (1.0 - pow((1.0 - input), 2 * mFactor))
        }
        return result
    }
}