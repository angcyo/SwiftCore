//
// Created by angcyo on 21/08/01.
//

import Foundation
import UIKit

protocol Number {
}

extension Number {
    func toString() -> String {
        "\(self)"
    }

    /// 取负值
    func reverse() -> Number {
        if let amount = self as? Float {
            return -(amount as! Float)
        } else if let amount = self as? Double {
            return -(amount as! Double)
        } else if let amount = self as? CGFloat {
            return -(amount as! CGFloat)
        } else if let amount = self as? Int {
            return -(amount as! Int)
        } else {
            return self
        }
    }
}

extension Int: Number {
    func have(_ other: Int) -> Bool {
        if self == other {
            return true
        }
        if self == 0 || other == 0 {
            return false
        }
        return self & other == other
    }
}

extension UInt: Number {
}

extension Float: Number {
    func toCGFloat() -> CGFloat {
        CGFloat(self)
    }
}

extension Double: Number {
    func toCGFloat() -> CGFloat {
        CGFloat(self)
    }
}

extension CGFloat: Number {

    func toInt() -> Int {
        Int(self)
    }

    func toFloat() -> Float {
        Float(self)
    }
}

public extension Int32 {

    /// Max double value.
    static var max: Int32 {
        INT32_MAX
    }

    /// Min double value.
    static var min: Int32 {
        -INT32_MAX
    }
}

public extension Float {

    /// Max double value. 3.4028235e+38
    static var max: Float {
        return greatestFiniteMagnitude
    }

    /// Min double value. -3.4028235e+38
    static var min: Float {
        return -greatestFiniteMagnitude
    }
}

public extension CGFloat {

    /// Max CGFloat value. CGFloat.greatestFiniteMagnitude 1.7976931348623157E+308
    static var max: CGFloat {
        greatestFiniteMagnitude
    }

    /// Min CGFloat value. -1.7976931348623157E+308
    static var min: CGFloat {
        -greatestFiniteMagnitude
    }

    //CGFloat.leastNormalMagnitude 2.2250738585072014E-308
    //CGFloat.leastNonzeroMagnitude 4.9406564584124654E-324
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