//
// Created by angcyo on 21/08/27.
//

import Foundation
import SFSafeSymbols

/// 图标库 https://github.com/piknotech/SFSafeSymbols
///pod 'SFSafeSymbols', '~> 2.1.3'

func sfImage(_ symbol: SFSymbol) -> UIImage {
    UIImage(systemSymbol: symbol)
}