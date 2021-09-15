//
// Created by angcyo on 21/08/27.
//

import Foundation
import SFSafeSymbols

/// 图标库 https://github.com/piknotech/SFSafeSymbols
///pod 'SFSafeSymbols', '~> 2.1.3'

private func test() {
    let symbol: SFSymbol = .xCircle /// 􀀲
}

func sfImage(_ symbol: SFSymbol) -> UIImage {
    UIImage(systemSymbol: symbol)
}

/// 圈圈中带个x
func sfXCircle() -> UIImage {
    UIImage(systemSymbol: .xCircle) /// 􀀲
}

func sfXCircleFill() -> UIImage {
    UIImage(systemSymbol: .xCircleFill) /// 􀀳
}

/// 􀄨
func sfArrowUp() -> UIImage {
    UIImage(systemSymbol: .arrowUp)
}

/// 􀄩
func sfArrowDown() -> UIImage {
    UIImage(systemSymbol: .arrowDown)
}

/// 􀄪  //chevron.backward chevronBackward
func sfArrowLeft() -> UIImage {
    UIImage(systemSymbol: .arrowLeft)
}

/// 􀄫
func sfArrowRight() -> UIImage {
    UIImage(systemSymbol: .arrowRight)
}

/// 􀁼
func sfArrowRightCircle() -> UIImage {
    UIImage(systemSymbol: .arrowRightCircle)
}

/// 􀊯
func sfArrowTriangle2Circlepath() -> UIImage {
    UIImage(systemSymbol: .arrowTriangle2Circlepath)
}

/// 􀖋
func sfArrowTriangle2CirclepathCircleFill() -> UIImage {
    UIImage(systemSymbol: .arrowTriangle2CirclepathCircleFill)
}

/// 􀌢
func sfArrowTriangle2CirclepathCamera() -> UIImage {
    UIImage(systemSymbol: .arrowTriangle2CirclepathCamera)
}

/// 􀄴
func sfArrowTurnDownLeft() -> UIImage {
    UIImage(systemSymbol: .arrowTurnDownLeft)
}

/// 􀄵
func sfArrowTurnDownRight() -> UIImage {
    UIImage(systemSymbol: .arrowTurnDownRight)
}




