import '../entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();

  Future<Todo> addTodo(String title);

  Future<Todo> toggleTodo(String id);
}
