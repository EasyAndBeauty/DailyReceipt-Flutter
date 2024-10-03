import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todos extends ChangeNotifier {
  final Map<int, Todo> _todos = {};
  late SharedPreferences _localStorage;
  bool _isInitialized = false;

  Todos() {
    _initializeLocalStorage();
  }

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
  Duration accumulatedTime; // New field to track accumulated time

  Todo({
    required this.id,
    required this.content,
    this.isDone = false,
    required this.createdAt,
    this.completedAt,
    required this.scheduledDate,
    this.accumulatedTime = Duration.zero, // Initialize with zero duration
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
