import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {

    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo.Outgoing]> {
        return Todo.query(on: req).all().map { todos in
            try todos.map { todo in
                try todo.makeOutgoing(with: req)
            }
        }
    }

    /// Returns a specific todo
    func view(_ req: Request) throws -> Future<Todo.Outgoing> {
        return try req.parameters.next(Todo.self).makeOutgoing(with: req)
    }

    /// Updates a TODO
    func update(_ req: Request) throws -> Future<Todo.Outgoing> {
        let todo = try req.parameters.next(Todo.self)
        let incoming = try req.content.decode(Todo.Incoming.self)
        return flatMap(to: Todo.Outgoing.self, todo, incoming) { todo, incoming in
            todo.patch(with: incoming)
            return todo.save(on: req).makeOutgoing(with: req)
        }
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo.Outgoing> {
        return try req.content.decode(Todo.Incoming.self).flatMap { todo in
            return todo.makeTodo().save(on: req).makeOutgoing(with: req)
        }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }

    /// Delete all TODOs
    func clear(_ req: Request) throws -> Future<HTTPStatus> {
        return Todo.query(on: req).delete()
            .transform(to: .ok)
    }
}
