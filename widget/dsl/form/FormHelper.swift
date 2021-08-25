//
// Created by angcyo on 21/08/10.
//

import Foundation
import UIKit

extension DslRecycleView {

    //MARK: - 单独检查数据, 不获取数据

    /// 检查表单数据, 如果某一个item数据验证失败, 则返回失败的原因以及对应的位置
    func checkData(_ params: FormParams, end: (IndexPath?, Error?) -> Void) {
        let itemList = getItemList(params.userVisibleItem)
        _checkData(params, itemList: itemList, index: 0, end: end)
    }

    func _checkData(_ params: FormParams, itemList: [DslItem], index: Int, end: (IndexPath?, Error?) -> Void) {
        let count = itemList.count
        if index >= count {
            end(nil, nil)
        } else {
            let item = itemList.get(index)
            if let formItem = item as? IFormItem {
                params.formItem = formItem
                formItem.formItemConfig.formCheck(params) { error in
                    params.formItem = nil
                    if let error = error {
                        end(item?.itemIndex, error)
                    } else {
                        _checkData(params, itemList: itemList, index: index + 1, end: end)
                    }
                }
            } else {
                _checkData(params, itemList: itemList, index: index + 1, end: end)
            }
        }
    }

    //MARK: - 单独获取数据, 不检查

    /// 获取表单数据
    func obtainData(_ params: FormParams, end: (Error?) -> Void) {
        let itemList = getItemList(params.userVisibleItem)
        _obtainData(params, itemList: itemList, index: 0, end: end)
    }

    /// 递归循环获取
    func _obtainData(_ params: FormParams, itemList: [DslItem], index: Int, end: (Error?) -> Void) {
        let count = itemList.count
        if index >= count {
            end(nil)
        } else {
            let item = itemList.get(index)
            if let formItem = item as? IFormItem {
                params.formItem = formItem
                formItem.formItemConfig.formObtain(params) { error in
                    params.formItem = nil
                    if let error = error {
                        end(error)
                    } else {
                        _obtainData(params, itemList: itemList, index: index + 1, end: end)
                    }
                }
            } else {
                _obtainData(params, itemList: itemList, index: index + 1, end: end)
            }
        }
    }

    //MARK: - 检查数据的同时, 获取数据

    func checkAndObtainData(_ params: FormParams, end: (IndexPath?, Error?) -> Void) {
        let itemList = getItemList(params.userVisibleItem)
        _checkAndObtainData(params, itemList: itemList, index: 0, end: end)
    }

    func _checkAndObtainData(_ params: FormParams, itemList: [DslItem], index: Int, end: (IndexPath?, Error?) -> Void) {
        let count = itemList.count
        if index >= count {
            end(nil, nil)
        } else {
            let item = itemList.get(index)
            if let formItem = item as? IFormItem {
                params.formItem = formItem
                formItem.formItemConfig.formCheck(params) { error in
                    params.formItem = nil
                    if let error = error {
                        end(item?.itemIndex, error)
                    } else {
                        //检查无错误, 则获取数据
                        params.formItem = formItem
                        formItem.formItemConfig.formObtain(params) { error in
                            params.formItem = nil
                            if let error = error {
                                end(item?.itemIndex, error)
                            } else {
                                // 获取数据之后
                                _checkAndObtainData(params, itemList: itemList, index: index + 1, end: end)
                            }
                        }
                    }
                }
            } else {
                _checkAndObtainData(params, itemList: itemList, index: index + 1, end: end)
            }
        }
    }
}

//MARK: FormHelper

class FormHelper {

    var _animLayer: CALayer? = nil

    /// 数据获取
    func checkAndObtain(_ tableView: DslTableView, _ params: FormParams? = nil, _ end: (FormParams, Error?) -> Void) {
        let p = params ?? FormParams()
        tableView.checkAndObtainData(p) { path, error in
            if let error = error {
                debugPrint(error.message)
                // 不通过
                if let path = path {
                    // 有路径
                    tableView.scrollToRow(at: path, at: .top, animated: true)
                    tipCellError(tableView: tableView, at: path)
                } else {
                    //无路径
                    toast(error.message, position: .top)
                }
                end(p, error)
            } else {
                end(p, nil)
            }
        }
    }

    /// 在cell上进行错误提示
    func tipCellError(tableView: UITableView, at: IndexPath) {
        if let cell = tableView.cellForRow(at: at) {
            let frame = tableView.convert(cell.frame, from: cell.itemCellView)
            tipCellError(tableView: tableView, frame: frame)
        }
    }

    /// 在指定的[frame]位置绘制矩形动画
    func tipCellError(tableView: UITableView, frame: CGRect) {
        _animLayer?.removeAllAnimations()
        _animLayer?.removeFromSuperlayer()

        CATransaction.begin()

        let layer: CAShapeLayer = CAShapeLayer()
        layer.strokeColor = Res.color.error.cgColor
        layer.lineWidth = 2.0
        layer.fillColor = UIColor.clear.cgColor

        //let path: UIBezierPath = UIBezierPath(roundedRect: frame, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: Res.size.roundNormal, height: Res.size.roundNormal))
        let path: UIBezierPath = UIBezierPath(rect: frame).reversing()
        layer.path = path.cgPath

        let animation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0

        animation.duration = 0.6

        CATransaction.setCompletionBlock {
            layer.removeFromSuperlayer()
            self._animLayer = nil
        }

        layer.add(animation, forKey: nil)
        tableView.layer.addSublayer(layer)
        //tableView.layer.setNeedsDisplay()
        //tableView.layoutIfNeeded()

        CATransaction.commit()
        _animLayer = layer
    }
}

/// share
let formHelper = FormHelper()