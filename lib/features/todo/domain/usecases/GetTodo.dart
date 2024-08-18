import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failure/Failure.dart';
import 'package:todo_app/core/usecase/usecase.dart';
import 'package:todo_app/features/todo/domain/entities/Todo.dart';
import 'package:todo_app/features/todo/domain/repositories/TodoRepository.dart';

class GetTodo extends UseCaseParam<Todo, num> {
  final TodoRepository _todoRepository;

  GetTodo({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  @override
  Future<Either<Failure, Todo>> call(num param) {
    return _todoRepository.getTodo(id: param);
  }
}
