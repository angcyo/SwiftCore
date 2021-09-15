//
// Created by wayto on 2021/8/2.
//

import Foundation
import UIKit

class DslTableView: UITableView, UITableViewDelegate, DslRecycleView/*, UITableViewDataSource*/ {

    lazy var diffableDataSource: DslTableViewDiffableDataSource = {
        DslTableViewDiffableDataSource(self)
    }()

    lazy var recyclerDataSource: DslRecyclerDataSource = {
        DslRecyclerDataSource(self)
    }()

    lazy var sectionHelper: SectionHelper = {
        SectionHelper()
    }()

    lazy var statusItem: IStatusItem? = {
        DslStatusTableItem()
    }()

    lazy var loadMoreItem: IStatusItem? = {
        DslLoadMoreTableItem()
    }()

    override init(frame: CGRect = .zero, style: Style = .plain) {
        super.init(frame: frame, style: style)
        initTableView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func initTableView() {

        // 高度自适应
        estimatedSectionHeaderHeight = UITableView.automaticDimension
        sectionHeaderHeight = UITableView.automaticDimension
        estimatedSectionFooterHeight = UITableView.automaticDimension
        sectionFooterHeight = UITableView.automaticDimension

        estimatedRowHeight = Res.size.itemMinHeight //UITableView.automaticDimension
        rowHeight = UITableView.automaticDimension

        /*if style == .grouped || style == .insetGrouped {
            if tableHeaderView == nil {
                tableHeaderView = emptyView(height: Res.size.leftMargin)
            }
            if tableFooterView == nil {
                tableFooterView = emptyView(height: Res.size.leftMargin)
            }
        } else {
            // 表头, 在 style = insetGrouped 时有效
            tableHeaderView = nil
            // 表尾
            tableFooterView = nil
        }*/

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

        //diffableDataSource.defaultRowAnimation
        delegate = self
        dataSource = diffableDataSource
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

    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        super.cellForRow(at: indexPath)
        //diffableDataSource.tableView(<#T##tableView: UITableView##UIKit.UITableView#>, cellForRowAt: <#T##IndexPath##Foundation.IndexPath#>)
    }

    /// 赋值和初始化
    func createTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, item: DslItem) -> UITableViewCell {
        print("获取Cell:\(indexPath)")
        //赋值
        item._dslRecyclerView = self

        let identifier = item.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        item.bindCell(cell, indexPath)
        item.itemUpdate = false
        return cell
    }

    // MARK: cell header footer 显示和隐藏

