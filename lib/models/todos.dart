import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todos extends ChangeNotifier {
  final Map<int, Todo> _todos = {};
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

  Future<void> _removeTodoFromLocalStorage(int id) async {
    await _localStorage.remove('todo_$id');
  }

  Future<void> add(Todo todo) async {
    _todos[todo.id] = todo;
    await _saveTodoToLocalStorage(todo);
    notifyListeners();
  }

  Future<void> remove(int id) async {
    _todos.remove(id);
    await _removeTodoFromLocalStorage(id);
    notifyListeners();
  }

  Future<void> toggleDone(int id) async {
    if (_todos.containsKey(id)) {
      _todos[id]!.toggleDone();
      await _saveTodoToLocalStorage(_todos[id]!);
      notifyListeners();
    }
  }

  Future<void> update(int id, String newContent) async {
    if (_todos.containsKey(id)) {
      _todos[id]!.updateContent(newContent);
      await _saveTodoToLocalStorage(_todos[id]!);
      notifyListeners();
    }
  }

  Future<void> addAccumulatedTime(int id, Duration additionalTime) async {
    if (_todos.containsKey(id)) {
      _todos[id]!.addAccumulatedTime(additionalTime);
      await _saveTodoToLocalStorage(_todos[id]!);
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

  void toggleDone() {
    isDone = !isDone;
    if (isDone) {
      completedAt = DateTime.now();
    } else {
      completedAt = null;
    }
  }

  void updateContent(String newContent) {
    content = newContent;
  }

  void addAccumulatedTime(Duration additionalTime) {
    accumulatedTime += additionalTime;
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
