//
// Created by angcyo on 21/08/27.
//

import Foundation
import SFSafeSymbols

/// 图标库 https://github.com/piknotech/SFSafeSymbols
///pod 'SFSafeSymbols', '~> 2.1.3'

private func test() {
    let symbol: SFSymbol = .xCircle
}

func sfImage(_ symbol: SFSymbol) -> UIImage {
    UIImage(systemSymbol: symbol)
}

/// 圈圈中带个x
func sfXCircle() -> UIImage {
    UIImage(systemSymbol: .xCircle)
}

func sfXCircleFill() -> UIImage {
    UIImage(systemSymbol: .xCircleFill)
}