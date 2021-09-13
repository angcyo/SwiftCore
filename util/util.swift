//
// Created by wayto on 2021/8/3.
//

import Foundation
import UIKit
import AdSupport

struct Util {
    /// 生成一个uuid AFFCC3DF-3D93-4E96-B749-187FF3F2B51A
    static func uuid() -> String {
        UUID().uuidString
    }
}

/// 转换成类名, 类似:"Wayto_GBSecurity_iOS.LoginController"
func toClassName(_ anyClass: AnyClass) -> String {
    NSStringFromClass(anyClass)
}

//// 类型转换成对象
func toViewController<T: NSObject>(_ type: AnyClass) -> T {
    (type as! NSObject.Type).init() as! T
}

/// 生成一个uuid
func uuid() -> String {
    UUID().uuidString
}

/// 广告 id IDFA
var adId = ASIdentifierManager.shared().advertisingIdentifier.uuidString

var idfv = UIDevice.current.identifierForVendor?.uuidString

//MARK: - 2021-08-09

extension Array {
    func get(_ index: Int) -> Element? {
        if (0..<count).contains(index) {
            return self[index]
        }
        return nil
    }

    /// 支持负数索引
    func get2(_ index: Int) -> Element? {
        if index < 0 {
            return get(index + count)
        }
        return get(index)
    }
}

extension Collection {
    /// Finds such index N that predicate is true for all elements up to
    /// but not including the index N, and is false for all elements
    /// starting with index N.
    /// Behavior is undefined if there is no such N.
    func binarySearch(predicate: (Iterator.Element) -> Bool) -> Index {
        var low = startIndex
        var high = endIndex
        while low != high {
            let mid = index(low, offsetBy: distance(from: low, to: high) / 2)
            if predicate(self[mid]) {
                low = index(after: mid)
            } else {
                high = mid
            }
        }
        return low
    }
}

extension CGFloat {
    func clamp(_ minValue: CGFloat, _ maxValue: CGFloat) -> CGFloat {
        let min = Swift.min(minValue, maxValue)
        let max = Swift.max(minValue, maxValue)
        return self < min ? min : (self > max ? max : self)
    }
}

extension CGPoint {
    func translate(_ dx: CGFloat, dy: CGFloat) -> CGPoint {
        CGPoint(x: x + dx, y: y + dy)
    }

    func transform(_ trans: CGAffineTransform) -> CGPoint {
        applying(trans)
    }

    func distance(_ point: CGPoint) -> CGFloat {
        sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }

    var transposed: CGPoint {
        CGPoint(x: y, y: x)
    }
}

extension CGSize {
    func insets(by insets: UIEdgeInsets) -> CGSize {
        CGSize(width: width - insets.left - insets.right, height: height - insets.top - insets.bottom)
    }

    var transposed: CGSize {
        CGSize(width: height, height: width)
    }
}

func abs(_ left: CGPoint) -> CGPoint {
    CGPoint(x: abs(left.x), y: abs(left.y))
}

func min(_ left: CGPoint, _ right: CGPoint) -> CGPoint {
    CGPoint(x: min(left.x, right.x), y: min(left.y, right.y))
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func +=(left: inout CGPoint, right: CGPoint) {
    left.x += right.x
    left.y += right.y
}

func +(left: CGRect, right: CGPoint) -> CGRect {
    CGRect(origin: left.origin + right, size: left.size)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -(left: CGRect, right: CGPoint) -> CGRect {
    CGRect(origin: left.origin - right, size: left.size)
}

func /(left: CGPoint, right: CGFloat) -> CGPoint {
    CGPoint(x: left.x / right, y: left.y / right)
}

func *(left: CGPoint, right: CGFloat) -> CGPoint {
    CGPoint(x: left.x * right, y: left.y * right)
}

func *(left: CGFloat, right: CGPoint) -> CGPoint {
    right * left
}

func *(left: CGPoint, right: CGPoint) -> CGPoint {
    CGPoint(x: left.x * right.x, y: left.y * right.y)
}

prefix func -(point: CGPoint) -> CGPoint {
    CGPoint.zero - point
}

func /(left: CGSize, right: CGFloat) -> CGSize {
    CGSize(width: left.width / right, height: left.height / right)
}

func -(left: CGPoint, right: CGSize) -> CGPoint {
    CGPoint(x: left.x - right.width, y: left.y - right.height)
}

prefix func -(inset: UIEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(top: -inset.top, left: -inset.left, bottom: -inset.bottom, right: -inset.right)
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
    var bounds: CGRect {
        CGRect(origin: .zero, size: size)
    }

    init(center: CGPoint, size: CGSize) {
        self.init(origin: center - size / 2, size: size)
    }

    var transposed: CGRect {
        CGRect(origin: origin.transposed, size: size.transposed)
    }
    #if swift(>=4.2)
    #else
func inset(by insets: UIEdgeInsets) -> CGRect {
return UIEdgeInsetsInsetRect(self, insets)
}
    #endif
}

func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

/// 复制数据
func copyData(_ obj: Any?) {
    let pasteboard: UIPasteboard = UIPasteboard.general
    if let obj = obj {
        if let s = obj as? String {
            pasteboard.string = s
        } else if let url = obj as? URL {
            pasteboard.url = url
        } else if let image = obj as? UIImage {
            pasteboard.image = image
        } else if let color = obj as? UIColor {
            pasteboard.color = color
        } else {
            L.w("不支持的数据类型:\(classNameOf(obj))")
        }
    }
}

/// 获取ip地址
// Return IP address of WiFi interface (en0) as a String, or `nil`
func getWiFiAddress() -> String? {
    var address: String?

    // Get list of all interfaces on the local machine:
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else {
        return nil
    }
    guard let firstAddr = ifaddr else {
        return nil
    }

    // For each interface ...
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let interface = ifptr.pointee

        // Check for IPv4 or IPv6 interface:
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

            // Check interface name:
            let name = String(cString: interface.ifa_name)
            if name == "en0" {

                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                        &hostname, socklen_t(hostname.count),
                        nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
            }
        }
    }
    freeifaddrs(ifaddr)

    return address
}

enum Network: String {
    case wifi = "en0"
    case cellular = "pdp_ip0"
    case ipv4 = "ipv4"
    case ipv6 = "ipv6"
}

func getAddress(for network: Network = .wifi) -> String? {
    var address: String?

    // Get list of all interfaces on the local machine:
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else {
        return nil
    }
    guard let firstAddr = ifaddr else {
        return nil
    }

    // For each interface ...
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let interface = ifptr.pointee

        // Check for IPv4 or IPv6 interface:
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

            // Check interface name:
            let name = String(cString: interface.ifa_name)
            if name == network.rawValue {

                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                        &hostname, socklen_t(hostname.count),
                        nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
            }
        }
    }
    freeifaddrs(ifaddr)

    return address
}