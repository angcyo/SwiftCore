//
// Created by angcyo on 21/09/09.
//

import Foundation

/// 差值器, 移植自android
protocol Interpolator {

    /// input [0~1]
    func getInterpolation(input: CGFloat) -> CGFloat

}