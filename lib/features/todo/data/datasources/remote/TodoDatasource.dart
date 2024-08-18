import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:todo_app/core/constants/api.dart';
import 'package:todo_app/core/exceptions/exceptions.dart';
import 'package:todo_app/features/todo/data/models/TodoModel.dart';
import 'package:todo_app/features/todo/domain/entities/Priority.dart';
import 'package:http/http.dart';

abstract class TodoDatasource {
  Future<TodoModel> addTodo(
      {required String title,
      String? description,
      required Priority priority,
      required DateTime dueDate});

  Future<TodoModel> getTodo(num id);

  Future<List<TodoModel>> getAllTodos();

  Future<TodoModel> updateTodo(
      {required num id,
      required String title,
      String? description,
      required Priority priority,
      required DateTime dueDate});

  Future<void> markOrUnmarkedAsCompleted(num id);

  Future<void> deleteById(num id);

  Future<void> deleteAll();
}

class TodoDatasourceImpl extends TodoDatasource {
  final Client _client;
  TodoDatasourceImpl({required Client client}) : _client = client;

  @override
  Future<TodoModel> addTodo(
      {required String title,
      String? description,
      required Priority priority,
      required DateTime dueDate}) async {
    try {
      //preparing payload for addding todo
      Map<String, dynamic> data = {
        "title": title,
        "description": description,
        "priority": priority.name,
        'dueDate': dueDate.toIso8601String()
      };

      final response = await _client.post(Uri.parse(baseURL),
          headers: _headers, body: json.encode(data));

      // in-case if invalid todo to be added
      if (response.statusCode == HttpStatus.badRequest) {
        //getting exception cause
        final result = json.decode(response.body);

        //throwing invalid todo exception
        throw InvalidTodoException(
            message: result['message'] as String,
            statusCode: result['statusCode'] as int);
      }

      //parsing added todo to TodoModel
      return TodoModel.fromJson(response.body);
    } catch (e) {
      log(e.toString());
    }

    throw _unknownException;
  }

  @override
  Future<void> deleteAll() async {
    try {
      final response =
          await _client.delete(Uri.parse(baseURL), headers: _headers);
      return;
    } catch (e) {
      log(e.toString());
    }

    throw _unknownException;
  }

  @override
  Future<void> deleteById(num id) async {
    try {
      final response = await _client.delete(Uri.parse(baseURL + "/${id}"),
          headers: _headers);
      return;
    } catch (e) {
      log(e.toString());
    }

    throw _unknownException;
  }

  @override
  Future<List<TodoModel>> getAllTodos() async {
    try {
      final response = await _client.get(Uri.parse(baseURL), headers: _headers);
      // log(response.body);
      //parsing list of todos
      return (json.decode(response.body) as List<dynamic>)
          .map((e) => TodoModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log(e.toString());
    }

    throw _unknownException;
  }

  @override
  Future<TodoModel> getTodo(num id) async {
    try {
      final response =
          await _client.get(Uri.parse(baseURL + "/${id}"), headers: _headers);

      //incase if todo is not found of given id
      if (response.statusCode == HttpStatus.notFound) {
        final res = json.decode(response.body);
        throw TodoNotFoundException(
            message: res['message'] as String,
            statusCode: res['statusCode'] as int);
      }

      //parsing response to TodoModel
      return TodoModel.fromJson(response.body);
    } catch (e) {
      log(e.toString());
    }

    throw _unknownException;
  }

  @override
  Future<void> markOrUnmarkedAsCompleted(num id) async {
    try {
      final response = await _client
          .patch(Uri.parse(baseURL + "/${id}/markOrUnmark"), headers: _headers);
      return;
    } catch (e) {
      log(e.toString());
    }

    throw _unknownException;
  }

  @override
  Future<TodoModel> updateTodo(
      {required num id,
      required String title,
      String? description,
      required Priority priority,
      required DateTime dueDate}) async {
    try {
      //preparing payload for updating todo
      Map<String, dynamic> data = {
        "title": title,
        "description": description,
        "priority": priority.name,
        'dueDate': dueDate.toIso8601String()
      };

      

      final response = await _client.put(Uri.parse(baseURL + "/${id}"),
          headers: _headers, body: json.encode(data));

      //incase if todo not found for given id
      if (response.statusCode == HttpStatus.notFound) {
        final res = json.decode(response.body);
        throw TodoNotFoundException(
            message: res['message'] as String,
            statusCode: res['statusCode'] as int);
      }

      //parsing response to TodoModel
      return TodoModel.fromJson(response.body);
    } catch (e) {
      log(e.toString());
    }

    throw _unknownException;
  }

  Map<String, String>? get _headers => {'Content-Type': 'application/json'};

  UnknownException get _unknownException =>
      UnknownException(message: "An unknown error occurred.");
}
