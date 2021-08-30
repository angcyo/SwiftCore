//
// Created by angcyo on 21/08/30.
//

import Foundation
import UIKit

///# https://github.com/swifty-iOS/RadioCheckboxButton
///pod 'MBRadioCheckboxButton'

/// 单选按钮
func mbRadioButton() -> RadioButton {
    let button = RadioButton()
    return button
}

/// 多选按钮
func mbCheckboxButton() -> CheckboxButton {
    let button = CheckboxButton()
    button.checkBoxColor = CheckBoxColor(
            activeColor: Res.color.colorPrimary,
            inactiveColor: Res.color.clear,
            inactiveBorderColor: Res.color.iconColor,
            checkMarkColor: Res.color.white
    )
    button.checkboxLine = CheckboxLineStyle(checkBoxHeight: 15, checkmarkLineWidth: -1, padding: 6)
    button.setTextSize(Res.text.normal.size)
    button.setTextColor(Res.color.iconColor)
    button.titleLabel?.numberOfLines = 0
    button.contentVerticalAlignment = .center //勾对齐方式
    //button.contentHorizontalAlignment = .center

    //button.backgroundColor = UIColor.black

    return button
}