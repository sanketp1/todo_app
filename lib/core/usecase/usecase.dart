import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failure/Failure.dart';

abstract class UseCaseParam<T, Param> {
  Future<Either<Failure, T>> call(Param param);
}

abstract class UseCaseNoParam<T> {
  Future<Either<Failure, T>> call();
}
