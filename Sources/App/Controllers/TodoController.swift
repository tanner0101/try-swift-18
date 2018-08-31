import Vapor

extension Future where T == Todo {
    func makeOutgoing(with req: Request) -> Future<ReturnTodo> {
        return map { todo in
            return try todo.makeResponse(with: req)
        }
    }
}

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {

    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[ReturnTodo]> {
        return Todo.query(on: req).all().map { try $0.map { try $0.makeResponse(with: req)} }
    }

    func view(_ req: Request) throws -> Future<ReturnTodo> {
        return try req.parameters.next(Todo.self).map { try $0.makeResponse(with: req) }
    }

    func update(_ req: Request) throws -> Future<ReturnTodo> {
        let todo = try req.parameters.next(Todo.self)
        let incoming = try req.content.decode(IncomingTodo.self)
        return flatMap(to: ReturnTodo.self, todo, incoming) { todo, incoming in
            todo.patch(with: incoming)
            return todo.save(on: req).makeOutgoing(with: req)
        }
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<ReturnTodo> {
        return try req.content.decode(IncomingTodo.self).flatMap { todo in
            return todo.makeTodo().save(on: req).makeOutgoing(with: req)
        }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
    
    func clear(_ req: Request) throws -> Future<HTTPStatus> {
        return Todo.query(on: req).delete()
            .transform(to: .ok)
    }
}
