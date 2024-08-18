import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failure/Failure.dart';
import 'package:todo_app/core/usecase/usecase.dart';
import 'package:todo_app/features/todo/domain/repositories/TodoRepository.dart';

class DeleteAllTodos extends UseCaseNoParam<void> {
  final TodoRepository _todoRepository;
  DeleteAllTodos({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  @override
  Future<Either<Failure, void>> call() {
    return _todoRepository.deleteAll();
  }
}
