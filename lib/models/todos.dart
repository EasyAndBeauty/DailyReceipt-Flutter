import 'package:flutter/material.dart';

class Todos extends ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void add(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }
}

class Todo {
  final int id;
  String content;
  bool isDone;

  final DateTime createdAt;
  DateTime? completedAt;

  Todo({
    required this.id,
    required this.content,
    this.isDone = false,
    required this.createdAt,
    this.completedAt,
  });
}
