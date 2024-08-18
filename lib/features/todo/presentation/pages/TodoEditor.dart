import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/todo/domain/entities/Priority.dart';
import 'package:todo_app/features/todo/domain/entities/Todo.dart';
import 'package:todo_app/features/todo/presentation/cubit/todo_cubit.dart';

class TodoEditor extends StatefulWidget {
  //making constructor private
  TodoEditor._private({Todo? todo}) : this.todo = todo;

  final Todo? todo;

  factory TodoEditor.create() => TodoEditor._private();

  factory TodoEditor.update({required Todo todo}) => TodoEditor._private(
        todo: todo,
      );

  @override
  State<TodoEditor> createState() => _TodoEditorState();
}

class _TodoEditorState extends State<TodoEditor> {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  //checking either todo editor is called for update todo or not
  //intially keeping as false
  bool isForUpdate = false;

  @override
  void initState() {
    //initalizing title and desc text-controllers
    //if todo is going to update then
    if (widget.todo != null) {
      isForUpdate = true;

      _titleController = TextEditingController(text: widget.todo!.title);
      _descController = TextEditingController(text: widget.todo!.description);
      return;
    }

    _titleController = TextEditingController();
    _descController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    //disposing the text-controllers after page exit
    _titleController.dispose();
    _descController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Write Todo"),
        actions: [
          TextButton.icon(
              onPressed: () async {
                if (_titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please enter title for your todo."),
                    hitTestBehavior: HitTestBehavior.translucent,
                    behavior: SnackBarBehavior.floating,
                  ));

                  return;
                }

                //if todo is for update then
                if (isForUpdate) {
                  context.read<TodoCubit>().updateTodo(
                      id: widget.todo!.id,
                      title: _titleController.text,
                      description: _descController.text,
                      priority: Priority.MEDIUM,
                      dueDate: DateTime.now());
                }

                if (!isForUpdate) {
                //adding todo
                context.read<TodoCubit>().addTodo(
                    title: _titleController.text,
                    description: _descController.text,
                    priority: Priority.MEDIUM,
                    dueDate: DateTime.now());
                }

                Navigator.pop(context);

                return;
              },
              icon: Icon(Icons.save),
              label: Text(isForUpdate ? "Update" : "Save"))
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 80,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: Colors.blue, width: 0.5),
                boxShadow: [
                  BoxShadow(
                      // color: Colors
                      )
                ]),
            child: SelectableRegion(
              focusNode: FocusNode(),
              selectionControls: MaterialTextSelectionControls(),
              child: TextField(
                controller: _titleController,
                maxLines: 4,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    hintText: "Title",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: Colors.blue, width: 0.5),
                boxShadow: [
                  BoxShadow(
                      // color: Colors
                      )
                ]),
            child: SelectableRegion(
              focusNode: FocusNode(),
              selectionControls: MaterialTextSelectionControls(),
              child: TextField(
                controller: _descController,
                maxLines: 36,
                // style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    hintText: "Description (Optional)",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
