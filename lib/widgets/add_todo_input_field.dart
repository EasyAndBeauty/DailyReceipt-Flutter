import 'package:daily_receipt/models/calendar.dart';
import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/services/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddTodoInputField extends StatelessWidget {
  AddTodoInputField({super.key});

  final TextEditingController addController = TextEditingController();
  final Uuid _uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Todos todosProvider = Provider.of<Todos>(context, listen: true);
    final calendarProvider = Provider.of<Calendar>(context, listen: true);

    void addTodo() {
      if (addController.text.isEmpty) return;

      final newTodo = Todo(
        id: _uuid.v4(),
        content: addController.text,
        createdAt: DateTime.now().toUtc(),
        scheduledDate: calendarProvider.selectedDate,
      );

      todosProvider.add(newTodo);
      addController.clear();
    }

    return TextField(
      controller: addController,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      cursorColor: theme.colorScheme.onSurface,
      decoration: InputDecoration(
        hintText: tr.key2,
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.secondary,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: theme.colorScheme.tertiary,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.add_rounded,
            size: 32,
          ),
          color: theme.colorScheme.onSurface,
          onPressed: addTodo,
        ),
      ),
      onSubmitted: (_) => addTodo(),
    );
  }
}
