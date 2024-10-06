import 'package:flutter/material.dart';

enum ButtonType { basic, danger, disabled }

class TextButtonCustom extends StatelessWidget {
  final String text;
  final ButtonType type;
  final bool isBold;
  final VoidCallback? onPressed;

  const TextButtonCustom({
    super.key,
    required this.text,
    required this.type,
    required this.isBold,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor;
    switch (type) {
      case ButtonType.danger:
        textColor = Theme.of(context).colorScheme.error;
        break;
      case ButtonType.disabled:
        textColor = Theme.of(context).colorScheme.secondary;
        break;
      case ButtonType.basic:
      default:
        textColor = Theme.of(context).colorScheme.primary;
        break;
    }

    return TextButton(
      onPressed: type == ButtonType.disabled ? null : onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
