//
// Created by angcyo on 21/08/10.
//

import Foundation
import SwiftyJSON

/// 表单控件接口, 用来获取表单数据
protocol IFormItem: IDslItem {

    /// 表单item的配置项
    /// var formItemConfig: FormItemConfig = FormItemConfig()
    var formItemConfig: FormItemConfig { get set }
}

class FormItemConfig {

    /**数据key*/
    var formKey: String? = nil

    /**表单是否必填. 为true, 将会在 label 前面绘制 红色`*` */
    var formRequired: Bool = false

    /// 表单是否可编辑
    var formCanEdit: Bool = true

    /**获取表单的值*/
    var onGetFormValue: (_ params: FormParams) -> Any? = { params in
        if let item = params.formItem {
            if let editItem = item as? IEditItem {
                return editItem.editItemConfig.itemEditText
            }
            return nil
        } else {
            return nil
        }
    }

    /// 检查item是否有错误, 通过end回调, 返回框架错误信息. 无错误回调nil
    var formCheck: (_ params: FormParams, _ end: (_ error: Error?) -> Void) -> Void = { params, end in
        if (params.formItem?.formItemConfig.formRequired == true) {
            let value = params.formItem?.formItemConfig.onGetFormValue(params)
            if (value == nil) {
                end(error("无效的值"))
            } else if nilOrEmpty(value as? String) {
                end(error("无效的值"))
            } else if nilOrEmpty(value as? Array<Any>) {
                end(error("无效的值"))
            } else if nilOrEmpty(value as? Dictionary<String, Any>) {
                end(error("无效的值"))
            } else {
                end(nil)
            }
        } else {
            end(nil)
        }
    }

    /**获取form item对应的表单数据, 附件会自动解析
     * [end] 异步获取数据结束之后的回调*/
    var formObtain: (_ params: FormParams, _ end: (_ error: Error?) -> Void) -> Void = { params, end in
        let key = params.formItem?.formItemConfig.formKey
        if nilOrEmpty(key) {
            end(nil)
        } else {
            let formValue = params.formItem?.formItemConfig.onGetFormValue(params)
            if let formValue = formValue {
                params.put(key!, formValue)
                end(nil)
            } else {
                debugPrint("跳过空值formKey[\(key)]")
                end(nil)
            }
        }
    }
}