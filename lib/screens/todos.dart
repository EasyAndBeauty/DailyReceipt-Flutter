import 'package:daily_receipt/models/todos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final Todos todosProvider = Provider.of<Todos>(context, listen: false);

    void addTodo() {
      if (controller.text.isEmpty) return;

      final newTodo = Todo(
        id: todosProvider.todos.length,
        content: controller.text,
        createdAt: DateTime.now().toUtc(),
      );

      todosProvider.add(newTodo);
      controller.clear();
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
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
