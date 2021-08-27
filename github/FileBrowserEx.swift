//
// Created by angcyo on 21/08/26.
//

import Foundation

/// 文件浏览器 https://github.com/marmelroy/FileBrowser
/// pod 'FileBrowser', '~> 1.0'

/*func showFileBrowser(initialPath: URL? = nil, allowEditing: Bool = false, showCancelButton: Bool = true, onSelect: ((FBFile) -> Void)? = nil) {
    let fileBrowser = FileBrowser(initialPath: initialPath, allowEditing: allowEditing, showCancelButton: showCancelButton)

    //fileBrowser.excludesFileExtensions = ["zip"]
    //fileBrowser.excludesFilepaths = [secretFile]

    fileBrowser.didSelectFile = {
        print("选择文件:", $0)
        onSelect?($0)
    }
    show(fileBrowser)
}*/

/// https://github.com/Augustyniak/FileExplorer
/// pod "FileExplorer", "~> 1.0.4"

//func showFileExplorer() {
//    let fileExplorer = FileExplorerViewController()

    //Only files with `txt` and `jpg` extensions will be visible
    //fileExplorer.fileFilters = [Filter.extension("txt"), Filter.extension("jpg")]

    //Everything but directories will be visible
    //fileExplorer.ignoredFileFilters = [Filter.type(.directory)]

    //fileExplorer.canChooseFiles = true //specify whether user is allowed to choose files
    //fileExplorer.canChooseDirectories = false //specify whether user is allowed to choose directories
    //fileExplorer.allowsMultipleSelection = true //specify whether user is allowed to choose multiple files and/or directories
    //fileExplorer.delegate = self

    //fileExplorer.canRemoveFiles = true //specify whether user is allowed to remove files
    //fileExplorer.canRemoveDirectories = false //specify whether user is allowed to remove directories

    //fileExplorer.fileSpecificationProviders = [CustomFileSpecificationProvider.self]

//    show(fileExplorer)
//}