//
// Created by angcyo on 21/09/08.
// https://www.jianshu.com/p/5474d02f9112
// https://www.jianshu.com/p/4863a25d3b84

import Foundation
import UIKit

class CustomLayout: UICollectionViewLayout {

    // 内容区域总大小，不是可见区域
    override var collectionViewContentSize: CGSize {
        // 宽度就是屏幕宽度减去左右边距
        let width = collectionView!.bounds.size.width - collectionView!.contentInset.left
                - collectionView!.contentInset.right
        // 一行三个，一个大的两个小的，
        let height = CGFloat((collectionView!.numberOfItems(inSection: 0) + 1) / 3)
                * (width / 3 * 2)
        return CGSize(width: width, height: height)
    }

    // 所有单元格位置属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 创建属性数组
        var attributesArray = [UICollectionViewLayoutAttributes]()
        // 获取单元格个数
        let itemCount = self.collectionView!.numberOfItems(inSection: 0)
        // 循环创建单元格的属性
        for i in 0..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            let layoutAttributes = self.layoutAttributesForItem(at: indexPath)
            attributesArray.append(layoutAttributes!)
        }
        return attributesArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // 获取当前的布局属性
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        // 单元格边长
        let largeCellSide = collectionViewContentSize.width / 3 * 2
        let smallCellSide = collectionViewContentSize.width / 3

        // 当前行数,每行显示3个图片，1大2小
        let line: Int = indexPath.item / 3
        // 当前y坐标的值
        let lineOriginY = CGFloat(line) * largeCellSide

        //右侧单元格X坐标，这里按左右对齐，所以中间空隙大
        // 大单元格在左
        let rightLargeX = collectionViewContentSize.width - largeCellSide
        // 大单元格在右
        let rightSmallX = collectionViewContentSize.width - smallCellSide

        // 每行2个图片，2行循环一次，一共6种位置
        if (indexPath.item % 6 == 0) {
            attribute.frame = CGRect(x: 0, y: lineOriginY, width: largeCellSide,
                    height: largeCellSide)
        } else if (indexPath.item % 6 == 1) {
            attribute.frame = CGRect(x: rightSmallX, y: lineOriginY, width: smallCellSide,
                    height: smallCellSide)
        } else if (indexPath.item % 6 == 2) {
            attribute.frame = CGRect(x: rightSmallX,
                    y: lineOriginY + smallCellSide,
                    width: smallCellSide, height: smallCellSide)
        } else if (indexPath.item % 6 == 3) {
            attribute.frame = CGRect(x: 0, y: lineOriginY, width: smallCellSide,
                    height: smallCellSide)
        } else if (indexPath.item % 6 == 4) {
            attribute.frame = CGRect(x: 0,
                    y: lineOriginY + smallCellSide,
                    width: smallCellSide, height: smallCellSide)
        } else if (indexPath.item % 6 == 5) {
            attribute.frame = CGRect(x: rightLargeX, y: lineOriginY,
                    width: largeCellSide,
                    height: largeCellSide)
        }

        return attribute

    }

}

/*
     //如果有页眉、页脚或者背景，可以用下面的方法实现更多效果
     func layoutAttributesForSupplementaryViewOfKind(elementKind: String!,
     atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
     func layoutAttributesForDecorationViewOfKind(elementKind: String!,
     atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
     */