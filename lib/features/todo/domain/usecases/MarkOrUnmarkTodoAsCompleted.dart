import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failure/Failure.dart';
import 'package:todo_app/core/usecase/usecase.dart';
import 'package:todo_app/features/todo/domain/repositories/TodoRepository.dart';

class MarkOrUnmarkTodoAsCompleted extends UseCaseParam<void, num> {
  final TodoRepository _todoRepository;
  MarkOrUnmarkTodoAsCompleted({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  @override
  Future<Either<Failure, void>> call(num param) {
    return _todoRepository.markOrUnmarkedAsCompleted(id: param);
  }
}
