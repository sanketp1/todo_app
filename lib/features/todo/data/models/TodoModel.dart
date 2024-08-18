import 'dart:convert';

import 'package:todo_app/features/todo/domain/entities/Priority.dart';
import 'package:todo_app/features/todo/domain/entities/Todo.dart';

class TodoModel extends Todo {
  TodoModel(
      {required super.id,
      required super.title,
      super.description,
      required super.completed,
      required super.priority,
      required super.createdAt,
      required super.dueDate});

  Todo copyWith({
    num? id,
    String? title,
    String? description,
    bool? completed,
    Priority? priority,
    DateTime? createdAt,
    DateTime? dueDate,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'priority': priority.toString(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'dueDate': dueDate.millisecondsSinceEpoch,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as num,
      title: map['title'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      completed: map['completed'] as bool,
      priority: _priorityMapper(map['priority'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      dueDate: DateTime.parse(map['dueDate'] as String),
    );
  }

  //priority mapper
  //by default keeping priority to medium
  static Priority _priorityMapper(String value) {
    switch (value) {
      case 'LOW':
        return Priority.LOW;
      case 'HIGH':
        return Priority.HIGH;
      default:
        return Priority.MEDIUM;
    }
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, description: $description, completed: $completed, priority: $priority, createdAt: $createdAt, dueDate: $dueDate)';
  }

  @override
  bool operator ==(covariant Todo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.completed == completed &&
        other.priority == priority &&
        other.createdAt == createdAt &&
        other.dueDate == dueDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        completed.hashCode ^
        priority.hashCode ^
        createdAt.hashCode ^
        dueDate.hashCode;
  }
}
