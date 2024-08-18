// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failure/Failure.dart';
import 'package:todo_app/core/usecase/usecase.dart';
import 'package:todo_app/features/todo/domain/entities/Priority.dart';
import 'package:todo_app/features/todo/domain/entities/Todo.dart';
import 'package:todo_app/features/todo/domain/repositories/TodoRepository.dart';

class UpdateTodoParam {
  final num id;
  final String title;
  final String? description;
  final Priority priority;
  final DateTime dueDate;
  UpdateTodoParam({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.dueDate,
  });
}

class UpdateTodo extends UseCaseParam<Todo, UpdateTodoParam> {
  final TodoRepository _todoRepository;
  UpdateTodo({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  @override
  Future<Either<Failure, Todo>> call(UpdateTodoParam param) {
    return _todoRepository.updateTodo(
        id: param.id,
        title: param.title,
        description: param.description,
        priority: param.priority,
        dueDate: param.dueDate);
  }
}
