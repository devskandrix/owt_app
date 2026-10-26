import 'package:flutter/material.dart';

import '../../domain/entities/todo.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;

  const TodoListItem({super.key, required this.todo, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: todo.isDone,
      onChanged: (_) => onToggle(),
      title: Text(
        todo.title,
        style: todo.isDone
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
    );
  }
}
