// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failure/Failure.dart';
import 'package:todo_app/core/usecase/usecase.dart';
import 'package:todo_app/features/todo/domain/entities/Priority.dart';
import 'package:todo_app/features/todo/domain/entities/Todo.dart';
import 'package:todo_app/features/todo/domain/repositories/TodoRepository.dart';

class AddTodoParam {
  final String title;
  final String? description;
  final DateTime dueDate;
  final Priority priority;

  AddTodoParam({
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
  });
}

class AddTodo extends UseCaseParam<Todo, AddTodoParam> {
  final TodoRepository _todoRepository;

  AddTodo({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  @override
  Future<Either<Failure,Todo >> call(AddTodoParam param) {
    return _todoRepository.addTodo(
        title: param.title,
        description: param.description,
        priority: param.priority,
        dueDate: param.dueDate);
  }
}
