//
// Created by wayto on 2021/7/29.
//

import Foundation
import UIKit

struct D {

    /// 调试索引值
    /// switch D.debugIndex {
    //        case 0: accessoryType = .checkmark
    //        default:
    //            ()
    //        }
    //        D.debugIndex += 1
    static var debugIndex = 0

    static var debug: Bool {
        #if DEBUG // 判断是否在测试环境下
        return true
        #else
        return false
        #endif
    }

    static var isBeingDebugged: Bool {
        // Initialize all the fields so that,
        // if sysctl fails for some bizarre reason, we get a predictable result.
        var info = kinfo_proc()
        // Initialize mib, which tells sysctl the info we want,
        // in this case we're looking for info about a specific process ID.
        var mib = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        // Call sysctl.
        var size = MemoryLayout.stride(ofValue: info)
        let junk = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        // We're being debugged if the P_TRACED flag is set.
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }

    /// 是否调试模式
    static var isDebug: Bool {
        debug || isBeingDebugged
    }

    /// 是否越狱
    static var isJailbroken: Bool {
        jailbreakFileExists
                || sandboxBreached
                || evidenceOfSymbolLinking
    }
}

private var evidenceOfSymbolLinking: Bool {
    var s = stat()
    guard lstat("/Applications", &s) == 0 else {
        return false
    }
    return (s.st_mode & S_IFLNK == S_IFLNK)
}

private var sandboxBreached: Bool {
    guard (try? " ".write(
            toFile: "/private/jailbreak.txt",
            atomically: true, encoding: .utf8)) == nil else {
        return true
    }
    return false
}

private var jailbreakFileExists: Bool {
    let jailbreakFilePaths = [
        "/Applications/Cydia.app",
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/bin/bash",
        "/usr/sbin/sshd",
        "/etc/apt",
        "/private/var/lib/apt/"
    ]
    let fileManager = FileManager.default
    return jailbreakFilePaths.contains { path in
        if fileManager.fileExists(atPath: path) {
            return true
        }
        if let file = fopen(path, "r") {
            fclose(file)
            return true
        }
        return false
    }
}