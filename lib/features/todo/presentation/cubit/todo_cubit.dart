import 'dart:developer';

import 'package:todo_app/features/todo/domain/usecases/AddTodo.dart';
import 'package:todo_app/features/todo/domain/usecases/DeleteAllTodos.dart';
import 'package:todo_app/features/todo/domain/usecases/DeleteTodo.dart';
import 'package:todo_app/features/todo/domain/usecases/GetAllTodos.dart';
import 'package:todo_app/features/todo/domain/usecases/GetTodo.dart';
import 'package:todo_app/features/todo/domain/usecases/MarkOrUnmarkTodoAsCompleted.dart';
import 'package:todo_app/features/todo/domain/usecases/UpdateTodo.dart';

import '../../domain/entities/Todo.dart';
import '../../domain/entities/Priority.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit(
      {required GetTodo getTodo,
      required GetAllTodos getAllTodos,
      required AddTodo addTodo,
      required UpdateTodo updateTodo,
      required MarkOrUnmarkTodoAsCompleted markOrUnmarkTodoAsCompleted,
      required DeleteTodo deleteTodo,
      required DeleteAllTodos deleteAllTodos})
      : _getTodo = getTodo,
        _getAllTodos = getAllTodos,
        _addTodo = addTodo,
        _updateTodo = updateTodo,
        _markOrUnmarkTodo = markOrUnmarkTodoAsCompleted,
        _deleteTodo = deleteTodo,
        _deleteAllTodos = deleteAllTodos,
        super(TodoState(status: TodoStatus.inital));

  //inserting required dependencies
  late final GetTodo _getTodo;
  late final GetAllTodos _getAllTodos;
  late final AddTodo _addTodo;
  late final UpdateTodo _updateTodo;
  late final MarkOrUnmarkTodoAsCompleted _markOrUnmarkTodo;
  late final DeleteTodo _deleteTodo;
  late final DeleteAllTodos _deleteAllTodos;

  void fetchTodos() async {
    emit(state.copyWith(status: TodoStatus.loading));
    //getting all todos
    final result = await _getAllTodos();

    //getting response from server either failure or success
    result.fold(
        (failure) => emit(state.copyWith(
            status: TodoStatus.error, errorMessage: failure.message)),
        (response) =>
            emit(state.copyWith(status: TodoStatus.loaded, todos: response)));
  }

  void addTodo(
      {required String title,
      String? description,
      required Priority priority,
      required DateTime dueDate}) async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await _addTodo(AddTodoParam(
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority));

    result.fold(
        (failure) => emit(state.copyWith(
            status: TodoStatus.error,
            errorMessage: failure.message)), (response) {
      log("added...");
      final updatedTodos = List<Todo>.from(state.todos)..add(response);
      emit(state.copyWith(status: TodoStatus.added, todos: updatedTodos));
    });
  }

  void updateTodo(
      {required num id,
      String? title,
      String? description,
      Priority? priority,
      DateTime? dueDate}) async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await _updateTodo(UpdateTodoParam(
        id: id,
        title: title!,
        description: description!,
        priority: priority!,
        dueDate: dueDate!));

    result.fold(
        (failure) => emit(state.copyWith(
            status: TodoStatus.error,
            errorMessage: failure.message)), (response) {
      //removing current todo
      state.todos.removeWhere((todo) => todo.id == id);
      final updatedTodos = List<Todo>.from(state.todos)..add(response);

      emit(state.copyWith(status: TodoStatus.updated, todos: updatedTodos));
    });
  }

  void markOrUnmarkAsCompleted(num id) async {
    emit(state.copyWith(status: TodoStatus.loading));

    final updatedTodo = List<Todo>.from(state.todos
        .map((e) => e.id == id ? e.copyWith(completed: !e.completed) : e)
        .toList());

    emit(state.copyWith(status: TodoStatus.loaded, todos: updatedTodo));

    //marking as completed
    final result = await _markOrUnmarkTodo(id);

    result.fold((failure) {
      final updatedTodo = List<Todo>.from(state.todos
          .map((e) => e.id == id ? e.copyWith(completed: !e.completed) : e)
          .toList());
      emit(state.copyWith(
          status: TodoStatus.error,
          errorMessage: failure.message,
          todos: updatedTodo));
    }, (response) => (r) {});
  }

  void deleteTodo(num id) async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await _deleteTodo(id);

    result.fold(
        (failure) => emit(state.copyWith(
            status: TodoStatus.error,
            errorMessage: failure.message)), (response) {
      state.todos.removeWhere((element) => element.id == id);
      final updatedTodos = List<Todo>.from(state.todos);

      emit(state.copyWith(status: TodoStatus.deleted, todos: updatedTodos));
    });
  }

  void deleteAllTodos() async {
    emit(state.copyWith(status: TodoStatus.loading));

    final result = await _deleteAllTodos();

    result.fold(
        (failure) => emit(state.copyWith(
            status: TodoStatus.error, errorMessage: failure.message)),
        (response) =>
            emit(state.copyWith(status: TodoStatus.deleted, todos: [])));
  }
}
