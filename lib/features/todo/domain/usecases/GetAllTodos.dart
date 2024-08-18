import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failure/Failure.dart';
import 'package:todo_app/core/usecase/usecase.dart';
import 'package:todo_app/features/todo/domain/entities/Todo.dart';
import 'package:todo_app/features/todo/domain/repositories/TodoRepository.dart';

class GetAllTodos extends UseCaseNoParam<List<Todo>> {
 
  final TodoRepository _todoRepository;
 
  GetAllTodos({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  @override
  Future<Either<Failure,List<Todo>>> call() {
    return _todoRepository.getAllTodos();
  }

}
