//
// Created by angcyo on 21/09/10.
//

import Foundation

class FileBrowserTableItem: DslTableItem {

    override func initItem() {
        super.initItem()
        enableSelect()
    }

    override func bindCell(_ cell: DslCell, _ indexPath: IndexPath) {
        super.bindCell(cell, indexPath)

        cell.cellOf(FileBrowserTableCell.self) {
            if let bean = itemData as? FileBrowserBean {
                if bean.isFolder {
                    $0.image.setImage(R.image.icon_type_folder())
                } else {
                    $0.image.setImage(R.image.icon_type_file())
                }
                $0.title.setText(bean.fileName)
                /*if let displayName = bean.displayName {
                    $0.title.setText("\(bean.fileName ?? "")(\(displayName ?? ""))")
                } else {
                    $0.title.setText(bean.fileName)
                }*/

                $0.des.setText(buildString {
                    if bean.isFolder {
                        $0.append(bean.fileSize.toString() + "项")
                    } else {
                        $0.append(bean.fileSize.toCGFloat().toFileSize())
                    }
                    $0.append(" ")

                    $0.append(bean.modificationDate?.format())
                    $0.append(" ")
                    $0.append(bean.ownerAccountName)
                    $0.append(" ")
                    /*$0.append(bean.type)
                    $0.append(" ")*/

                    if !bean.isExists {
                        $0.append("x")
                    }
                    if bean.isReadable {
                        $0.append("r")
                    } else {
                        $0.append("-")
                    }
                    if bean.isWritable {
                        $0.append("w")
                    } else {
                        $0.append("-")
                    }
                    if bean.isExecutable {
                        $0.append("e")
                    } else {
                        $0.append("-")
                    }
                    if bean.isDeletable {
                        $0.append("d")
                    } else {
                        $0.append("-")
                    }
                })
            }
        }
    }
}

class FileBrowserTableCell: DslTableCell {

    let image = scaleImageView()
    let title = subTitleView()
    let des = tipView()

    override func initCell() {
        super.initCell()

        contentView.render(image) {
            $0.makeLeftIn(offsetLeft: Res.size.x, offsetTop: Res.size.x, offsetBottom: Res.size.x)
            $0.makeWidthHeight(size: 30)
        }
        contentView.render(title) {
            $0.makeGravityRight(offset: Res.size.x)
            $0.makeCenterY(self.image, offset: -Res.size.l)
            $0.makeLeftToRightOf(self.image, offset: Res.size.x)
        }
        contentView.render(des) {
            $0.makeLeftToLeftOf(self.title)
            $0.makeGravityRight(offset: Res.size.x)
            $0.makeTopToBottomOf(self.title)
        }
    }
}
