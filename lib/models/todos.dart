import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todos extends ChangeNotifier {
  final Map<String, Todo> _todos = {};
  late SharedPreferences _localStorage;
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
    _localStorage = await SharedPreferences.getInstance();
    await Future.wait([_loadFromLocalStorage(), _loadPinStack()]);
    notifyListeners();
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
  }

  Future<void> _savePinStack() async {
    await _localStorage.setStringList(
      'pin_stack',
      _pinStack.map((date) => date.toIso8601String()).toList(),
    );
  }

  Future<void> _loadPinStack() async {
    final pinStackStrings = _localStorage.getStringList('pin_stack');
    if (pinStackStrings != null) {
      _pinStack.clear();
      for (final dateString in pinStackStrings) {
        try {
          _pinStack.add(DateTime.parse(dateString));
        } catch (e) {
          print('Error parsing pinned date $dateString: $e');
        }
      }
    }
  }

  Map<DateTime, List<Todo>> get pinnedTodos {
    return groupTodosByDate(
      _todos.values
          .where((todo) => _pinStack.contains(todo.scheduledDate))
          .toList(),
    );
  }

  Future<void> _saveTodoToLocalStorage(Todo todo) async {
    await _localStorage.setString('todo_${todo.id}', jsonEncode(todo.toJson()));
  }

  Future<void> _removeTodoFromLocalStorage(String id) async {
    await _localStorage.remove('todo_$id');
  }

  Future<void> add(Todo todo) async {
    _todos[todo.id] = todo;
    await _saveTodoToLocalStorage(todo);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _todos.remove(id);
    await _removeTodoFromLocalStorage(id);
    notifyListeners();
  }

  Future<void> toggleDone(String id) async {
    if (_todos.containsKey(id)) {
      final updatedTodo = _todos[id]!.toggleDone();
      _todos[id] = updatedTodo;
      await _saveTodoToLocalStorage(updatedTodo);
      notifyListeners();
    }
  }

  Future<void> update(String id, String newContent) async {
    if (_todos.containsKey(id)) {
      final updatedTodo = _todos[id]!.updateContent(newContent);
      _todos[id] = updatedTodo;
      await _saveTodoToLocalStorage(updatedTodo);
      notifyListeners();
    }
  }

  Future<void> addAccumulatedTime(String id, Duration additionalTime) async {
    if (_todos.containsKey(id)) {
      final updatedTodo = _todos[id]!.addAccumulatedTime(additionalTime);
      _todos[id] = updatedTodo;
      await _saveTodoToLocalStorage(updatedTodo);
      notifyListeners();
    }
  }

  void togglePin(DateTime date) {
    if (_pinStack.contains(date)) {
      _pinStack.remove(date);
    } else {
      _pinStack.add(date);
    }
    _savePinStack();
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
    _savePinStack();
    notifyListeners();
  }

  Map<DateTime, List<Todo>> groupTodosByDate(List<Todo> todos) {
    final Map<DateTime, List<Todo>> grouped = {};
    for (Todo todo in todos) {
      final DateTime date = todo.scheduledDate;
      grouped.putIfAbsent(date, () => []);
      grouped[date]!.add(todo);
    }
    return grouped;
  }

  List<Todo> getTodosForDate(DateTime date) {
    return _todos.values.where((todo) => todo.scheduledDate == date).toList();
  }
}

class Todo {
  final String id;
  final String content;
  final bool isDone;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime scheduledDate;
  final Duration accumulatedTime;

  Todo({
    required this.id,
    required this.content,
    this.isDone = false,
    required this.createdAt,
    this.completedAt,
    required this.scheduledDate,
    this.accumulatedTime = Duration.zero,
  });

  Todo copyWith({
    String? id,
    String? content,
    bool? isDone,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? scheduledDate,
    Duration? accumulatedTime,
  }) {
    return Todo(
      id: id ?? this.id,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      accumulatedTime: accumulatedTime ?? this.accumulatedTime,
    );
  }

  Todo toggleDone() {
    return copyWith(
      isDone: !isDone,
      completedAt: !isDone ? DateTime.now() : null,
    );
  }

  Todo updateContent(String newContent) {
    return copyWith(content: newContent);
  }

  Todo addAccumulatedTime(Duration additionalTime) {
    return copyWith(accumulatedTime: accumulatedTime + additionalTime);
  }

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
