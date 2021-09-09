//
// Created by angcyo on 21/09/09.
//

import Foundation

class AnticipateInterpolator: Interpolator {

    private let mTension: CGFloat

    init(_ tension: CGFloat = 2.0) {
        mTension = tension
    }

    func getInterpolation(input: CGFloat) -> CGFloat {
        input * input * ((mTension + 1) * input - mTension);
    }
}