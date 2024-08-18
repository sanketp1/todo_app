import 'package:dartz/dartz.dart';
import 'package:todo_app/core/exceptions/exceptions.dart';
import 'package:todo_app/core/failure/Failure.dart';
import 'package:todo_app/features/todo/data/datasources/remote/TodoDatasource.dart';
import 'package:todo_app/features/todo/domain/entities/Priority.dart';
import 'package:todo_app/features/todo/domain/entities/Todo.dart';
import 'package:todo_app/features/todo/domain/repositories/TodoRepository.dart';

class TodoRepositoryImpl extends TodoRepository {
  final TodoDatasource _datasource;

  TodoRepositoryImpl({required TodoDatasource todoDatasource})
      : _datasource = todoDatasource;

  @override
  Future<Either<Failure, Todo>> addTodo(
      {required String title,
      String? description,
      required Priority priority,
      required DateTime dueDate}) async {
    try {
      final result = await _datasource.addTodo(
          title: title,
          description: description,
          priority: priority,
          dueDate: dueDate);

      return Right(result);
    } on InvalidTodoException catch (e) {
      return Left(Failure(message: e.message));
    } on UnknownException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAll() async {
    try {
      return Right(await _datasource.deleteAll());
    } on UnknownException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteById({required num id}) async {
    try {
      return Right(await _datasource.deleteById(id));
    } on TodoNotFoundException catch (e) {
      return Left(Failure(message: e.message));
    } on UnknownException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getAllTodos() async {
    try {
      final result = await _datasource.getAllTodos();
      return Right(result);
    } on UnknownException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Todo>> getTodo({required num id}) async {
    try {
      final todo = await _datasource.getTodo(id);
      return Right(todo);
    } on TodoNotFoundException catch (e) {
      return Left(Failure(message: e.message));
    } on UnknownException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> markOrUnmarkedAsCompleted({required num id}) async {
    try {
      return Right(_datasource.markOrUnmarkedAsCompleted(id));
    } on UnknownException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(
      {required num id,
      required String title,
      String? description,
      required Priority priority,
      required DateTime dueDate}) async {
    try {
      final todo = await _datasource.updateTodo(
          id: id,
          title: title,
          description: description,
          priority: priority,
          dueDate: dueDate);
      return Right(todo);
    } on UnknownException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
