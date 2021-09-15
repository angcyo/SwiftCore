//
// Created by angcyo on 21/09/15.
//

import Foundation
import JXPagingView
import JXSegmentedView

///https://github.com/pujiaxin33/JXSegmentedView
///https://github.com/pujiaxin33/JXPagingView

/// 分段详情页

extension JXPagingListContainerView: JXSegmentedViewListContainer {
}

class BaseSegmentDetailController: BaseViewController, JXSegmentedViewDelegate {

    ///需要改变高度的view
    static let changeHeightView = "changeHeightView"

    ///page左右切换视图
    lazy var pagingView: JXPagingView = createPagingView()
    ///头部视图
    lazy var headerView: UIView = createHeaderView()
    ///头部背景视图, 这个布局不在page view中, 直接在vc中
    lazy var headerBgView: UIView = createHeaderBgView()
    ///头部的高度
    var headerViewHeight: Int = (UIScreen.height / 3).toInt() {
        willSet {
            if headerViewHeight != newValue {
                pagingView.resizeTableHeaderViewHeight()
                initHeaderBgView()
            }
        }
    }

    lazy var segmentedView: JXSegmentedView = createSegmentedView()

    /// 必须强引用
    lazy var segmentedDataSource: JXSegmentedBaseDataSource = createSegmentedDataSource()

    ///需要悬停固定的高度
    var fixedSectionHeader: Int = Res.size.itemMinHeight.toInt()

    override func initController() {
        super.initController()

        showNavigationBar = false
    }

    override func initControllerView() {
        super.initControllerView()

        initHeaderView()
        initSegmentedView()
        initPagingView()
        initNavigationBar()
        initHeaderBgView() //last
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.frame = view.frame
    }

    //MARK: 自定义的导航栏

    /// 导航栏的高度
    var navigationBarHeight: CGFloat {
        if let view = navigationBarWrap {
            if view.height > 0 {
                return view.height
            } else {
                return defaultNavHeight
            }
        } else {
            return 0
        }
    }

    func initNavigationBar() {
        renderNavigationBar(backItem: true)
        navigationBarWrap?.backgroundColor = .clear

        //默认不显示标题, 滑动后才显示
        navigationItem.title = nil

        //offset
        pagingView.pinSectionHeaderVerticalOffset = navigationBarHeight.toInt()
    }

    //MARK: headerBgView

    func createHeaderBgView() -> UIView {
        let view = v()
        return view
    }

    func initHeaderBgView() {
        headerBgView.backgroundColor = Res.color.bg
        headerBgView.frame = CGRect(x: 0, y: 0,
                width: view.width,
                height: headerViewHeight.toCGFloat() + fixedSectionHeader.toCGFloat() + navigationBarHeight)
        view.insertSubview(headerBgView, at: 0)
    }

    //MARK: headerView

    func createHeaderView() -> UIView {
        let view = v()
        return view
    }

    func initHeaderView() {
        let label = subTitleView(title)
        headerView.render(label) {
            $0.makeGravityLeft(offset: Res.size.x)
            $0.makeGravityBottom(offset: Res.size.x)
        }
    }

    //MARK: pagingView

    /// 快速设置, [JXPagingView]
    var pageControllers: [JXPagingViewListViewDelegate] = []

    func createPagingView() -> JXPagingView {
        JXPagingView(delegate: self)
    }

    func initPagingView() {
        pagingView.mainTableView.gestureDelegate = self
        pagingView.mainTableView.backgroundColor = .clear
        view.addSubview(pagingView)

        //扣边返回处理，下面的代码要加上
        if let nav = navigationController {
            if let popGesture = nav.interactivePopGestureRecognizer {
                pagingView.listContainerView.scrollView.panGestureRecognizer.require(toFail: popGesture)
                pagingView.mainTableView.panGestureRecognizer.require(toFail: popGesture)
            }
        }
    }

    //MARK: JXSegmentedView

