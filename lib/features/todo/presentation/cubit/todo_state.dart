part of 'todo_cubit.dart';

enum TodoStatus { inital, loading,added, deleted, updated, loaded, error }

class TodoState extends Equatable {
  final TodoStatus status;
  final List<Todo> todos;
  final String? errorMessage;

  const TodoState({
    required this.status,
    this.todos = const [],
    this.errorMessage,
  });

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todos,
    String? errorMessage,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, todos];
}
