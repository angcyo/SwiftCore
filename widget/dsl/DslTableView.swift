//
// Created by wayto on 2021/8/2.
//

import Foundation
import UIKit

class DslTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    var itemArray: [DslItem] = []

    override init(frame: CGRect, style: Style = .plain) {
        super.init(frame: frame, style: style)
        initTableView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func initTableView() {

        estimatedSectionHeaderHeight = UITableView.automaticDimension
        sectionHeaderHeight = UITableView.automaticDimension

        estimatedRowHeight = UITableView.automaticDimension
        rowHeight = UITableView.automaticDimension

        estimatedSectionFooterHeight = UITableView.automaticDimension
        sectionFooterHeight = UITableView.automaticDimension

        tableHeaderView = nil
        tableFooterView = nil

        bounces = true //边界回弹
        minimumZoomScale = 1
        maximumZoomScale = 1
        bouncesZoom = true //当达到最大限制时, 是否开启zoom

        contentInsetAdjustmentBehavior = .never //安全区域的行为

        //分割线
        separatorStyle = .none //取消分割线
        //separatorColor = UIColor.gray
        //separatorEffect = .none
        //separatorInset = .zero

        //编辑模式
        //isEditing = true

        isUserInteractionEnabled = true

        //selection
        allowsSelection = true //允许选择
        allowsSelectionDuringEditing = false //编辑模式下是否允许选择
        allowsMultipleSelection = false //多行选择
        allowsMultipleSelectionDuringEditing = false

        delegate = self
        dataSource = self
    }

    // MARK: item操作

    func setItems(_ items: [DslItem]) {
        items.forEach { (item: DslItem) in
            if let itemCell = item.itemCell {
                let identifier = item.identifier
                self.register(itemCell, forCellReuseIdentifier: identifier)
            }
        }
        itemArray = items
        reloadData()
    }

    @discardableResult
    func addItem(_ item: DslItem, _ dsl: ((DslItem) -> Void)? = nil) -> DslItem {
        if let itemCell = item.itemCell {
            let identifier = item.identifier
            self.register(itemCell, forCellReuseIdentifier: identifier)
        }
        itemArray.append(item)
        //init
        dsl?(item)
        insertRows(at: [IndexPath(row: itemArray.count - 1, section: 0)], with: .automatic)
        return item
    }

    /// 删除item
    @discardableResult
    func removeItem(_ item: DslItem) -> DslItem? {
        let index = itemArray.firstIndex {
            $0 == item
        }
        if let index = index {
            itemArray.remove(at: index)
            deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            return item
        }
        return nil
    }

    // MARK: 操作符重载

    @discardableResult
    static func +(tableView: DslTableView, item: DslItem) -> DslItem {
        tableView.addItem(item)
        return item
    }

    // MARK: dataSource代理

    /// section 中的数据行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    /// 获取cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let identifier = item.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let tableCell = cell as! DslTableCell
        tableCell.onBindCell(self, indexPath, item)
        return tableCell
    }

    /// section 的数量
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /// section 的头部标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SectionHeader:\(section)"
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "SectionFooter:\(section)"
    }

    /// 是否可以编辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        debugPrint("canEditRowAt:\(indexPath)")
        return false
    }

    /// 是否可以移动
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        debugPrint("canMoveRowAt:\(indexPath)")
        return true
    }

    /// titles
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        debugPrint("sectionIndexTitles")
        return nil
    }

    /// 根据title 获取 索引
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        debugPrint("sectionForSectionIndexTitle:\(title):\(index)")
        return index
    }

    /// 点击了侧滑按钮
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        debugPrint("commit editingStyle:\(editingStyle.rawValue):\(indexPath)")
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        debugPrint("moveRowAt:\(sourceIndexPath) to:\(destinationIndexPath)")
    }

    // MARK: cell header footer 显示和隐藏

    /// cell 即将显示
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        debugPrint("cell即将显示:\(indexPath):\(cell)")
    }

    /// cell即将不可见
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        debugPrint("cell即将不可见:\(indexPath):\(cell)")
    }

    /// 头部试图即将显示
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        debugPrint("头部试图即将显示:\(section):\(view)")
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        debugPrint("头部试图即将不可见:\(section):\(view)")
    }

    /// 尾部试图即将显示
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        debugPrint("尾部试图即将显示:\(section):\(view)")
    }

    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        debugPrint("尾部试图即将不可见:\(section):\(view)")
    }

    // MARK: 高度计算

    /// 指定行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    /// 预估的行高
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    /// 头部的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    /// 尾部的高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    // MARK: 首尾试图获取

    /// 返回头部试图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    /// 返回尾部试图
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    /// 需要cell的样式为:accessoryType = .detailButton 或 .detailDisclosureButton
    /// 点击排序按钮的时候, 也会触发
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        debugPrint("点击详情按钮:\(indexPath)")
    }

    // MARK: 突出和选中

    /// 是否突出显示行
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        debugPrint("已突出:\(indexPath)")
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        debugPrint("已不突出:\(indexPath)")
    }

    /// 将要选中行
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        debugPrint("即将选中:\(indexPath)")
        return indexPath
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        debugPrint("即将取消选中:\(indexPath)")
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("选中:\(indexPath)")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        debugPrint("取消选中:\(indexPath)")
    }

    // MARK: 编辑和菜单

    /// 编辑模式下得编辑样式
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        debugPrint("editingStyleForRowAt:\(indexPath)")
        return .delete
    }

    /// 侧滑删除按钮的文本
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除:\(indexPath)"
    }

    /// 侧滑菜单
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        debugPrint("editActionsForRowAt:\(indexPath)")
        return nil
    }

    /// 左边侧滑配置
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        debugPrint("leadingSwipeActionsConfigurationForRowAt:\(indexPath)")
        return nil
    }

    /// 右边侧滑配置
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        debugPrint("trailingSwipeActionsConfigurationForRowAt:\(indexPath)")
        return nil
    }

    /// 编辑模式时, 是否缩进行
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        debugPrint("shouldIndentWhileEditingRowAt:\(indexPath)")
        return true
    }

    /// 缩进级别量
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        debugPrint("缩进:indentationLevelForRowAt:\(indexPath)")
        return 0
    }

    /// 即将进入编辑模式
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        debugPrint("即将进入编辑模式:\(indexPath)")
    }

    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        debugPrint("已退出编辑模式:\(indexPath)")
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        debugPrint("移动从:\(sourceIndexPath) 到:\(proposedDestinationIndexPath)")
        return proposedDestinationIndexPath
    }

    /// 是否显示菜单
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        debugPrint("是否显示菜单:\(indexPath)")
        return false
    }

    /// 是否要有指定的菜单
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    /// 距离的菜单操作
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        debugPrint("菜单操作:\(indexPath) :\(action)")
    }

    /// 是否有焦点
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        debugPrint("是否有焦点:\(indexPath)")
        return true
    }

    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        debugPrint("是否更新焦点:\(context)")
        return true
    }

    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        debugPrint("焦点已更新:\(context)")
    }

    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        debugPrint("获取焦点位置")
        return nil
    }

    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        debugPrint("shouldSpringLoadRowAt:\(indexPath)")
        return true
    }

    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        debugPrint("是否多选:\(indexPath)")
        return false
    }

    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        debugPrint("多选:\(indexPath)")
    }

    func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        debugPrint("结束多选")
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        debugPrint("请求菜单配置:\(indexPath):\(point)")
        return nil
    }

    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        fatalError("tableView(_:previewForHighlightingContextMenuWithConfiguration:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        fatalError("tableView(_:previewForDismissingContextMenuWithConfiguration:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        debugPrint("willPerformPreviewActionForMenuWith")
    }

    func tableView(_ tableView: UITableView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        debugPrint("willDisplayContextMenu")

    }

    func tableView(_ tableView: UITableView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        debugPrint("willEndContextMenuInteraction")
    }

    // MARK: UIScrollView代理

    /// 内容已经滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //debugPrint("scrollViewDidScroll:\(scrollView.contentOffset)")
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        debugPrint("scrollViewDidZoom:\(scrollView.zoomScale)")
    }

    /// 即将开始滚动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        debugPrint("scrollViewWillBeginDragging")
    }

    /// 即将结束滚动
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        debugPrint("scrollViewWillEndDragging")
    }

    /// 结束滚动
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        debugPrint("scrollViewDidEndDragging")
    }

    /// 即将开始减速滚动
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        debugPrint("scrollViewWillBeginDecelerating")
    }

    /// 技术减速滚动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        debugPrint("scrollViewDidEndDecelerating:\(scrollView.contentOffset):\(scrollView.contentSize):\(scrollView.contentInset):\(scrollView.adjustedContentInset)")
    }

    /// 滚动动画结束
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        debugPrint("scrollViewDidEndScrollingAnimation")
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        debugPrint("viewForZooming:\(scrollView.zoomScale):\(scrollView.minimumZoomScale):\(scrollView.maximumZoomScale)")
        return nil
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        debugPrint("scrollViewWillBeginZooming")
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        debugPrint("scrollViewDidEndZooming")
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
}
