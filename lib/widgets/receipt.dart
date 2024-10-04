import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'receipt_edge_clipper.dart';
import 'receipt_item.dart';
import 'receipt_text.dart';

class ReceiptComponent extends StatelessWidget {
  final List<Todo> todos;
  final DateTime date;
  const ReceiptComponent(this.todos, this.date, {super.key});

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Duration getTotalAccumulatedTime(List<Todo> todos) =>
      todos.fold(Duration.zero, (total, todo) => total + todo.accumulatedTime);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: ClipPath(
        clipper: ReceiptClipper(),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/paper_texture.webp',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
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
                  ReceiptText(DateFormat('MMMM d, y').format(date.toLocal())),
                  DashedDivider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: todos.isNotEmpty
                        ? Column(
                            children: todos
                                .map((todo) => ReceiptItem(todo.content,
                                    formatDuration(todo.accumulatedTime)))
                                .toList(),
                          )
                        : const Center(
                            child: ReceiptText('No todos for this day'),
                          ),
                  ),
                  DashedDivider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: Column(
                      children: [
                        ReceiptItem('ITEM COUNT :', todos.length.toString()),
                        ReceiptItem(
                          'TOTAL :',
                          formatDuration(getTotalAccumulatedTime(todos)),
                        )
                      ],
                    ),
                  ),
                  DashedDivider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Column(
                        children: [
                          ReceiptText(
                            'Print Your Time',
                          ),
                          ReceiptText(
                            'Daily Receipt',
                          ),
                        ],
                      ),
                    ),
                  ),
                  DashedDivider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Image.asset(
                              'assets/barcode.png',
                              fit: BoxFit.cover,
                              color: Theme.of(context).colorScheme.primary,
                              height: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: ReceiptText('https://www.daily-receipt.com'),
                        ),
                      ],
                    ),
                  ),
                  DashedDivider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
