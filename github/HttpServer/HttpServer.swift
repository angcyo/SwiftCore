//
// Created by angcyo on 21/09/13.
//

import Foundation
import HttpSwift
import SocketSwift


///# 本地server https://github.com/BiAtoms/Http.swift
///pod 'Http.swift', '~> 2.2.0' #2.2.1

class HttpServer {

    /// 启动本地文件浏览服务
    static func startFileServer(_ root: String = Core.HOME, config: ((HttpServer) -> Void)? = nil) -> HttpServer {
        let server = HttpServer()

        //server.server.fileBrowser(in: Core.HOME)
        func handleFileBrowser(_ request: Request) throws -> Response {
            L.i("访问:\(request.fullPath)")
            let path = request.path.decodeUrl()!

            if path == "/favicon.ico" {
                let response = Response(.ok,
                        body: R.image.launchLogo()?.toSize(cgSize(32))?.toData()?.toBytes() ?? [],
                        headers: ["Content-Type": "image/png"])
                return response
            } else {
                let atPath = root.expandingTildeInPath.appendingPathComponent(path)

                let response: Response
                if let contents = FileManager.default.listNamesSort(atPath: atPath) {
                    response = StaticServer.renderBrowser(for: path, content: contents)
                } else {
                    response = try StaticServer.serveFile(at: atPath)
                    response.headers.add(["Content-Type": "text/html;charset=utf-8"])
                }
                //response.headers.add(["device": DslDeviceTableItem.deviceInfo()])
                return response
            }
        }

        server.server.get("/") { //"/favicon.ico"
            try handleFileBrowser($0)
        }
        server.server.get("{path}") { //"/favicon.ico"
            try handleFileBrowser($0)
        }
        config?(server)
        server.start()
        return server
    }

    let server = Server()

    ///监听的端口
    var port: UInt16 = 9200
    var address: String? = nil
    ///证书
    var certifiatePath: Server.CertificatePath? = nil

    /// 启动服务
    func start() {
        do {
            try server.run(port: port, address: address, certifiatePath: certifiatePath)
            L.i("服务启动: \(_serverAddress())")
        } catch {
            port += 1
            start()
        }
    }

    func stop() {
        server.stop()
    }

    func _serverAddress() -> String {
        if let _ = certifiatePath {
            return "https://\(address ?? getWiFiAddress() ?? "localhost"):\(port)"
        } else {
            return "http://\(address ?? getWiFiAddress() ?? "localhost"):\(port)"
        }
    }

    deinit {
        server.stop()
    }

}

