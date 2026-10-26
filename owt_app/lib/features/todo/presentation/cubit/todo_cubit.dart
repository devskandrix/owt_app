import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/toggle_todo.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final ToggleTodo toggleTodo;

  TodoCubit({
    required this.getTodos,
    required this.addTodo,
    required this.toggleTodo,
  }) : super(const TodoState());

  Future<void> loadTodos() async {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      final todos = await getTodos(const NoParams());
      emit(state.copyWith(status: TodoStatus.success, todos: todos));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failure, errorMessage: '$e'));
    }
  }

  Future<void> addNewTodo(String title) async {
    if (title.trim().isEmpty) return;
    try {
      final todo = await addTodo(AddTodoParams(title.trim()));
      emit(state.copyWith(todos: [...state.todos, todo]));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failure, errorMessage: '$e'));
    }
  }

  Future<void> toggle(String id) async {
    try {
      final updated = await toggleTodo(ToggleTodoParams(id));
      emit(
        state.copyWith(
          todos: [
            for (final todo in state.todos)
              if (todo.id == updated.id) updated else todo,
          ],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failure, errorMessage: '$e'));
    }
  }
}
