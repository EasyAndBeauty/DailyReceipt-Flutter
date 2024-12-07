import 'package:daily_receipt/models/todos.dart';
import 'package:test/test.dart';

void main() {
  group('todos Provider', () {
    var todosProvider = Todos();

    test('새로운 todo가 todos에 추가되어야 합니다.', () {
      var newTodo = Todo(
        id: '1',
        content: 'test',
        createdAt: DateTime.now().toUtc(),
        scheduledDate: DateTime(2024, 1, 1),
      );

      todosProvider.add(newTodo);

      expect(todosProvider.todos.contains(newTodo), true);
    });

    test('todos를 날짜별로 그룹화하여 Map으로 반환합니다.', () {
      final existsDate = DateTime(2024, 1, 1);
      final notExistsDate = DateTime(2024, 1, 2);
      var todos = [
        Todo(
          id: '1',
          content: 'test',
          createdAt: DateTime.now().toUtc(),
          scheduledDate: existsDate,
        )
      ];

      var groupedTodos = todosProvider.groupTodosByDate(todos);

      expect(groupedTodos[existsDate]?.length, 1);
      expect(groupedTodos[existsDate]?.first, equals(todos[0]));
      expect(groupedTodos[notExistsDate], null);
    });
  });
}
