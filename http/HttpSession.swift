//
// Created by wayto on 2021/7/31.
//

import Foundation
import Alamofire

let httpSession: Session = {
    let configuration = URLSessionConfiguration.af.default
    //超时请求
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 30
    configuration.allowsCellularAccess = true
    configuration.allowsExpensiveNetworkAccess = true
    configuration.allowsConstrainedNetworkAccess = true
    return Session(configuration: configuration)
}()