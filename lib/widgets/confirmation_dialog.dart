import 'package:daily_receipt/widgets/buttons.dart';
import 'package:daily_receipt/widgets/dashed_line_painter.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  static const double _dialogWidth = 400;
  static const double _dashedLineHeight = 1;

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
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.onSurface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _dialogWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              _buildTitle(theme),
              const SizedBox(height: 20),
              _buildContent(theme),
              const SizedBox(height: 36),
              _buildDashedLine(theme),
              const SizedBox(height: 8),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          )),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Text(
      content,
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDashedLine(ThemeData theme) {
    return CustomPaint(
      size: const Size(double.infinity, _dashedLineHeight),
      painter: DashedLinePainter(
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}
