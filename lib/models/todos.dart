import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todos extends ChangeNotifier {
  final List<Todo> _todos = [];
  late SharedPreferences _localStorage;
  bool _isInitialized = false;

  Todos() {
    // Todos 클래스 기본 생성자. 새 인스턴스 생성될 때 자동으로 호출됨
    _initializeLocalStorage();
  }

  List<Todo> get todos => _todos;

  Map<DateTime, List<Todo>> get groupedTodosByDate {
    return groupTodosByDate(_todos);
  }

  Future<void> _initializeLocalStorage() async {
    if (_isInitialized) return;
    _localStorage = await SharedPreferences.getInstance();
    await _loadFromLocalStorage();
    _isInitialized = true;
  }

  Future<void> _loadFromLocalStorage() async {
    String? todosJson = _localStorage.getString('todos');
    if (todosJson == null) return;

    try {
      List<dynamic> todosList = jsonDecode(todosJson);
      // todosList를 에러없이 가져왔다면 메모리에 남은 데이터 초기화하고 로컬 데이터를 todos에 추가
      _todos.clear();
      _todos.addAll(todosList.map((json) => Todo.fromJson(json)));
      notifyListeners();
    } catch (e) {
      print('Error loading todos: $e');
    }
  }

  Future<void> _updateLocalStorage() async {
    List<Map<String, dynamic>> todosList =
        _todos.map((todo) => todo.toJson()).toList();
    String todosJson = jsonEncode(todosList);
    await _localStorage.setString('todos', todosJson);
  }

  void add(Todo todo) {
    _todos.add(todo);
    _updateLocalStorage();
    notifyListeners();
  }

  void remove(int index) {
    _todos.removeAt(index);
    _updateLocalStorage();
    notifyListeners();
  }

  void toggleDone(int id) {
    int index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].isDone = !_todos[index].isDone;
      _updateLocalStorage();
      notifyListeners();
    }
  }

  void update(int id, String newContent) {
    int index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].content = newContent;
      _updateLocalStorage();
      notifyListeners();
    }
  }

  void addAccumulatedTime(int id, Duration additionalTime) {
    int index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].accumulatedTime += additionalTime;
      _updateLocalStorage();
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
