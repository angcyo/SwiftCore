//
// Created by angcyo on 21/08/18.
//

import Foundation
import UIKit
import TangramKit

/// 简单的编辑item, 带验证码按钮
class FormEditVerifyTableItem: FormEditTableItem {

    /// 请求验证码
    var onRequestCode: ((VerifyButton) -> Void)? = nil

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        guard let cell = cell as? FormEditVerifyTableCell else {
            return
        }

        //BUG, 需要重新调用才生效. 牛批plus
        initEditItem(cell.cellConfig.text)

        // 获取验证码
        cell.cellConfig.verifyButton.onClick(bag: gestureDisposeBag) { _ in
            if let request = self.onRequestCode {
                request(cell.cellConfig.verifyButton)
                //cell.cellConfig.verifyButton.startCountDown(), 请手动调用
            }
        }
    }

    //MARK: 代理方法

    override func textFieldDidChangeSelection(_ textField: UITextField) {
        super.textFieldDidChangeSelection(textField)
    }

    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        super.textFieldShouldReturn(textField)
    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}

class FormEditVerifyTableCell: FormEditTableCell {

    let cellConfig: FormEditVerifyCellConfig = FormEditVerifyCellConfig()

    override func getCellConfig() -> IDslCellConfig? {
        cellConfig
    }
}

//MARK: cell 界面声明, 用于兼容UITableView和UICollectionView

class FormEditVerifyCellConfig: FormEditCellConfig {

    let verifyButton = VerifyButton()

    override func initCellContent() -> UIView {
        rightTitle.gone()
        let content = super.initCellContent()
        wrap.render(verifyButton) {
            $0.wrap_content()
        }
        return content
    }
}