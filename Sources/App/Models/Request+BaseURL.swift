import Vapor

extension Request {
    var baseUrl: String {
        var host = http.headers["Host"].first!
        if host.hasSuffix("/") {
            host = String(host.dropLast())
        }
        let scheme = http.remotePeer.scheme ?? http.url.scheme ?? "http"
        return "\(scheme)://\(host)/todos/"
    }
}
