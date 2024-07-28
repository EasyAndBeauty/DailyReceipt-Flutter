import 'package:flutter/material.dart';

class Todos extends ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Map<DateTime, List<Todo>> get groupedTodosByDate {
    return groupTodosByDate(_todos);
  }

  void add(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void remove(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  void toggleDone(int id) {
    int index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].isDone = !_todos[index].isDone;
      notifyListeners();
    }
  }

  Map<DateTime, List<Todo>> groupTodosByDate(List<Todo> todos) {
    Map<DateTime, List<Todo>> grouped = {};

    for (Todo todo in todos) {
      DateTime date = todo.scheduledDate;
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(todo);
    }

    return grouped;
  }
}

class Todo {
  final int id;
  String content;
  bool isDone;

  final DateTime createdAt;
  DateTime? completedAt;
  DateTime scheduledDate;

  Todo({
    required this.id,
    required this.content,
    this.isDone = false,
    required this.createdAt,
    this.completedAt,
    required this.scheduledDate,
  });
}
