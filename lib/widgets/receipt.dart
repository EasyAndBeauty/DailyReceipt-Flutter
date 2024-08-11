import 'package:flutter/material.dart';
import 'package:daily_receipt/models/todos.dart';
import 'receipt_edge_clipper.dart';
import 'receipt_item.dart';
import 'receipt_text.dart';

class ReceiptComponent extends StatelessWidget {
  final List<Todo> todos;
  const ReceiptComponent(this.todos, {super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: ClipPath(
        clipper: ReceiptClipper(),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'RECEIPT',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ),
              const ReceiptText('September 6, 2022 11:12:16'),
              const Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Column(
                    children: todos
                        .map((todo) => ReceiptItem(todo.content, '0:01'))
                        .toList()),
              ),
              const Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Column(
                  children: [
                    ReceiptItem('ITEM COUNT :', todos.length.toString()),
                    const ReceiptItem('TOTAL :', '0:03'),
                  ],
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: ReceiptText(
                    'No "brand" is your friend.',
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Center(
                      child: Container(
                        width: 200,
                        height: 50,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: ReceiptText('https://www.daily-receipt.com'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
