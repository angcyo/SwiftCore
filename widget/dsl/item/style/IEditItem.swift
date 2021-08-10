//
// Created by angcyo on 21/08/10.
//

import Foundation
import UIKit

protocol IEditItem: IDslItem, UITextFieldDelegate {
    var itemEditText: String? { get set }
}

extension IEditItem {

    func initEditItem(_ textField: UITextField) {
        textField.text = itemEditText
        textField.delegate = self
    }

}