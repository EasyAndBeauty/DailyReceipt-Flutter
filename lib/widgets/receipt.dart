import 'package:daily_receipt/widgets/dashed_divider.dart';
import 'package:flutter/material.dart';
import 'package:daily_receipt/models/todos.dart';
import 'receipt_edge_clipper.dart';
import 'receipt_item.dart';
import 'receipt_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReceiptComponent extends StatelessWidget {
  final List<Todo> todos;
  const ReceiptComponent(this.todos, {super.key});

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
                  const ReceiptText('September 6, 2022 11:12:16'),
                  DashedDivider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: Column(
                        children: todos
                            .map((todo) => ReceiptItem(todo.content, '0:01'))
                            .toList()),
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
                        const ReceiptItem('TOTAL :', '0:03'),
                      ],
                    ),
                  ),
                  DashedDivider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: ReceiptText(
                        'No "brand" is your friend.',
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
                                horizontal: 12, vertical: 16),
                            child: SvgPicture.asset(
                              'assets/barcode.svg',
                              height: 50,
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
