//
// Created by angcyo on 21/08/09.
//

import Foundation
import UIKit

class DslCollectionView: UICollectionView, DslRecycleView, UICollectionViewDelegateFlowLayout {

    lazy var diffableDataSource: DslCollectionViewDiffableDataSource = {
        DslCollectionViewDiffableDataSource(self)
    }()

    lazy var recyclerDataSource: DslRecyclerDataSource = {
        DslRecyclerDataSource(self)
    }()

    lazy var sectionHelper: SectionHelper = {
        SectionHelper()
    }()

    lazy var statusItem: IStatusItem? = {
        DslStatusCollectionItem()
    }()

    lazy var loadMoreItem: IStatusItem? = {
        DslLoadMoreCollectionItem()
    }()

    /// 网格列数, 可以不指定. 指定了也不是强制生效. item配置具有最高优先级
    var spanCount: Int? = nil

    /// 列间距
    var minimumInteritemSpacing: CGFloat = Res.size.s

    /// 行间距
    var minimumLineSpacing: CGFloat = Res.size.s

    public convenience init(frame: CGRect = .zero) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //automaticSize:(width = 1.7976931348623157E+308, height = 1.7976931348623157E+308)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        //设置此size, 需要配合[preferredLayoutAttributesFitting], 要不然就固定死了.
        layout.estimatedItemSize = cgSize(Res.size.itemMinHeight)
        //layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.init(frame: frame, collectionViewLayout: layout)
    }

    public convenience init(frame: CGRect = .zero, spanCount: Int?) {
        self.init(frame: frame)
        self.spanCount = spanCount
    }

    override init(frame: CGRect = .zero, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCollectionView()
    }

    func initCollectionView() {
        bounces = true //边界回弹
        minimumZoomScale = 1
        maximumZoomScale = 1
        bouncesZoom = false //当达到最大限制时, 是否开启zoom

        //automaticallyAdjustsScrollIndicatorInsets
        contentInsetAdjustmentBehavior = .automatic //安全区域的行为
        //adjustedContentInset

        //边界回弹
        alwaysBounceVertical = true
        alwaysBounceHorizontal = false

        //selection
        allowsSelection = false //允许选择
        allowsMultipleSelection = false //多行选择

        if #available(iOS 14.0, *) {
            //编辑模式下是否允许选择
            allowsSelectionDuringEditing = false
            allowsMultipleSelectionDuringEditing = false
        }

        //collectionViewLayout

        //背景颜色, 默认是黑色
        backgroundColor = .clear //Res.color.bg

        delegate = self
        dataSource = diffableDataSource
    }

    /// 赋值和初始化
    func createCollectionViewCell(_ collectionView: UICollectionView, cellForRowAt indexPath: IndexPath, item: DslItem) -> UICollectionViewCell {
        //赋值
        item._dslRecyclerView = self

        let identifier = item.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        item.bindCell(cell, indexPath)
        item.itemUpdate = false
        return cell
    }

    // MARK: 加载item的机制

    /// 是否需要重新加载items
    var needsReload = false {
        didSet {
            if needsReload {
                // 需要更新数据
                setNeedsLayout()
            }
        }
    }

    /// 确保一个周期内, 触发一次更新
    override func layoutSubviews() {
        super.layoutSubviews()
        if needsReload {
            loadData(recyclerDataSource.getAllItem())
        }
    }

    // MARK: 代理 UICollectionViewDelegateFlowLayout

    /// 指定单元格的大小, 默认是50,50
    func collectionView(_ view: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 默认的大小
        var defSize = (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? cgSize(Res.size.itemMinHeight)
        if defSize == UICollectionViewFlowLayout.automaticSize {
            defSize = cgSize(Res.size.itemMinHeight)
        }

        if let item = getCollectionItem(indexPath) {

            //宽度计算
            var width: CGFloat

            var maxWidth = view.maxContextWidth
            if let _ = item.itemSpan ?? spanCount {
                //let sectionInsets = collectionView(view, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
                //maxWidth = maxWidth - sectionInsets.left - sectionInsets.right

                let itemSpan = item.itemSpan ?? 1 //需要占多少列
                let spanCount = spanCount ?? itemSpan //有多少列

                if spanCount > 1 {
                    let space = collectionView(view, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section) * (spanCount.toCGFloat() - 1)
                    maxWidth = maxWidth - space
                    width = floorf((maxWidth / spanCount.toCGFloat() * itemSpan.toCGFloat()).toFloat()).toCGFloat()
                } else {
                    width = maxWidth
                }

                //根据span, 自动计算宽度, 并赋值.
                item.itemWidth = width
            } else if item.itemWidth == UITableView.automaticDimension {
                //自动计算宽度
                if item._itemWidthCache > 0 {
                    width = item._itemWidthCache
                } else {
                    width = maxWidth
                }
            } else {
                width = item.itemWidth
            }

            //高度计算
            var height: CGFloat
            if item.itemHeight == UITableView.automaticDimension {
                //自动设置宽度, 请在[DslCollectionCell]的[preferredLayoutAttributesFitting]中设置
                if item._itemHeightCache > 0 {
                    height = item._itemHeightCache
                } else {
                    height = defSize.height //DslItem.automaticSize//UITableView.automaticDimension
                }
            } else {
                height = item.itemHeight
            }

            //返回
            return cgSize(width, height)
        }
        return defSize
    }

    /// section 的边界, 默认是0,0,0,0
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? UIEdgeInsets.zero
        return getSectionFirstCollectionItem(section)?.itemSectionEdgeInset ?? inset
    }

    /// section 中item的行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let space = getSectionFirstCollectionItem(section)?.itemSectionLineSpacing ?? /*flowLayout?.minimumLineSpacing ??*/ minimumLineSpacing
        L.d("minimumLineSpacingForSectionAt:\(section):\(space)")
        return space
    }

    /// section 中item的列间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let space = getSectionFirstCollectionItem(section)?.itemSectionInteritemSpacing ?? /*flowLayout?.minimumInteritemSpacing ??*/ minimumInteritemSpacing
        L.d("minimumInteritemSpacingForSectionAt:\(section):\(space)")
        return space
    }

    /// 标题视图的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        L.d("referenceSizeForHeaderInSection:\(section)")
        return (collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize ?? .zero
    }

    /// 页脚视图的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        L.d("referenceSizeForFooterInSection:\(section)")
        return (collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize ?? .zero
    }

    // MARK: 代理 UICollectionViewDelegate

    //MARK: highlight

    /// 需要高亮item
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        L.d("shouldHighlightItemAt:\(indexPath)")
        return getCollectionItem(indexPath)?.itemCanHighlight ?? false
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        L.i("didHighlightItemAt:\(indexPath)")
        getCollectionItem(indexPath)?.onItemHighlighted?(true, false)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        L.i("didUnhighlightItemAt:\(indexPath)")
        getCollectionItem(indexPath)?.onItemHighlighted?(false, false)
    }

    //MARK: select

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        L.d("shouldSelectItemAt:\(indexPath)")
        return getCollectionItem(indexPath)?.itemCanSelect ?? false
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        L.i("didSelectItemAt:\(indexPath)")
        getCollectionItem(indexPath)?.onItemSelected?(true, false)
    }

    //MARK: deselect

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        L.i("shouldDeselectItemAt:\(indexPath)")
        return getCollectionItem(indexPath)?.itemCanDeselect ?? false
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        L.i("didDeselectItemAt:\(indexPath)")
        getCollectionItem(indexPath)?.onItemSelected?(false, false)
    }

    //MARK: display

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        getItem(indexPath)?.bindCellWillDisplay(cell, indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        L.d("willDisplaySupplementaryView:\(elementKind):\(view):\(indexPath)")
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        getItem(indexPath)?.bindCellDidEndDisplaying(cell, indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        L.d("didEndDisplayingSupplementaryView:\(elementKind):\(view):\(indexPath)")
    }

    //MARK: menu

    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        fatalError("collectionView(_:shouldShowMenuForItemAt:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        fatalError("collectionView(_:canPerformAction:forItemAt:withSender:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    }

    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        fatalError("collectionView(_:transitionLayoutForOldLayout:newLayout:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        fatalError("collectionView(_:canFocusItemAt:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        fatalError("collectionView(_:shouldUpdateFocusIn:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    }

    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        fatalError("indexPathForPreferredFocusedView(in:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        fatalError("collectionView(_:targetIndexPathForMoveFromItemAt:toProposedIndexPath:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        L.d("targetContentOffsetForProposedContentOffset:\(proposedContentOffset)")
        return proposedContentOffset
    }

    //MARK: edit

    /// 在哪触发 onItemEditing ?
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        L.d("canEditItemAt:\(indexPath)")
        return getCollectionItem(indexPath)?.itemCanEdit ?? false
    }

    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        fatalError("collectionView(_:shouldSpringLoadItemAt:with:) has not been implemented")
    }

    /// 激活滑动多选
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        L.d("shouldBeginMultipleSelectionInteractionAt:\(indexPath)")
        return false
    }

    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
    }

    func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
        debugPrint("collectionViewDidEndMultipleSelectionInteraction")
    }

    /// 长按后上下文菜单
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        L.d("contextMenuConfigurationForItemAt:\(indexPath):\(point)")
        return nil
    }

    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        fatalError("collectionView(_:previewForHighlightingContextMenuWithConfiguration:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        fatalError("collectionView(_:previewForDismissingContextMenuWithConfiguration:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        L.d("willPerformPreviewActionForMenuWith")
    }

    func collectionView(_ collectionView: UICollectionView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        L.d("willDisplayContextMenu")
    }

    func collectionView(_ collectionView: UICollectionView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        L.d("willEndContextMenuInteraction")
    }

    // MARK: UIScrollView代理

    /// 回调
    var onScrollViewDidScroll: ScrollAction? = nil
    var onScrollViewDidScrollList: [ScrollAction] = []

    /// 内容已经滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        L.v("scrollViewDidScroll:\(scrollView.contentOffset):\(scrollView.contentSize):\(scrollView.contentInset)")

        if scrollView.contentOffset.y < 0 {
            //手指向下滑动
        } else {
            //手指向上滑动
        }

        onScrollViewDidScrollList.forEach {
            $0(scrollView)
        }
        onScrollViewDidScroll?(scrollView)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        debugPrint("scrollViewDidZoom:\(scrollView.zoomScale)")
    }

    /// 即将开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        debugPrint("scrollViewWillBeginDragging")
    }

    /// 最后一次拖拽时的速率
    var lastVelocity: CGPoint = .zero

    /// 即将结束拖拽
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        debugPrint("scrollViewWillEndDragging:\(velocity):\(targetContentOffset.pointee)")
        lastVelocity = velocity
        if velocity.y < 0 {
            //往下快速滑动
        } else {
            //往上快速滑动
        }
    }

    var onScrollViewDidEndDragging: ScrollAction? = nil

    /// 结束拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        debugPrint("scrollViewDidEndDragging:\(decelerate)")
        onScrollViewDidEndDragging?(scrollView)
        if !decelerate {
            onScrollViewDidEndScroll?(scrollView)
            onScrollViewDidEndScrollList.forEach {
                $0(scrollView)
            }
        }
    }

    /// 即将开始减速滚动
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        debugPrint("scrollViewWillBeginDecelerating:\(scrollView.contentOffset):\(scrollView.contentSize):\(scrollView.contentInset):\(scrollView.adjustedContentInset)")
    }

    /// 回调
    var onScrollViewDidEndDecelerating: ScrollAction? = nil

    /// 结束滚动回调
    var onScrollViewDidEndScroll: ScrollAction? = nil
    var onScrollViewDidEndScrollList: [ScrollAction] = []

    /// 结束减速滚动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //(0.0, -88.0):(375.0, 199.0):UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0):UIEdgeInsets(top: 88.0, left: 0.0, bottom: 34.0, right: 0.0)
        debugPrint("scrollViewDidEndDecelerating:\(scrollView.contentOffset):\(scrollView.contentSize):\(scrollView.contentInset):\(scrollView.adjustedContentInset)")
        onScrollViewDidEndDecelerating?(scrollView)
        onScrollViewDidEndScroll?(scrollView)
        onScrollViewDidEndScrollList.forEach {
            $0(scrollView)
        }
    }

    /// 滚动动画结束
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        debugPrint("scrollViewDidEndScrollingAnimation")
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //这里调用 scrollView.zoomScale 会死循环
        debugPrint("viewForZooming:\(scrollView.minimumZoomScale):\(scrollView.maximumZoomScale)")
        return nil
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        debugPrint("scrollViewWillBeginZooming")
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        debugPrint("scrollViewDidEndZooming:\(view):\(scale)")
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        fatalError("scrollViewShouldScrollToTop(_:) has not been implemented")
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        debugPrint("scrollViewDidScrollToTop")
    }

    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        debugPrint("scrollViewDidChangeAdjustedContentInset:\(scrollView.contentInset):\(scrollView.adjustedContentInset)")
    }

    //MARK:Touch

    /// 手势应该开始
    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        super.touchesShouldBegin(touches, with: event, in: view)
    }

    /// 手势应该取消
    override func touchesShouldCancel(in view: UIView) -> Bool {
        super.touchesShouldCancel(in: view)
    }

    /// 手势开始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }

    ///
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }

    /// 手势结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }

    /// 手势取消
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }

    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        super.touchesEstimatedPropertiesUpdated(touches)
    }
}

