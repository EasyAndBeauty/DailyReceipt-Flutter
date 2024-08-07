import 'package:flutter/material.dart';

class ReceiptComponent extends StatelessWidget {
  const ReceiptComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'RECEIPT',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            const ReceiptText('September 6, 2022 11:12:16'),
            const Divider(),
            const ReceiptItem('new Plus Icon', '0:01'),
            const ReceiptItem('new Check Icon', '0:01'),
            const ReceiptItem('Hey Test Someth...', '0:01'),
            const Divider(),
            const ReceiptItem('ITEM COUNT :', '3'),
            const ReceiptItem('TOTAL :', '0:03'),
            const Divider(),
            const Center(
              child: ReceiptText(
                'No "brand" is your friend.',
              ),
            ),
            const SizedBox(height: 16),
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
    );
  }
}

class ReceiptItem extends StatelessWidget {
  final String name;
  final String value;

  const ReceiptItem(this.name, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReceiptText(name),
          ReceiptText(value),
        ],
      ),
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
