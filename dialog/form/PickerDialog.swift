//
// Created by angcyo on 21/08/23.
//

import Foundation
import UIKit
import TangramKit

/// 滚轮选择
class PickerDialog: BaseFormDialog, UIPickerViewDelegate, UIPickerViewDataSource {

    let pickerView = UIPickerView()

    /// 选项
    var pickerItems: [String?]? = [] {
        didSet {
            empty.show(nilOrEmpty(pickerItems))
        }
    }

    /// 选中
    var pickerItem: String? = nil

    /// 回调, 返回true, 表示拦截默认处理
    var onDialogResult: ((_ dialog: PickerDialog, _ row: Int) -> Bool)? = nil

    override func initContentLayout(_ content: UIView) {
        title.text = "请选择"

        content.render(pickerView) {
            $0.makeFullWidth()
            $0.makeFullHeight()
            //$0.backgroundColor = UIColor.yellow
        }
        content.render(empty) {
            $0.sizeToFit()
            $0.makeCenter()
        }

        initPickerView()
    }

    func initPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        confirm.isEnabled = false
        //pickerView.backgroundColor = UIColor.red
    }

    override func onConfirmClick() {
        let selected = pickerView.selectedRow(inComponent: 0)
        if let result = onDialogResult {
            if !result(self, selected) {
                hide()
            }
        } else {
            debugPrint("选中:\(selected)")
            hide()
        }
    }

    override func onDialogShow() {
        super.onDialogShow()
        pickerDefaultItem()
    }

    /// 默认选中
    func pickerDefaultItem() {
        if let pickerItems = pickerItems {
            if !pickerItems.isEmpty {
                if let item = pickerItem {
                    let index = pickerItems.firstIndexOf(item)
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                } else {
                    let index = 0
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                    pickerView(pickerView, didSelectRow: index, inComponent: 0) //手动触发回调
                }
            }
        }
    }

    //MARK: UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerItems?[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        debugPrint("didSelectRow:\(row)")
        confirm.isEnabled = pickerItem != pickerItems?[row]
    }

    //MARK: UIPickerViewDataSource

    /// 多少个滚轮
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    /// 每个滚轮有多少个item
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerItems?.count ?? 0
    }
}

func pickerDialog(_ dsl: (PickerDialog) -> Void) {
    let dialog = PickerDialog()
    dsl(dialog)
    dialog.show()
}