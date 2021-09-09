//
// Created by angcyo on 21/09/09.
//

import Foundation

class AccelerateInterpolator: Interpolator {

    private let mFactor: CGFloat
    private let mDoubleFactor: CGFloat

    init(factor: CGFloat = 1, doubleFactor: CGFloat = 2) {
        mFactor = factor
        mDoubleFactor = doubleFactor
    }

    /// input [0~1]
    func getInterpolation(input: CGFloat) -> CGFloat {
        if (mFactor == 1.0) {
            return input * input
        } else {
            return pow(input, mDoubleFactor)
        }
    }
}