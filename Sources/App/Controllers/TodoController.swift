import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {

    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[ReturnTodo]> {
        return Todo.query(on: req).all().map { try $0.map { try $0.makeResponse(with: req)} }
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<ReturnTodo> {
        struct CreateTodo: Content {
            var title: String?
            var completed: Bool?
            var order: Int?

            func makeTodo() -> Todo {
                return Todo(title: title, completed: completed ?? false, order: order)
            }
        }


        return try req.content.decode(CreateTodo.self).flatMap { todo in
            return todo.makeTodo().save(on: req).map { todo in
                return try todo.makeResponse(with: req)
            }
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
