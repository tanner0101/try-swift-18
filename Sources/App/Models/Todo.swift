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

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Todo: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Todo: Parameter { }