    /// cell 即将显示
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //print("cell即将显示:\(indexPath):\(cell):\(cell.layer.cornerRadius)")
        //cell.layer.cornerRadius = 100 // 可以修改 insetGrouped 默认圆角
        getItem(indexPath)?.bindCellWillDisplay(cell, indexPath)
    }

    /// cell即将不可见
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //print("cell即将不可见:\(indexPath):\(cell)")
        getItem(indexPath)?.bindCellDidEndDisplaying(cell, indexPath)
    }

    /// 头部试图即将显示
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        print("头部试图即将显示:\(section):\(view)")
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        print("头部试图即将不可见:\(section):\(view)")
    }

    /// 尾部试图即将显示
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        print("尾部试图即将显示:\(section):\(view)")
    }

    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        print("尾部试图即将不可见:\(section):\(view)")
    }

    // MARK: 高度计算

    /// 指定行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        print("heightForRowAt:\(indexPath)")
        return getTableItem(indexPath)?.itemHeight ?? UITableView.automaticDimension
    }

    /// 预估的行高
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 50
        print("estimatedHeightForRowAt:\(indexPath)")
        return getTableItem(indexPath)?.itemEstimatedHeight ?? Res.size.itemMinHeight
    }

    /// 头部的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return UITableView.automaticDimension
        print("heightForHeaderInSection:\(section)")
        return getSectionFirstTableItem(section)?.itemHeaderHeight ?? UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        //return UITableView.automaticDimension
        print("estimatedHeightForHeaderInSection:\(section)")

        if let height = getSectionFirstTableItem(section)?.itemHeaderEstimatedHeight {
            return height
        }

        if style == .plain {
            //这里要用auto, 用0.001还是有高度.
            return UITableView.automaticDimension //Res.size.estimatedHeight
        } else {
            //这里可以用0.001
            return Res.size.leftMargin
        }
        //return UITableView.automaticDimension
    }

    /// 尾部的高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //return UITableView.automaticDimension
        print("heightForFooterInSection:\(section)")
        return getSectionFirstTableItem(section)?.itemFooterHeight ?? UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        //return UITableView.automaticDimension
        print("estimatedHeightForFooterInSection:\(section)")

        if let height = getSectionFirstTableItem(section)?.itemFooterEstimatedHeight {
            return height
        }

        if style == .plain {
            //这里要用auto, 用0.001还是有高度.
            return UITableView.automaticDimension //Res.size.estimatedHeight
        } else {
            //这里可以用0.001
            if section == numberOfSections - 1 {
                // 最后一个 section, 才设置高度
                return Res.size.leftMargin
            } else {
                return Res.size.estimatedHeight
            }
        }
        //return //Res.size.estimatedHeight //UITableView.automaticDimension
    }

    // MARK: 首尾试图获取

    /// 返回头部试图, 这里只需要返回视图即可, fame会被自动设置
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("viewForHeaderInSection:\(section)")
        return getSectionFirstTableItem(section)?.itemHeaderView ?? UIView()
    }

    /// 返回尾部试图
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        print("viewForFooterInSection:\(section)")
        return getSectionFirstTableItem(section)?.itemFooterView ?? UIView()
    }

    /// 需要cell的样式为:accessoryType = .detailButton 或 .detailDisclosureButton
    /// 点击排序按钮的时候, 也会触发
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("点击详情按钮:\(indexPath)")
    }

    // MARK: 突出和选中

    /// 是否突出显示行, 只有返回true, didSelectRowAt 才有机会触发
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        getTableItem(indexPath)?.itemCanHighlight ?? false
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("突出显示:\(indexPath)")
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        print("取消突出:\(indexPath)")
    }

    /// 将要选中行
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("即将选中:\(indexPath)")
        if getTableItem(indexPath)?.itemCanSelect ?? false {
            return indexPath
        }
        return nil
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        print("即将取消选中:\(indexPath)")
        if getTableItem(indexPath)?.itemCanDeselect ?? false {
            return indexPath
        }
        return nil
    }

    /// 选中的cell索引集合
    var selectList: [IndexPath] = []

    /// 自动取消选择, 默认为true
    var autoCancelSelect = true

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("选中:\(indexPath)")
        selectList.append(indexPath)

        if autoCancelSelect {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("取消选中:\(indexPath)")
        selectList.remove(indexPath)
    }

    /// 取消所有选中的行
    func cancelSelected(_ animation: UITableView.RowAnimation = .automatic) {
        //selectRow(at: <#T##IndexPath?##Foundation.IndexPath?#>, animated: <#T##Bool##Swift.Bool#>, scrollPosition: <#T##UITableView.ScrollPosition##UIKit.UITableView.ScrollPosition#>)
        //deselectRow(at: <#T##IndexPath##Foundation.IndexPath#>, animated: <#T##Bool##Swift.Bool#>)
        if dataSource != nil {
            //deleteRows(at: selectList, with: animation)
            for select in selectList {
                getItemList(true)[select.row].itemUpdate = true
            }
        }
    }

    // MARK: 编辑和菜单

    /// 编辑模式下得编辑样式
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        print("editingStyleForRowAt:\(indexPath)")
        return .delete
    }

    /// 侧滑删除按钮的文本
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除:\(indexPath)"
    }

    /// 侧滑菜单
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("editActionsForRowAt:\(indexPath)")
        return nil
    }

    /// 左边侧滑配置
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("leadingSwipeActionsConfigurationForRowAt:\(indexPath)")
        return nil
    }

    /// 右边侧滑配置
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("trailingSwipeActionsConfigurationForRowAt:\(indexPath)")
        return nil
    }

    /// 编辑模式时, 是否缩进行
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        print("shouldIndentWhileEditingRowAt:\(indexPath)")
        return true
    }

    /// 缩进级别量
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        print("缩进:indentationLevelForRowAt:\(indexPath)")
        return getTableItem(indexPath)?.itemIndentationLevel ?? 0
    }

    /// 即将进入编辑模式
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        print("即将进入编辑模式:\(indexPath)")
    }

    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        print("已退出编辑模式:\(indexPath)")
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        print("移动从:\(sourceIndexPath) 到:\(proposedDestinationIndexPath)")
        return proposedDestinationIndexPath
    }

    /// 是否显示菜单
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        print("是否显示菜单:\(indexPath)")
        return false
    }

    /// 是否要有指定的菜单
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    /// 距离的菜单操作
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        print("菜单操作:\(indexPath) :\(action)")
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
        onScrollViewDidScroll?(self)
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
class DslTableViewDiffableDataSource: UITableViewDiffableDataSource<DslSection, DslItem> {

