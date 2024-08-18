import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:todo_app/features/todo/data/datasources/remote/TodoDatasource.dart';
import 'package:todo_app/features/todo/data/repositories/TodoRepositoryImpl.dart';
import 'package:todo_app/features/todo/domain/repositories/TodoRepository.dart';
import 'package:todo_app/features/todo/domain/usecases/MarkOrUnmarkTodoAsCompleted.dart';
import 'package:todo_app/features/todo/domain/usecases/usecases_i.dart';
import 'package:todo_app/features/todo/presentation/cubit/todo_cubit.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // Registering HTTP client
  sl.registerSingleton<Client>(Client());

  // Registering data source
  sl.registerSingleton<TodoDatasource>(
      TodoDatasourceImpl(client: sl<Client>()));

  // Registering repository
  sl.registerSingleton<TodoRepository>(
      TodoRepositoryImpl(todoDatasource: sl<TodoDatasource>()));

  // Registering use cases
  sl.registerSingleton<AddTodo>(AddTodo(todoRepository: sl<TodoRepository>()));
  sl.registerSingleton<GetTodo>(GetTodo(todoRepository: sl<TodoRepository>()));
  sl.registerSingleton<GetAllTodos>(
      GetAllTodos(todoRepository: sl<TodoRepository>()));
  sl.registerSingleton(UpdateTodo(todoRepository: sl<TodoRepository>()));
  sl.registerSingleton(
      MarkOrUnmarkTodoAsCompleted(todoRepository: sl<TodoRepository>()));
  sl.registerSingleton(DeleteTodo(todoRepository: sl<TodoRepository>()));
  sl.registerSingleton(DeleteAllTodos(todoRepository: sl<TodoRepository>()));

  // Registering cubit
  sl.registerFactory(() => TodoCubit(
      getTodo: sl<GetTodo>(),
      getAllTodos: sl<GetAllTodos>(),
      addTodo: sl<AddTodo>(),
      updateTodo: sl<UpdateTodo>(),
      markOrUnmarkTodoAsCompleted: sl<MarkOrUnmarkTodoAsCompleted>(),
      deleteTodo: sl<DeleteTodo>(),
      deleteAllTodos: sl<DeleteAllTodos>()));
}
