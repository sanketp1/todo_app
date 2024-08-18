// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'Priority.dart';

class Todo {
  final num id;
  final String title;
  final String? description;
  final bool completed;
  final Priority priority;
  final DateTime createdAt;
  final DateTime dueDate;

  Todo({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.priority,
    required this.createdAt,
    required this.dueDate,
  });

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
}