    var dslTableView: DslTableView

    init(_ tableView: DslTableView) {
        dslTableView = tableView

        //core
        super.init(tableView: tableView) { view, path, item in
            tableView.createTableViewCell(tableView, cellForRowAt: path, item: item)
        }
    }

    //MARK: DslTableViewDiffableDataSource 数据源

    /// 获取section的数量
    override func numberOfSections(in tableView: UITableView) -> Int {
        super.numberOfSections(in: tableView)
    }

    /// 获取section中items的数量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
    }

    /// 获取对应的cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
    }

    /// section 的头部标题
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        L.d("titleForHeaderInSection:\(section)")
        return dslTableView.getSectionFirstTableItem(section)?.itemHeaderTitle
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        L.d("titleForFooterInSection:\(section)")
        return dslTableView.getSectionFirstTableItem(section)?.itemFooterTitle
    }

    /// titles
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        L.d("sectionIndexTitles")
        return nil
    }

    /// 根据title 获取 索引
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        L.d("sectionForSectionIndexTitle:\(title):\(index)")
        return index
    }

    /// 点击了侧滑按钮
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        L.d("commit editingStyle:\(editingStyle.rawValue):\(indexPath)")
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        L.d("moveRowAt:\(sourceIndexPath) to:\(destinationIndexPath)")
    }

    /// 是否可以编辑
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        L.d("canEditRowAt:\(indexPath)")
        return dslTableView.getTableItem(indexPath)?.itemCanEdit ?? false
    }

    /// 是否可以移动
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        L.d("canMoveRowAt:\(indexPath)")
        return dslTableView.getTableItem(indexPath)?.itemCanMove ?? false
    }
}

/*///test
extension DslTableView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        L.d("shouldRecognizeSimultaneouslyWith:\(otherGestureRecognizer)")
        return false
    }
}*/

//MARK: 高度变化的快速方法
func changeFirstCellHeight(_ tableView: UITableView, defaultHeight: CGFloat? = nil) {
    if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
        changeViewHeight(tableView, view: cell, defaultHeight: defaultHeight)
    }
}

fileprivate var KEY_DEFAULT_SCROLLER_BEFORE_HEIGHT = "key_default_scroller_before_height"

// y 小于0, 手指向下滑动
func changeViewHeight(_ scrollView: UIScrollView, view: UIView, defaultHeight: CGFloat? = nil, offsetY: Bool = true) {
    let y = scrollView.contentOffset.y
    if y <= 0 {
        var height: CGFloat
        if defaultHeight == nil {
            if let h = view.getObject(&KEY_DEFAULT_SCROLLER_BEFORE_HEIGHT) as? CGFloat {
                height = h
            } else {
                //未初始化默认高度
                view.setObject(&KEY_DEFAULT_SCROLLER_BEFORE_HEIGHT, view.bounds.height)
                height = view.bounds.height
            }
        } else {
            height = defaultHeight!
        }
        //下拉的时候, 才放大. 上拉不处理
        if offsetY {
            view.frame = CGRect(x: view.frame.origin.x, y: y, width: view.frame.width, height: height - y)
        } else {
            view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: height - y)
        }
    }
}
