//
// Created by angcyo on 21/09/06.
//

import Foundation

///# https://github.com/nvzqz/FileKit
///pod 'FileKit', '~> 5.0.0'

/*

//Path("/var/mobile/Containers/Data/Application/D1D29368-F11B-47D0-98E3-584D8363617B")
//let p = Path.userHome
NSHomeDirectory()

// Path.current = Path("/")

//Path("/var/mobile/Containers/Data/Application/D1D29368-F11B-47D0-98E3-584D8363617B/Library/Caches")
//Path.userCaches

//0 values
let fileManager = FileManager.default
let u1 = fileManager.urls(for: .userDirectory, in: .userDomainMask)
NSHomeDirectory()

//"file:///var/mobile/Containers/Data/Application/D1D29368-F11B-47D0-98E3-584D8363617B/Desktop/"
let u2 = fileManager.urls(for: .desktopDirectory, in: .userDomainMask)

//"file:///var/mobile/Containers/Data/Application/D1D29368-F11B-47D0-98E3-584D8363617B/Library/"
let u3 = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)

//"file:///var/mobile/Containers/Data/Application/D1D29368-F11B-47D0-98E3-584D8363617B/Documents/"
let u4 = fileManager.urls(for: .documentDirectory, in: .userDomainMask)

//"file:///var/mobile/Containers/Data/Application/D1D29368-F11B-47D0-98E3-584D8363617B/Downloads/"
let u5 = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask)

//"file:///var/mobile/Containers/Data/Application/D1D29368-F11B-47D0-98E3-584D8363617B/Library/Caches/"
let u6 = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)

//"file:///var/mobile/Containers/Data/Application/C93A28DF-B35F-47B3-8F96-2CA01F4EBEAE/Applications/"
fileManager.urls(for: .applicationDirectory, in: .userDomainMask)

//"file:///var/mobile/Containers/Data/Application/C93A28DF-B35F-47B3-8F96-2CA01F4EBEAE/Library/Application%20Support/"
fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)

"file:///var/mobile/Containers/Data/Application/C93A28DF-B35F-47B3-8F96-2CA01F4EBEAE/Desktop/"

"file:///var/mobile/Containers/Data/Application/C93A28DF-B35F-47B3-8F96-2CA01F4EBEAE/Music/"
 */

extension String {

    /// 扩展名
    var pathExtension: String {
        (self as NSString).pathExtension
    }

    /// 最后一段路径
    var lastPathComponent: String {
        (self as NSString).lastPathComponent
    }

    /// 删除最后一段路径
    var deletingLastPathComponent: String {
        (self as NSString).deletingLastPathComponent
    }

    var expandingTildeInPath: String {
        (self as NSString).expandingTildeInPath
    }

    func appendingPathComponent(_ str: String?) -> String {
        if nilOrEmpty(str) {
            return self
        }

        let str = str!

        let endsWith = hasSuffix("/")
        let beginsWith = str.hasPrefix("/")
        if !endsWith && !beginsWith {
            return self + "/" + str
        } else if (endsWith && !beginsWith) || (beginsWith && !endsWith) {
            return self + str
        }

        return self[..<self.index(before: endIndex)] + str
    }

    /// 转换成路径
    func toPath(_ parent: Path? = nil) -> Path {
        if let parent = parent {
            return parent + self
        }
        return Path(self)
    }

    //.userCaches + "/http
    @discardableResult
    func writeToFile(folder: String, name: String, append: Bool = true) -> Bool {
        saveToFile(path: Path(folder), name: name, append: append)
    }

    /// 将字符串保存到到文本
    ///
    /// - Parameters:
    ///   - path: 路径
    ///   - name: 文件名
    /// - Returns: 是否成功
    @discardableResult
    func saveToFile(path: Path? = nil, name: String, append: Bool = true) -> Bool {
        var result = false

        // 创建目录
        let folder = (path ?? Path.userCaches)
        let path = folder + name

        do {
            //path.filePermissions

            try folder.createDirectory()

            if append {
                try self |>> TextFile(path: path)
            } else {
                try self |> TextFile(path: path)
            }
            result = true
            return result
        } catch let e {
            L.w("写入文件失败:\(path):\(e)")
            return result
        }
    }
}

func timeFileName(_ pattern: String = "yyyy-MM-dd_HH:mm:ss:SSS", suffix: String = ".log") -> String {
    Date().format(pattern) + suffix
}