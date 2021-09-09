//
// Created by angcyo on 21/09/09.
//

import Foundation

class CycleInterpolator: Interpolator {

    private let mCycles: CGFloat

    init(_ cycles: CGFloat = 1) {
        mCycles = cycles
    }

    /// input [0~1]
    func getInterpolation(input: CGFloat) -> CGFloat {
        sin(2 * mCycles * .pi * input)
    }
}