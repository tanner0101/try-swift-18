import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class Todo: SQLiteModel {
    /// The unique identifier for this `Todo`.
    var id: Int?

    /// A title describing what this `Todo` entails.
    var title: String?
    var completed: Bool?
    var order: Int?

    init(id: Int? = nil, title: String?, completed: Bool, order: Int?) {
        self.id = id
        self.title = title
        self.completed = completed
        self.order = order
    }
}

struct IncomingTodo: Content {
    var title: String?
    var completed: Bool?
    var order: Int?

    func makeTodo() -> Todo {
        return Todo(title: title, completed: completed ?? false, order: order)
    }
}

extension Todo {
    func patch(with incoming: IncomingTodo) {
        title = incoming.title ?? title
        completed = incoming.completed ?? completed
        order = incoming.order ?? order
    }
}

struct ReturnTodo: Content {
    var id: Int?
    var title: String?
    var completed: Bool?
    var order: Int?
    var url: String
}

extension Todo {
    func makeResponse(with req: Request) throws -> ReturnTodo {
        let idString = id?.description ?? ""
        let url = req.baseUrl + idString
        return ReturnTodo(
            id: id,
            title: title,
            completed: completed,
            order: order,
            url: url
        )
    }
}

extension Request {
    var baseUrl: String {
        var host = http.headers["Host"].first!
        if host.hasSuffix("/") {
            host = String(host.dropLast())
        }
        let scheme = http.url.scheme ?? "http"
        return "\(scheme)://\(host)/todos/"
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Todo: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Todo: Parameter { }
