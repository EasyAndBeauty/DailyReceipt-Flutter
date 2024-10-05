import 'package:daily_receipt/widgets/dashed_line_painter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/widgets/buttons.dart';
import 'receipt_top_clipper.dart';

class TodoActionBottomSheet extends StatelessWidget {
  final Todo todo;
  final VoidCallback onEdit;

  const TodoActionBottomSheet({
    Key? key,
    required this.todo,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipPath(
      clipper: ReceiptTopClipper(), // Clipper 적용
      child: Material(
        color: theme.colorScheme.surface,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitle(theme),
                const SizedBox(height: 8),
                _buildDashedLine(theme),
                Row(children: [
                  Expanded(
                    child: EditButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onEdit();
                      },
                      color: theme.colorScheme.primary, // Edit 버튼 색상
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DeleteButton(
                      onPressed: () {
                        Provider.of<Todos>(context, listen: false)
                            .remove(todo.id);
                        Navigator.pop(context);
                      },
                      color: theme.colorScheme.error, // Delete 버튼 색상
                    ),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the title
  Widget _buildTitle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        'TODO: ${todo.content}',
        style: theme.textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDashedLine(ThemeData theme) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: DashedLinePainter(color: theme.colorScheme.primary),
    );
  }
}
