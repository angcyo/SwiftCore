//
// Created by angcyo on 21/09/09.
//

import Foundation

class OvershootInterpolator: Interpolator {

    private let mTension: CGFloat

    init(_ tension: CGFloat = 2.0) {
        mTension = tension
    }

    func getInterpolation(input: CGFloat) -> CGFloat {
        let input = input - 1.0
        return input * input * ((mTension + 1) * input + mTension) + 1.0
    }
}