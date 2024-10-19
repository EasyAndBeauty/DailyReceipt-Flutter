import 'package:flutter/material.dart';

import 'receipt_text.dart';

class ReceiptItem extends StatelessWidget {
  final String name;
  final String value;

  const ReceiptItem(this.name, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ReceiptText(name),
        ),
        ReceiptText(value),
      ],
    );
  }
}
