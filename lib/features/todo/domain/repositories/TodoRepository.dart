import 'package:todo_app/core/failure/Failure.dart';
import 'package:todo_app/features/todo/domain/entities/Priority.dart';
import 'package:todo_app/features/todo/domain/entities/Todo.dart';
import 'package:dartz/dartz.dart';

abstract class TodoRepository {
  Future<Either<Failure, Todo>> addTodo(
      {required String title,
      String? description,
      required Priority priority,
      required DateTime dueDate});

  Future<Either<Failure, Todo>> getTodo({required num id});

  Future<Either<Failure, List<Todo>>> getAllTodos();

  Future<Either<Failure, Todo>> updateTodo(
      {required num id,
      required String title,
      String? description,
      required Priority priority,
      required DateTime dueDate});

  Future<Either<Failure, void>> markOrUnmarkedAsCompleted({required num id});

  Future<Either<Failure, void>> deleteById({required num id});

  Future<Either<Failure, void>> deleteAll();
}
