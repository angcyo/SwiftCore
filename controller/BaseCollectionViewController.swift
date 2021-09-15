//
// Created by angcyo on 21/09/14.
//

import Foundation
import UIKit
import RxSwift
import RxKeyboard
import JXPagingView

class BaseCollectionViewController: BaseViewController, JXPagingViewListViewDelegate {

    lazy var recyclerView: DslCollectionView = {
        createCollectionView()
    }()

    /// 激活键盘监听
    var enableSoftInput: Bool = true {
        didSet {
            initKeyboard()
        }
    }

    /// 是否激活下拉刷新
    var enableRefresh: Bool = false {
        didSet {
            initRefresh()
        }
    }

    /// page
    var httpPage = HttpPage()

    /// 创建视图
    func createCollectionView() -> DslCollectionView {
        DslCollectionView()
        //.apply {
        //let insets = view.safeAreaInsets
        //print($0)
        //$0.safeAreaLayoutGuide.topAnchor.constraint(equalTo: navController.navigationBar.bottomAnchor)
        //$0.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor)
        //}
    }

    /// 键盘监听Bag
    lazy var keyboardBag: DisposeBag = {
        DisposeBag()
    }()

    /// 监听键盘
    func initKeyboard() {
        keyboardBag = DisposeBag()
        if enableSoftInput {
            //键盘监听
            RxKeyboard.instance.visibleHeight.drive(onNext: { height in
                let recyclerView = self.recyclerView
                let inset = recyclerView.contentInset
                recyclerView.contentInset = inset.resetBottom(height.toFloat())

                //滚动到具有接收者的当前行
                if let cell = recyclerView.findFirstResponder()?.findAttachedCollectionCell() {
                    if let index = recyclerView.indexPath(for: cell) {
                        recyclerView.scrollToItem(at: index, at: .top, animated: true)
                    }
                }
            }).disposed(by: keyboardBag)
        }
    }

    lazy var refreshControl: UIRefreshControl = {
        UIRefreshControlFix()
    }()

    func initRefresh() {
        if enableRefresh {
            recyclerView.refreshControl = refreshControl
            refreshControl.removeTarget(nil, action: nil, for: .valueChanged)
            refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)

            //请求数据
            recyclerView.toStatusRefresh()
        }
    }

    /// 刷新的回调
    @objc func onRefresh(_ sender: Any) {
        //httpPage.onPageRefresh()
        /*L.i("触发刷新:\(sender)")
        doMain(2) {
            self.refreshControl.endRefreshing()
        }*/
        onStatusRefresh()
    }

    override func initControllerView() {
        super.initControllerView()
        //dslTableView = DslTableView()
        initCollectionView(recyclerView: recyclerView)
        initItemStatus(recyclerView: recyclerView)
        initKeyboard()
        initRefresh()
    }

    /// 初始化
    func initCollectionView(recyclerView: DslCollectionView) {
        view.render(recyclerView)
        if recyclerView.frame.isEmpty {
            recyclerView.make {
                $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
                $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)

                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                //$0.bottom.equalTo(UIScreen.height)//view.safeAreaLayoutGuide.snp.bottom
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }

        //转发
        recyclerView.onScrollViewDidScrollList.add {
            self.listViewDidScrollCallback?($0)
        }
    }

    func initItemStatus(recyclerView: DslCollectionView) {
        if let statusItem = recyclerView.statusItem as? BaseStatusTableItem {
            statusItem.onItemRefresh = { _ in
                self.onStatusRefresh()
            }
        }

        if let statusItem = recyclerView.loadMoreItem as? BaseStatusTableItem {
            statusItem.onItemRefresh = { _ in
                self.onStatusLoadMore()
            }
        }

        if Core.shared.enableFullscreenPopGesture {
            recyclerView.sh_scrollViewPopGestureRecognizerEnable = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func onStatusRefresh() {
        httpPage.onPageRefresh()
        onLoadData()
    }

    func onStatusLoadMore() {
        httpPage.onPageLoadMore()
        onLoadData()
    }

    /// 重写此方法, 实现刷新/加载更多数据
    func onLoadData() {
        //no op
    }

    /// 加载数据结束
    func onLoadDataEnd() {
        refreshControl.endRefreshing()
        //recyclerView.toStatusContent()
    }

    /// 数据加载结束调用此方法
    func loadDataEnd<T: DslItem>(_ itemClass: T.Type = T.self,
                                 dataList: [Any?]?,
                                 error: Error? = nil,
                                 page: HttpPage? = nil,
                                 itemProvide: SectionItemProvide? = nil,
                                 dsl: ((T) -> Void)? = nil) {
        let page = page ?? httpPage
        let itemProvide = itemProvide ?? recyclerView.defaultItemProvide
        itemProvide.loadDataEnd(itemClass, dataList: dataList, error: error, page: page, dsl: dsl)
        onLoadDataEnd()
    }

    /*override func sceneDidBecomeActive(_ scene: UIScene) {
        super.sceneDidBecomeActive(scene)

        if enableSoftInput {
            let inset = dslTableView.contentInset
            doMain {
                self.dslTableView.contentInset = inset
            }
        }
    }*/


    //MARK: JXPagingViewListViewDelegate

    func listView() -> UIView {
        view
    }

    func listScrollView() -> UIScrollView {
        recyclerView
    }

    var listViewDidScrollCallback: ((UIScrollView) -> ())?

    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        listViewDidScrollCallback = callback
    }

    func listScrollViewWillResetContentOffset() {
        L.d("")
    }

    func listWillAppear() {
        L.d("")
    }

    func listDidAppear() {
        L.d("")
    }

    func listWillDisappear() {
        L.d("")
    }

    func listDidDisappear() {
        L.d("")
    }

    //MARK: JXPagingViewListViewDelegate .end

}
