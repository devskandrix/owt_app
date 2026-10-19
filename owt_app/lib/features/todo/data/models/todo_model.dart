import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/todo.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    super.isDone,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  factory TodoModel.fromEntity(Todo todo) => TodoModel(
        id: todo.id,
        title: todo.title,
        isDone: todo.isDone,
      );
}
