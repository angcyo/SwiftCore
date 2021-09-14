//
// Created by angcyo on 21/09/10.
//

import Foundation

/// 分页接口参数

class HttpPage {

    /// 只有一页
    static var singlePage: HttpPage {
        get {
            let page = HttpPage()
            page.requestSize = .max
            return page
        }
    }

    //第一个页,默认值
    static var FIRST_PAGE = 1
    //第二页,默认值
    static var PAGE_SIZE = 20

    //第一页
    var firstPage: Int = HttpPage.FIRST_PAGE

    //需要请求的页面
    var requestPage: Int = HttpPage.FIRST_PAGE
    //需要请求的数据大小
    var requestSize: Int = HttpPage.PAGE_SIZE

    //当前页
    fileprivate var currentPage: Int = HttpPage.FIRST_PAGE

    /// 刷新页面
    func onPageRefresh() {
        requestPage = firstPage
        currentPage = firstPage
    }

    /// 加载下一页
    func onPageLoadMore() {
        requestPage = currentPage + 1
    }

    /// 刷新页面
    func onPageEnd() {
        currentPage = requestPage
    }
}