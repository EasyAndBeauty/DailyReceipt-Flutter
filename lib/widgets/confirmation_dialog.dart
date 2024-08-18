import 'package:flutter/material.dart';
import 'package:daily_receipt/widgets/dashed_line_painter.dart';
import 'package:daily_receipt/widgets/buttons.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SizedBox(
        width: 400, // 고정 너비
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
                children: [
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CustomPaint(
                size: const Size(double.infinity, 1),
                painter: DashedLinePainter(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  CancelButton(
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  StopButton(
                    onPressed: () {
                      onConfirm();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
