//
// Created by angcyo on 21/09/09.
//

import Foundation

class AnticipateOvershootInterpolator: Interpolator {

    private let mTension: CGFloat

    init(_ tension: CGFloat = 2.0 * 1.5) {
        mTension = tension
    }

    private static func a(_ t: CGFloat, _ s: CGFloat) -> CGFloat {
        t * t * ((s + 1) * t - s);
    }

    private static func o(_ t: CGFloat, _ s: CGFloat) -> CGFloat {
        t * t * ((s + 1) * t + s);
    }

    func getInterpolation(input: CGFloat) -> CGFloat {
        // a(t, s) = t * t * ((s + 1) * t - s)
        // o(t, s) = t * t * ((s + 1) * t + s)
        // f(t) = 0.5 * a(t * 2, tension * extraTension), when t < 0.5
        // f(t) = 0.5 * (o(t * 2 - 2, tension * extraTension) + 2), when t <= 1.0
        if (input < 0.5) {
            return 0.5 * AnticipateOvershootInterpolator.a(input * 2.0, mTension)
        } else {
            return 0.5 * (AnticipateOvershootInterpolator.o(input * 2.0 - 2.0, mTension) + 2.0)
        }
    }
}