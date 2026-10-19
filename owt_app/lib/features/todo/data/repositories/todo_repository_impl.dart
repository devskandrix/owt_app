import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  const TodoRepositoryImpl(this.localDataSource);

  @override
  Future<List<Todo>> getTodos() => localDataSource.getTodos();

  @override
  Future<Todo> addTodo(String title) => localDataSource.addTodo(title);

  @override
  Future<Todo> toggleTodo(String id) => localDataSource.toggleTodo(id);
}
