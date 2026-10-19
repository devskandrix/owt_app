import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class AddTodo implements UseCase<Todo, AddTodoParams> {
  final TodoRepository repository;

  const AddTodo(this.repository);

  @override
  Future<Todo> call(AddTodoParams params) {
    return repository.addTodo(params.title);
  }
}

class AddTodoParams extends Equatable {
  final String title;

  const AddTodoParams(this.title);

  @override
  List<Object?> get props => [title];
}
