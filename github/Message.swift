//
// Created by angcyo on 21/08/11.
//

import Foundation
import SwiftMessages

/// https://github.com/SwiftKickMobile/SwiftMessages

class Message {

}

func message(_ body: String, title: String = "", iconImage: UIImage? = nil,
             layout: MessageView.Layout = .cardView, theme: Theme = .info) {
    let view = MessageView.viewFromNib(layout: layout)
    view.configureTheme(theme)
    view.configureDropShadow()

    if let icon = iconImage {
        view.configureContent(title: title, body: body, iconImage: icon)
    } else {
        view.configureContent(title: title, body: body)
    }
    view.button?.isHidden = true

    //SwiftMessages.defaultConfig.presentationStyle = .bottom
    SwiftMessages.show(view: view)
}

func messageSuccess(_ body: String, title: String = "", iconImage: UIImage? = nil,
                    layout: MessageView.Layout = .cardView, theme: Theme = .success) {
    message(body, title: title, iconImage: iconImage, layout: layout, theme: theme)
}

func messageWarn(_ body: String, title: String = "", iconImage: UIImage? = nil,
                 layout: MessageView.Layout = .cardView, theme: Theme = .warning) {
    message(body, title: title, iconImage: iconImage, layout: layout, theme: theme)
}

func messageError(_ body: String, title: String = "", iconImage: UIImage? = nil,
                  layout: MessageView.Layout = .cardView, theme: Theme = .error) {
    message(body, title: title, iconImage: iconImage, layout: layout, theme: theme)
}