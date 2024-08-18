import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/todo/domain/entities/Todo.dart';
import 'package:todo_app/features/todo/presentation/cubit/todo_cubit.dart';
import 'package:todo_app/features/todo/presentation/pages/TodoEditor.dart';

class TodoPage extends StatefulWidget {
  TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    context.read<TodoCubit>().fetchTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.today_outlined),
        title: Text("Todo"),
        actions: [
          TextButton.icon(
            onPressed: () {
              context.read<TodoCubit>().deleteAllTodos();
            },
            icon: Icon(Icons.delete_outlined),
            label: Text("Delete All"),
            style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.red)),
          ),
        ],
      ),
      body: BlocConsumer<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state.status == TodoStatus.loading ||
              state.status == TodoStatus.inital) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
          if (state.todos.isEmpty) {
            return Center(
              child: Text(
                "Write your first todo...",
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final Todo todo = state.todos[index];
              return Dismissible(
                key: Key(todo.id.toString()),
                onDismissed: (direction) {
                  context.read<TodoCubit>().deleteTodo(todo.id);
                },
                background: Container(
                  color: Colors.red,
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4,
                            color: Colors.grey.shade100,
                            offset: Offset(2, 2))
                      ]),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.completed,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        context
                            .read<TodoCubit>()
                            .markOrUnmarkAsCompleted(todo.id);
                      },
                    ),
                    title: Text(todo.title),
                    subtitle: Text(todo.description ?? ''),
                    trailing: TextButton.icon(
                        onPressed: () {
                          //moving to todo editor for update
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                        value: context.read<TodoCubit>(),
                                        child: TodoEditor.update(
                                          todo: todo,
                                        ),
                                      )));
                        },
                        icon: Icon(Icons.edit),
                        label: Text("Edit")),
                    subtitleTextStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              );
            },
          );
        },
        listener: (context, state) {
          if (state.status == TodoStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.errorMessage ?? "An error occuured.")));
          }

          if (state.status == TodoStatus.added) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Todo added successfully.")));
          }

          if (state.status == TodoStatus.deleted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Deleted successfully.")));
          }

          if (state.status == TodoStatus.updated) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Todo updated successfully.")));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                        value: context.read<TodoCubit>(),
                        child: TodoEditor.create(),
                      )));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
