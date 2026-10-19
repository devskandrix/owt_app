import 'dart:convert';

import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();

  Future<TodoModel> addTodo(String title);

  Future<TodoModel> toggleTodo(String id);
}

/// In-memory implementation. Todos are round-tripped through
/// `TodoModel.toJson`/`fromJson` on every read/write so swapping this for a
/// persisted store (e.g. shared_preferences) later only means changing where
/// the encoded string is stored, not the model layer.
class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final List<String> _storage = [];

  @override
  Future<List<TodoModel>> getTodos() async {
    return _storage
        .map((raw) => TodoModel.fromJson(jsonDecode(raw) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TodoModel> addTodo(String title) async {
    final model = TodoModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
    );
    _storage.add(jsonEncode(model.toJson()));
    return model;
  }

  @override
  Future<TodoModel> toggleTodo(String id) async {
    final index = _storage.indexWhere(
      (raw) => (jsonDecode(raw) as Map<String, dynamic>)['id'] == id,
    );
    if (index == -1) {
      throw StateError('Todo with id $id not found');
    }
    final current = TodoModel.fromJson(
      jsonDecode(_storage[index]) as Map<String, dynamic>,
    );
    final updated = TodoModel.fromEntity(
      current.copyWith(isDone: !current.isDone),
    );
    _storage[index] = jsonEncode(updated.toJson());
    return updated;
  }
}
