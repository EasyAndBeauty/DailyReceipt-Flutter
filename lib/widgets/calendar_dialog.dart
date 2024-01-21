import 'package:flutter/material.dart';

class CalendarDialog extends StatelessWidget {
  const CalendarDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Text('dialog'),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
