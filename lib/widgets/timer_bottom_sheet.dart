import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_receipt/models/todo_timer.dart';
import 'package:daily_receipt/widgets/confirmation_dialog.dart';

class TimerBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoTimer = Provider.of<TodoTimer>(context);
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      color: theme.colorScheme.primary,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'TODO: ${todoTimer.todoTitle}',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onPrimary),
          ),
          const SizedBox(height: 20),
          Text(
            '집중 시간: ${(todoTimer.currentFocusedTime.inMinutes % 60).toString().padLeft(2, '0')}:${(todoTimer.currentFocusedTime.inSeconds % 60).toString().padLeft(2, '0')}',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onPrimary),
          ),
          const SizedBox(height: 10),
          Text(
            '조금 더 집중한 이 시간이\n더 빛나는 내일을 만들어 줄 거예요.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onPrimary),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  if (todoTimer.state == TimerState.running ||
                      todoTimer.state == TimerState.paused) {
                    _showStopConfirmationDialog(context, todoTimer);
                  }
                },
                child: Text(
                  'Stop',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (todoTimer.state == TimerState.idle ||
                      todoTimer.state == TimerState.paused) {
                    todoTimer.onEvent(TimerEvent.start);
                  } else if (todoTimer.state == TimerState.running) {
                    todoTimer.onEvent(TimerEvent.pause);
                  }
                },
                child: Text(
                  todoTimer.state == TimerState.running ? 'Pause' : 'Start',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showStopConfirmationDialog(BuildContext context, TodoTimer todoTimer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: '타이머 중지',
          content: '정말로 타이머를 중지하시겠습니까?',
          onConfirm: () {
            todoTimer.onEvent(TimerEvent.complete);
            Navigator.of(context).pop(); // 바텀시트 닫기
          },
        );
      },
    );
  }
}
