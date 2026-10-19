import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class ToggleTodo implements UseCase<Todo, ToggleTodoParams> {
  final TodoRepository repository;

  const ToggleTodo(this.repository);

  @override
  Future<Todo> call(ToggleTodoParams params) {
    return repository.toggleTodo(params.id);
  }
}

class ToggleTodoParams extends Equatable {
  final String id;

  const ToggleTodoParams(this.id);

  @override
  List<Object?> get props => [id];
}
