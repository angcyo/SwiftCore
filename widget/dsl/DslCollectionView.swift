//
// Created by angcyo on 21/08/09.
//

import Foundation
import UIKit

class DslCollectionView: UICollectionView, DslRecycleView, UICollectionViewDelegate {

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

    convenience init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize
        //layout.estimatedItemSize
        layout.scrollDirection = .vertical
        //layout.sectionInset
        self.init(frame: frame, collectionViewLayout: layout)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func initCollectionView() {
        dataSource = diffableDataSource
        delegate = self

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

    // MARK: 代理 UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        fatalError("collectionView(_:shouldHighlightItemAt:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        fatalError("collectionView(_:shouldSelectItemAt:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        fatalError("collectionView(_:shouldDeselectItemAt:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
    }

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

    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        fatalError("collectionView(_:canEditItemAt:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        fatalError("collectionView(_:shouldSpringLoadItemAt:with:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        fatalError("collectionView(_:shouldBeginMultipleSelectionInteractionAt:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
    }

    func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
        debugPrint("collectionViewDidEndMultipleSelectionInteraction")
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        fatalError("collectionView(_:contextMenuConfigurationForItemAt:point:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        fatalError("collectionView(_:previewForHighlightingContextMenuWithConfiguration:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        fatalError("collectionView(_:previewForDismissingContextMenuWithConfiguration:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
    }

    func collectionView(_ collectionView: UICollectionView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
    }

    func collectionView(_ collectionView: UICollectionView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
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

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        super.collectionView(collectionView, canMoveItemAt: indexPath)
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