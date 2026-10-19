import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/strings/app_strings.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';
import '../widgets/todo_list_item.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TodoCubit>()..loadTodos(),
      child: const TodoView(),
    );
  }
}

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.todosTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: AppStrings.whatNeedsDoingHint,
                    ),
                    onSubmitted: (value) {
                      context.read<TodoCubit>().addNewTodo(value);
                      _controller.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context.read<TodoCubit>().addNewTodo(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoCubit, TodoState>(
              builder: (context, state) {
                switch (state.status) {
                  case TodoStatus.initial:
                  case TodoStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case TodoStatus.failure:
                    return Center(child: Text(state.errorMessage ?? AppStrings.genericError));
                  case TodoStatus.success:
                    if (state.todos.isEmpty) {
                      return const Center(child: Text(AppStrings.noTodosYet));
                    }
                    return ListView.builder(
                      itemCount: state.todos.length,
                      itemBuilder: (context, index) {
                        final todo = state.todos[index];
                        return TodoListItem(
                          todo: todo,
                          onToggle: () =>
                              context.read<TodoCubit>().toggle(todo.id),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
