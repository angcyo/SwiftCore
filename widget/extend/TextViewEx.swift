//
//  TextViewEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/28.
//

import Foundation
import UIKit

func tv() -> UITextView {
    let view = UITextView()
    view.font = Res.font.normal
    view.isEditable = true
    view.textColor = Res.text.normal.color

    view.textContainer.maximumNumberOfLines = 0 //最大行数
    view.textContainer.lineBreakMode = .byWordWrapping //最后一行行为
    return view
}
