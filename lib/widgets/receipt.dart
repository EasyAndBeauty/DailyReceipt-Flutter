import 'package:flutter/material.dart';
import 'package:daily_receipt/models/todos.dart';

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

class ReceiptItem extends StatelessWidget {
  final String name;
  final String value;

  const ReceiptItem(this.name, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReceiptText(name),
        ReceiptText(value),
      ],
    );
  }
}

class ReceiptText extends StatelessWidget {
  final String text;

  const ReceiptText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}

class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const wavelength = 14.0;
    const amplitude = 5.0;

    // 상단 톱니
    path.moveTo(0, amplitude);
    for (var i = 0; i < size.width / wavelength; i++) {
      path.lineTo((i + 0.5) * wavelength, 0);
      path.lineTo((i + 1) * wavelength, amplitude);
    }

    // 오른쪽 변
    path.lineTo(size.width, size.height - amplitude);

    // 하단 톱니
    for (var i = size.width / wavelength; i > 0; i--) {
      path.lineTo((i - 0.5) * wavelength, size.height);
      path.lineTo((i - 1) * wavelength, size.height - amplitude);
    }

    // 왼쪽 변
    path.lineTo(0, amplitude);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
