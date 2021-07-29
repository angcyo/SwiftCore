//
//  ImageViewEx.swift
//  Wayto.GBSecurity.iOS
//
//  Created by wayto on 2021/7/28.
//

import Foundation
import UIKit

func imageView(_ obj: Any? = nil) -> UIImageView {
    let view = UIImageView()
    if let o = obj {
        if o is String {
            view.image = UIImage(named: o as! String)
        } else if o is UIImage {
            view.image = o as! UIImage
        }
    }
    return view
}
