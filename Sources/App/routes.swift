import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.get("todos", Todo.parameter, use: todoController.view)
    router.post("todos", use: todoController.create)
    router.patch("todos", Todo.parameter, use: todoController.update)
    router.delete("todos", use: todoController.clear)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
