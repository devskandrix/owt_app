import '../../../../core/usecase/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class GetTodos implements UseCase<List<Todo>, NoParams> {
  final TodoRepository repository;

  const GetTodos(this.repository);

  @override
  Future<List<Todo>> call(NoParams params) {
    return repository.getTodos();
  }
}
