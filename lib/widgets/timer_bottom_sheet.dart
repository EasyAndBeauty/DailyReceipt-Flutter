import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_receipt/models/todo_timer.dart';
import 'package:daily_receipt/widgets/confirmation_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:daily_receipt/widgets/buttons.dart';

class TimerBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoTimer = Provider.of<TodoTimer>(context);
    final theme = Theme.of(context);

    String _getMessageByTimerState(TimerState state) {
      switch (state) {
        case TimerState.idle:
          return 'Play 버튼을 눌러 타이머를 시작해보세요.';
        case TimerState.running:
          return '조금 더 집중한 이 시간이\n더 빛나는 내일을 만들어 줄 거예요.';
        case TimerState.paused:
          return '다시 집중하고 싶다면\nStart 버튼을 눌러주세요.';
        case TimerState.completed:
          return '훌륭해요! 오늘의 집중이\n내일의 성과로 이어질 거예요.';
      }
    }

    Color _getColorByTimerState(TimerState state, bool isReversed) {
      Color activeColor = isReversed
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.secondary;
      Color inactiveColor = isReversed
          ? theme.colorScheme.secondary
          : theme.colorScheme.onPrimary;

      switch (state) {
        case TimerState.idle:
          return inactiveColor;
        case TimerState.running:
          return activeColor;
        case TimerState.paused:
          return inactiveColor;
        case TimerState.completed:
          return activeColor;
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.95,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.secondary,
            width: 1,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: SvgPicture.string(
                  '''
                  <svg width="28" height="16" viewBox="0 0 28 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M2 2L14 14L26 2" stroke="#AAAAAA" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                  ''',
                  width: 28,
                  height: 16,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Spacer(flex: 1), // 부모의 높이의 1/4만큼의 공간을 차지
                  Flexible(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'TODO : ${todoTimer.todoTitle}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 18 / 14,
                            letterSpacing: -0.005 * 14,
                            color: theme.colorScheme.onPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        todoTimer.state == TimerState.idle
                            ? Text(
                                '집중한 시간 : ${todoTimer.totalFocusedTime.inMinutes}분',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 18 / 14,
                                  letterSpacing: -0.005 * 14,
                                  color: _getColorByTimerState(
                                      todoTimer.state, false),
                                ),
                                textAlign: TextAlign.center,
                              )
                            : const SizedBox(),
                        const SizedBox(height: 32),
                        Text(
                          '${(todoTimer.currentFocusedTime.inMinutes % 60).toString().padLeft(2, '0')}:${(todoTimer.currentFocusedTime.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontFamily: 'Courier Prime',
                            fontSize: 92,
                            fontWeight: FontWeight.w400,
                            height: 103 / 92,
                            letterSpacing: -0.005 * 92,
                            color: _getColorByTimerState(todoTimer.state, true),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 184,
                          child: Text(
                            _getMessageByTimerState(todoTimer.state),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 20 / 16,
                              letterSpacing: -0.005 * 16,
                              color:
                                  _getColorByTimerState(todoTimer.state, false),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1), // 나머지 공간 채우기
                ],
              ),
            ),
            CustomPaint(
              size: const Size(double.infinity, 1),
              painter: DashedLinePainter(color: theme.colorScheme.onPrimary),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StopButton(
                    onPressed: () {
                      if (todoTimer.state == TimerState.running ||
                          todoTimer.state == TimerState.paused) {
                        _showStopConfirmationDialog(context, todoTimer);
                      }
                    },
                  ),
                  PlayButton(
                    onPressed: () {
                      if (todoTimer.state == TimerState.idle ||
                          todoTimer.state == TimerState.paused) {
                        todoTimer.onEvent(TimerEvent.start);
                      } else if (todoTimer.state == TimerState.running) {
                        todoTimer.onEvent(TimerEvent.pause);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStopConfirmationDialog(BuildContext context, TodoTimer todoTimer) {
    showDialog(
      context: Navigator.of(context, rootNavigator: true).context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'TODO: ${todoTimer.todoTitle}',
          content: '타이머를 중지할까요?',
          onConfirm: () {
            todoTimer.onEvent(TimerEvent.complete);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
