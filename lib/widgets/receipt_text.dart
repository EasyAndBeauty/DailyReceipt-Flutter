import 'package:flutter/material.dart';

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