    func createSegmentedView() -> JXSegmentedView {
        JXSegmentedView(frame: CGRect(x: 0, y: 0, width: view.width, height: fixedSectionHeader.toCGFloat()))
    }

    func createSegmentedDataSource() -> JXSegmentedBaseDataSource {
        //数据源
        let segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource.titles = segmentedTitles
        segmentedDataSource.titleSelectedColor = Res.color.colorAccent
        segmentedDataSource.titleNormalColor = Res.text.des2.color
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.isTitleZoomEnabled = true
        segmentedDataSource.titleNormalFont = UIFont.systemFont(ofSize: Res.text.des2.size)
        segmentedDataSource.isTitleStrokeWidthEnabled = true
        segmentedDataSource.isItemSpacingAverageEnabled = true
        return segmentedDataSource
    }

    /// 圆角大小
    var segmentedRoundTop = Res.size.roundCommon

    /// 快速设置, 使用title设置[JXSegmentedView]
    var segmentedTitles: [String] = []

    func initSegmentedView() {

        segmentedView.backgroundColor = UIColor.white
        segmentedView.delegate = self
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.dataSource = segmentedDataSource

        segmentedView.setRoundTop(segmentedRoundTop)
        //关联page view
        segmentedView.listContainer = pagingView.listContainerView

        //指示器
        let indicatorView = JXSegmentedIndicatorLineView()
        indicatorView.indicatorColor = Res.color.colorAccent
        indicatorView.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicatorView.isIndicatorWidthSameAsItemContent = true
        segmentedView.indicators = [indicatorView]

        //下面的横线
        let lineHeight = 1 / UIScreen.main.scale
        let bottomLineView = lineView()
        bottomLineView.frame = CGRect(x: 0, y: segmentedView.bounds.height - lineHeight, width: segmentedView.bounds.width, height: lineHeight)
        segmentedView.addSubview(bottomLineView)
    }

    //MARK: JXSegmentedViewDelegate

    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
}

//MARK: JXPagingViewDelegate

extension BaseSegmentDetailController: JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        headerViewHeight
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        headerView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        fixedSectionHeader
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        segmentedDataSource.preferredItemCount()
    }

    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        let height = tableHeaderViewHeight(in: pagingView).toCGFloat()

        //背景高度变化
        changeViewHeight(scrollView, view: headerBgView, defaultHeight: height + fixedSectionHeader.toCGFloat(), offsetY: false)

        if let view = headerView.find(BaseSegmentDetailController.changeHeightView) {
            changeViewHeight(scrollView, view: view, defaultHeight: height)
        } else if headerView.subviews.count == 1 {
            let view = headerView.subviews[0]
            changeViewHeight(scrollView, view: view, defaultHeight: height)
        } else {
            //头部布局需要包含一个可变高度的view
        }

        //导航栏渐变
        let thresholdDistance: CGFloat = navigationBarHeight
        var percent = scrollView.contentOffset.y / thresholdDistance
        percent = max(0, min(1, percent))
        navigationBarWrap?.backgroundColor = .clear.toColor(Res.color.controllerBackgroundColor, fraction: percent)

        let heightThreshold: CGFloat = height - navigationBarHeight
        var heightPercent = scrollView.contentOffset.y / heightThreshold
        heightPercent = max(0, min(1, heightPercent))

        //标题显示/隐藏
        if heightPercent >= 1 {
            navigationItem.title = title
        } else {
            navigationItem.title = nil
        }

        //圆角过渡
        if segmentedRoundTop > 0 {
            segmentedView.setRoundTop(Res.size.roundCommon.toCGFloat(0, fraction: heightPercent))
        }
    }

    ///获取page 内容controller. 只会创建一次
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        pageControllers[index]
    }
}

//MARK: JXPagingMainTableViewGestureDelegate

extension BaseSegmentDetailController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //禁止segmentedView左右滑动的时候，上下和左右都可以滚动
        if otherGestureRecognizer == segmentedView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}
