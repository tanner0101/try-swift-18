import FluentSQLite
import Vapor

/// A single entry of a Todo list.
struct Todo: SQLiteModel {
    /// The unique identifier for this `Todo`.
    var id: Int?

    /// A title describing what this `Todo` entails.
    var title: String
    var completed: Bool
    var order: Int?
}

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Todo: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Todo: Parameter { }

/// Patch

extension Todo {
    func patched(with incoming: Incoming) -> Todo {
        var copy = self
        copy.title = incoming.title ?? title
        copy.completed = incoming.completed ?? completed
        copy.order = incoming.order ?? order
        return copy
    }
}
