//
// Created by angcyo on 21/09/10.
//

import Foundation
import UIKit

///可以分享文字，图片，音视频到其它平台
/// https://www.jianshu.com/p/e765ec4bc6cd
protocol ShareObject {

}

extension ShareObject {

    ///
    func share() {
        let vc = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        vc.completionWithItemsHandler = { type, completion, items, error in
            L.d(items)
            L.d(error)
        }
        show(vc)
    }
}



