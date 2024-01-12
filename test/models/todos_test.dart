import 'package:daily_receipt/models/todos.dart';
import 'package:test/test.dart';

void main() {
  group('todos Provider', () {
    var todosProvider = Todos();

    test('새로운 todo가 todos에 추가되어야 합니다.', () {
      var newTodo = Todo(
        id: todosProvider.todos.length,
        content: 'test',
        createdAt: DateTime.now().toUtc(),
      );

      todosProvider.add(newTodo);

      expect(todosProvider.todos.contains(newTodo), true);
    });
  });
}