///MARK: diff 数据源
class DslCollectionViewDiffableDataSource: UICollectionViewDiffableDataSource<DslSection, DslItem> {

    var dslCollectionView: DslCollectionView

    init(_ collectionView: DslCollectionView) {
        dslCollectionView = collectionView
        super.init(collectionView: collectionView) { view, path, item in
            debugPrint("获取Cell:\(path)")
            return collectionView.createCollectionViewCell(collectionView, cellForRowAt: path, item: item)
        }
    }

    /// 获取section的数量
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        super.numberOfSections(in: collectionView)
    }

    /// 获取section中items的数量
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        super.collectionView(collectionView, numberOfItemsInSection: section)
    }

    /// 获取对应的cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        super.collectionView(collectionView, cellForItemAt: indexPath)
    }

    /// 返回补充视图 https://www.jianshu.com/p/4863a25d3b84
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        L.d("viewForSupplementaryElementOfKind:\(kind):\(indexPath):\(view)")
        return view
    }

    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        //super.collectionView(collectionView, canMoveItemAt: indexPath)
        L.d("canMoveItemAt:\(indexPath)")
        return dslCollectionView.getCollectionItem(indexPath)?.itemCanMove ?? false
    }

    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        super.collectionView(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }

    override func indexTitles(for collectionView: UICollectionView) -> [String]? {
        super.indexTitles(for: collectionView)
    }

    override func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        super.collectionView(collectionView, indexPathForIndexTitle: title, at: index)
    }
}
