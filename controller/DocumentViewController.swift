//
// Created by angcyo on 21/09/10.
//

import Foundation
import UIKit

/// 本地文档查看器

///https://github.com/MinMao-Hub/readDoc
///https://github.com/pengshengsongcode/UIDocumentInteractionController

/*
 UIDocumentInteractionController是iOS 很早就出来的一个功能。但由于平时很少用到，压根就没有听说过它。而我们忽略的却是一个功能强大的”文档阅读器”。
 UIDocumentInteractionController主要有两个功能，一个是文件预览，另一个就是调用iPhoneh里第三方相关的app打开文档（注意这里不是根据url scheme 进行识别，而是苹果的自动识别）
 */

class DocumentViewController: BaseViewController, UIDocumentInteractionControllerDelegate {

    //文档url
    let url: URL

    init(url: URL) {
        self.url = url
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initController() {
        super.initController()
        modalPresentationStyle = .fullScreen
    }

    var _documentController: UIDocumentInteractionController? = nil

    override func initControllerView() {
        super.initControllerView()
        //self._documentController = UIDocumentInteractionController(url: self.url)
        //self._documentController.delegate = self
        //_documentController.presentOptionsMenu(from: view.frame, in: view, animated: true) //分享菜单
        //self._documentController.presentPreview(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if _documentController == nil {
            _documentController = UIDocumentInteractionController(url: url)
            _documentController?.delegate = self
            _documentController?.presentPreview(animated: false)
        }
    }

    //MARK: UIDocumentInteractionControllerDelegate

    /*@IBAction func preViewDocument(_ sender: AnyObject) {
        //当前APP打开  需实现协议方法才可以完成预览功能
        _documentController?.presentPreview(animated: true)
    }

    @IBAction func openDocument(_ sender: AnyObject) {
        //第三方打开 手机中安装有可以打开此格式的软件都可以打开
        _documentController?.presentOpenInMenu(from: (sender as! UIButton).frame, in: view, animated: true)
    }*/

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        self
    }

    /* func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
         view
     }

     func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
         view.frame
     }
 */
    func documentInteractionControllerWillBeginPreview(_ controller: UIDocumentInteractionController) {
        L.i("开始预览")
    }

    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        L.i("结束预览")
        hide(self)
    }
}

