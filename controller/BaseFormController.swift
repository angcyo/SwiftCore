//
// Created by angcyo on 21/09/16.
//

import Foundation

/// 基础表单页面

class BaseFormController: BaseTableViewController {

    override func createTableView() -> DslTableView {
        DslTableView(style: .insetGrouped)
    }

    func onSubmit() {
        //no op
    }

    func submit(_ submitAction: @escaping (FormParams) -> Void) {
        formHelper.checkAndObtain(recyclerView) { params, error in
            L.w("表单数据:\(params.params())")

            if let error = error {
                toast(error.message, position: .center)
            } else if params.isEmpty() {
                messageSuccess("未编辑内容")
                pop(self)
            } else {
                hideKeyboard()
                showLoading()

                params.uploadFile { error in
                    if let error = error {
                        hideLoading()
                        messageError(error.message)
                    } else {
                        submitAction(params)

                        /*vm(UserModel.self).putUserDetail(param: params.params()) { json, error in
                            hideLoading()
                            if let error = error {
                                messageError(error.message)
                            } else {
                                messageSuccess("修改成功")
                                pop(self)
                            }
                        }*/
                    }
                }
            }
        }
    }
}