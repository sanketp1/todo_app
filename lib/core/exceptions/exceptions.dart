//base class for all todo exceptions
abstract class TodoException {
  final String message;
  final int? statusCode;
  TodoException({required this.message, this.statusCode});
}

class TodoNotFoundException extends TodoException {
  TodoNotFoundException({required super.message, super.statusCode});
}

class InvalidTodoException extends TodoException {
  InvalidTodoException({required super.message, super.statusCode});
}

class SocketException extends TodoException {
  SocketException({required super.message, super.statusCode});
}

class UnknownException extends TodoException {
  UnknownException({required super.message, super.statusCode});
}
