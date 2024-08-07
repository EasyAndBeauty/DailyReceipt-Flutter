import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      title: Text(title, style: theme.textTheme.titleMedium),
      content: Text(content, style: theme.textTheme.bodyMedium),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // 모달만 닫기
          },
          child: Text('취소', style: theme.textTheme.bodySmall),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop(); // 모달 닫기
          },
          child: Text('확인',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error)),
        ),
      ],
    );
  }
}
