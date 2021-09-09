//
// Created by angcyo on 21/09/09.
//

import Foundation

class BounceInterpolator: Interpolator {

    private static func bounce(_ t: CGFloat) -> CGFloat {
        t * t * 8.0
    }

    func getInterpolation(input: CGFloat) -> CGFloat {
        // _b(t) = t * t * 8
        // bs(t) = _b(t) for t < 0.3535
        // bs(t) = _b(t - 0.54719) + 0.7 for t < 0.7408
        // bs(t) = _b(t - 0.8526) + 0.9 for t < 0.9644
        // bs(t) = _b(t - 1.0435) + 0.95 for t <= 1.0
        // b(t) = bs(t * 1.1226)
        let input = input * 1.1226
        if (input < 0.3535) {
            return BounceInterpolator.bounce(input)
        } else if (input < 0.7408) {
            return BounceInterpolator.bounce(input - 0.54719) + 0.7
        } else if (input < 0.9644) {
            return BounceInterpolator.bounce(input - 0.8526) + 0.9
        } else {
            return BounceInterpolator.bounce(input - 1.0435) + 0.95
        }
    }
}