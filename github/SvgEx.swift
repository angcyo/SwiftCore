//
// Created by angcyo on 21/08/06.
//

import Foundation
import SwiftSVG

///# SVG 支持 https://github.com/mchoe/SwiftSVG
///pod 'SwiftSVG', '~> 2.3.2'

/// [svgName] svg文件名, 不需要后缀
func svg(_ svgName: String) -> UIView {
    let view = UIView(SVGNamed: svgName)
    return view
}


func svg(_ svgUrl: URL) -> UIView {
    let view = UIView(SVGURL: svgUrl)
    return view
}
