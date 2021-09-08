//
// Created by angcyo on 21/08/09.
//

import Foundation
import UIKit

class DslCollectionView: UICollectionView, DslRecycleView, UICollectionViewDelegateFlowLayout {

    /// 所有的数据集合, 但非全部在界面上显示
    var _itemList: [DslItem] = []

    lazy var diffableDataSource: DslCollectionViewDiffableDataSource = {
        DslCollectionViewDiffableDataSource(self)
    }()

    lazy var sectionHelper: SectionHelper = {
        SectionHelper()
    }()

    lazy var statusItem: IStatusItem? = nil

    lazy var loadMoreItem: IStatusItem? = nil

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
        dataSource = diffableDataSource
        delegate = self

        bounces = true //边界回弹
        minimumZoomScale = 1
        maximumZoomScale = 1
        bouncesZoom = true //当达到最大限制时, 是否开启zoom

        //automaticallyAdjustsScrollIndicatorInsets
        contentInsetAdjustmentBehavior = .automatic //安全区域的行为
        //adjustedContentInset

        //边界回弹
        alwaysBounceVertical = true
        alwaysBounceHorizontal = false

        //selection
        allowsSelection = true //允许选择
        allowsMultipleSelection = false //多行选择

        if #available(iOS 14.0, *) {
            //编辑模式下是否允许选择
            allowsSelectionDuringEditing = false
            allowsMultipleSelectionDuringEditing = false
        }

        //collectionViewLayout
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
    var needsReload = true {
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
            self.loadData(_itemList)
        }
    }

    // MARK: 代理 UICollectionViewDelegateFlowLayout

    /// 指定单元格的大小, 默认是50,50
    func collectionView(_ view: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 默认的大小
        let defSize = (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? cgSize(Res.size.itemMinHeight)
        if let item = getCollectionItem(indexPath) {

            //宽度计算
            var width: CGFloat
            if item.itemWidth == UITableView.automaticDimension {
                //自动设置宽度
                if let span = item.itemSpan ?? spanCount {
                    var maxWidth = view.width - view.contentInset.left - view.contentInset.right
                    if span > 1 {
                        maxWidth = maxWidth - collectionView(view, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section) * (span.toCGFloat() - 1)
                    }

                    if span > 0 {
                        width = floorf((maxWidth / span.toCGFloat()).toFloat()).toCGFloat()
                    } else {
                        width = maxWidth
                    }
                } else {
                    width = DslItem.automaticSize
                }
            } else {
                width = item.itemWidth
            }

            //高度计算
            var height: CGFloat
            if item.itemHeight == UITableView.automaticDimension {
                //自动设置宽度, 请在[DslCollectionCell]的[preferredLayoutAttributesFitting]中设置
                height = DslItem.automaticSize//UITableView.automaticDimension
            } else {
                height = item.itemHeight
            }

            //返回
            return cgSize(width, height)
        }
        return defSize
        //return cgSize(200, 200)
    }

    /// section 的边界, 默认是0,0,0,0
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? UIEdgeInsets.zero
        return getSectionFirstCollectionItem(section)?.itemSectionEdgeInset ?? inset
    }

    /// section 中item的行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        L.d("minimumLineSpacingForSectionAt:\(section)")
        return getSectionFirstCollectionItem(section)?.itemSectionLineSpacing ?? /*flowLayout?.minimumLineSpacing ??*/ minimumLineSpacing
    }

    /// section 中item的列间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        L.d("minimumInteritemSpacingForSectionAt:\(section)")
        return getSectionFirstCollectionItem(section)?.itemSectionInteritemSpacing ?? /*flowLayout?.minimumInteritemSpacing ??*/ minimumInteritemSpacing
    }

    /// 标题视图的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        L.d("referenceSizeForHeaderInSection:\(section)")
        return .zero
    }

    /// 页脚视图的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        L.d("referenceSizeForFooterInSection:\(section)")
        return .zero
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
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
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
        fatalError("collectionView(_:targetContentOffsetForProposedContentOffset:) has not been implemented")
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
