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
    var formRequired: Bool = false {
        didSet {
            if formRequired {
                formIgnore = false
            }
        }
    }

    /// 表单是否可编辑
    var formCanEdit: Bool = true

    /// 是否忽略此表单, 默认忽略表单. 在表单必填时打开, 或者表单内容改变后打开
    var formIgnore: Bool = true

    /// 保存form的value 在[onGetFormValue]中使用, 优先使用此值
    var formValue: Any? = nil

    ///获取表单的值 [formCheck] [formObtain]
    var onGetFormValue: (_ params: FormParams) -> Any? = { params in
        if let item = params.formItem {

            // 优先使用
            if let value = params.formItem?.formItemConfig.formValue {
                return value
            }

            //其次
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
        let formItemConfig = params.formItem?.formItemConfig
        if formItemConfig?.formIgnore == true {
            end(nil)
        } else {
            if (formItemConfig?.formRequired == true) {
                let value = formItemConfig?.onGetFormValue(params)
                if (value == nil) {
                    end(error("无效的值"))
                } else {
                    if value is String {
                        if nilOrEmpty(value as? String) {
                            end(error("无效的值"))
                        } else {
                            end(nil)
                        }
                    } else if value is Array<Any?> {
                        if nilOrEmpty(value as? Array<Any?>) {
                            end(error("无效的值"))
                        } else {
                            end(nil)
                        }
                    } /*else if value is Set<Any> {
                        if nilOrEmpty(value as? Set<Hashable>) {
                            end(error("无效的值"))
                        } else {
                            end(nil)
                        }
                    } */else if value is Dictionary<String, Any?> {
                        if nilOrEmpty(value as? Dictionary<String, Any?>) {
                            end(error("无效的值"))
                        } else {
                            end(nil)
                        }
                    } else {
                        end(nil)
                    }
                }
            } else {
                end(nil)
            }
        }
    }

    /**获取form item对应的表单数据, 附件会自动解析
     * [end] 异步获取数据结束之后的回调*/
    var formObtain: (_ params: FormParams, _ end: (_ error: Error?) -> Void) -> Void = { params, end in
        let formItemConfig = params.formItem?.formItemConfig
        if formItemConfig?.formIgnore == true {
            end(nil)
        } else {
            let key = formItemConfig?.formKey
            if nilOrEmpty(key) {
                end(nil)
            } else {
                let formValue = formItemConfig?.onGetFormValue(params)
                if let formValue = formValue {
                    params.put(key!, formValue)
                    end(nil)
                } else {
                    print("跳过空值formKey[\(key)]")
                    end(nil)
                }
            }
        }
    }
}