import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todos extends ChangeNotifier {
  final Map<int, Todo> _todos = {};
  late SharedPreferences _localStorage;
  bool _isInitialized = false;
  final List<DateTime> _pinStack = [];

  Todos() {
    _initializeLocalStorage();
  }
  List<DateTime> get pinStack => _pinStack;

  List<Todo> get todos => List.unmodifiable(_todos.values);

  Map<DateTime, List<Todo>> get groupedTodosByDate {
    return groupTodosByDate(_todos.values.toList());
  }

  Future<void> _initializeLocalStorage() async {
    if (_isInitialized) return;
    _localStorage = await SharedPreferences.getInstance();
    await _loadFromLocalStorage();
    _isInitialized = true;
  }

  Future<void> _loadFromLocalStorage() async {
    final keys = _localStorage.getKeys();

    for (final key in keys) {
      if (key.startsWith('todo_')) {
        final todoJson = _localStorage.getString(key);
        if (todoJson != null) {
          try {
            final todo = Todo.fromJson(jsonDecode(todoJson));
            _todos[todo.id] = todo;
          } catch (e) {
            print('Error loading todo $key: $e');
          }
        }
      }
    }
  Map<DateTime, List<Todo>> get pinnedTodos {
    return groupTodosByDate(_todos
        .where((todo) => _pinStack.contains(todo.scheduledDate))
        .toList());
  }

  void add(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  Future<void> _saveTodo(Todo todo) async {
    final key = 'todo_${todo.id}';
    await _localStorage.setString(key, jsonEncode(todo.toJson()));
  }

  Future<void> _removeTodoFromStorage(int id) async {
    final key = 'todo_$id';
    await _localStorage.remove(key);
  }

  Future<void> add(Todo todo) async {
    await _initializeLocalStorage();
    _todos[todo.id] = todo;
    await _saveTodo(todo);
    notifyListeners();
  }

  Future<void> remove(int id) async {
    await _initializeLocalStorage();
    _todos.remove(id);
    await _removeTodoFromStorage(id);
    notifyListeners();
  }

  Future<void> toggleDone(int id) async {
    await _initializeLocalStorage();
    if (_todos.containsKey(id)) {
      _todos[id]!.isDone = !_todos[id]!.isDone;
      await _saveTodo(_todos[id]!);
      notifyListeners();
    }
  }

  Future<void> update(int id, String newContent) async {
    await _initializeLocalStorage();
    if (_todos.containsKey(id)) {
      _todos[id]!.content = newContent;
      await _saveTodo(_todos[id]!);
      notifyListeners();
    }
  }

  Future<void> addAccumulatedTime(int id, Duration additionalTime) async {
    await _initializeLocalStorage();
    if (_todos.containsKey(id)) {
      _todos[id]!.accumulatedTime += additionalTime;
      await _saveTodo(_todos[id]!);
      notifyListeners();
    }
  }

  void togglePin(DateTime date) {
    if (_pinStack.contains(date)) {
      _pinStack.remove(date);
    } else {
      _pinStack.add(date);
    }
    notifyListeners();
  }

  bool isPinned(DateTime date) {
    return _pinStack.contains(date);
  }

  void reorderPinStack(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final DateTime date = _pinStack.removeAt(oldIndex);
    _pinStack.insert(newIndex, date);
    notifyListeners();
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

  List<Todo> getTodosForDate(DateTime date) {
    return _todos.where((todo) => todo.scheduledDate == date).toList();
  }
}

class Todo {
  final int id;
  String content;
  bool isDone;
  final DateTime createdAt;
  DateTime? completedAt;
  DateTime scheduledDate;
  Duration accumulatedTime;

  Todo({
    required this.id,
    required this.content,
    this.isDone = false,
    required this.createdAt,
    this.completedAt,
    required this.scheduledDate,
    this.accumulatedTime = Duration.zero,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'scheduledDate': scheduledDate.toIso8601String(),
      'accumulatedTime': accumulatedTime.inSeconds,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      content: json['content'],
      isDone: json['isDone'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      scheduledDate: DateTime.parse(json['scheduledDate']),
      accumulatedTime: Duration(seconds: json['accumulatedTime']),
    );
  }
}
