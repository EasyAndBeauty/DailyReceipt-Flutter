import 'package:daily_receipt/models/calendar.dart';
import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/widgets/calendar_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final Todos todosProvider = Provider.of<Todos>(context, listen: false);
    final calendarProvider = Provider.of<Calendar>(context, listen: true);

    void addTodo() {
      if (controller.text.isEmpty) return;

      final newTodo = Todo(
        id: todosProvider.todos.length,
        content: controller.text,
        createdAt: DateTime.now().toUtc(),
        scheduledDate: calendarProvider.selectedDate,
      );

      todosProvider.add(newTodo);
      controller.clear();
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM')
                      .format(calendarProvider.selectedDate)
                      .toString(),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                IconButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const CalendarDialog()),
                  icon: const Icon(Icons.calendar_month_rounded),
                  iconSize: 28,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
            TextField(
              controller: controller,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              cursorColor: Theme.of(context).colorScheme.onBackground,
              decoration: InputDecoration(
                hintText: 'Collect moments, print memories.',
                hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary,
                    width: 1.5,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 32,
                  ),
                  color: Theme.of(context).colorScheme.onBackground,
                  onPressed: addTodo,
                ),
              ),
              onSubmitted: (_) => addTodo(),
            ),
          ],
        ),
      ),
    );
  }
}
