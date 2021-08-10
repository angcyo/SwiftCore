//
// Created by angcyo on 21/08/01.
//

import Foundation
import UIKit

protocol Number {
}

extension Int: Number {
}

extension UInt: Number {
}

extension Float: Number {
}

extension Double: Number {
}

extension CGFloat: Number {
}

public extension Int32 {

    /// Max double value.
    static var max: Int32 {
        return INT32_MAX
    }

    /// Min double value.
    static var min: Int32 {
        return -INT32_MAX
    }
}

public extension Float {

    /// Max double value. 3.4028235e+38
    static var max: Float {
        return Float(greatestFiniteMagnitude)
    }

    /// Min double value. -3.4028235e+38
    static var min: Float {
        return Float(-greatestFiniteMagnitude)
    }
}

public extension Double {

    /// Max double value. 1.7976931348623157e+308
    static var max: Double {
        return Double(greatestFiniteMagnitude)
    }

    /// Min double value. -1.7976931348623157e+308
    static var min: Double {
        return Double(-greatestFiniteMagnitude)
    }
}

/// 随机产生一个int类型的数, 3628967563
func randomInt() -> Int {
    Int(arc4random())
}

/// [from~to]
func nextInt(_ from: Int = 0, to: Int) -> Int {
    from + Int(arc4random_uniform(UInt32(to - from)))
}

/// 返回0～1内的Double类型数据 0.39646477376027534
func randomDouble() -> Double {
    drand48()
}