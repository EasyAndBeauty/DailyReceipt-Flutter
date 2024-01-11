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
