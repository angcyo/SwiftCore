//
// Created by angcyo on 21/08/06.
//

import Foundation
import SwiftSVG

/// [svgName] svg文件名, 不需要后缀
func svg(_ svgName: String) -> UIView {
    let view = UIView(SVGNamed: svgName)
    return view
}


func svg(_ svgUrl: URL) -> UIView {
    let view = UIView(SVGURL: svgUrl)
    return view
}
