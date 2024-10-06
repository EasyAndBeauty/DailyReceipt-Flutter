import 'package:daily_receipt/models/todo_timer.dart';
import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/widgets/buttons.dart';
import 'package:daily_receipt/widgets/confirmation_dialog.dart';
import 'package:daily_receipt/widgets/dashed_line_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TimerBottomSheet extends StatelessWidget {
  static const double _bottomSheetHeight = 0.95;
  static const double _borderRadius = 30;
  static const double _borderWidth = 1;
  static const double _svgWidth = 28;
  static const double _svgHeight = 16;
  static const double _verticalPadding = 32.0;
  static const double _horizontalPadding = 16.0;
  static const double _spaceBetweenElements = 8.0;
  static const double _timerFontSize = 92;

  final Todo todo;
  final Function(Duration focusedTime) onCompleted;

  const TimerBottomSheet({
    Key? key,
    required this.todo,
    required this.onCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoTimer = Provider.of<TodoTimer>(context);
    final theme = Theme.of(context);

    return PopScope(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * _bottomSheetHeight,
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        decoration: _buildBottomSheetDecoration(theme),
        child: SafeArea(
          child: Column(
            children: [
              _buildCloseButton(context, todoTimer),
              Expanded(
                child: Column(
                  children: [
                    const Spacer(flex: 1),
                    Flexible(
                      flex: 3,
                      child: _buildTimerContent(context, todoTimer, theme),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
              _buildDashedLine(theme),
              Padding(
                padding: const EdgeInsets.all(_horizontalPadding),
                child:
                    _buildControlButtons(todoTimer.state, context, todoTimer),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBottomSheetDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.primary,
      border: Border(
        top: BorderSide(
          color: theme.colorScheme.secondary,
          width: _borderWidth,
        ),
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(_borderRadius),
        topRight: Radius.circular(_borderRadius),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context, TodoTimer todoTimer) {
    return GestureDetector(
      onTap: () => _handleCloseButtonTap(context, todoTimer),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
        child: SvgPicture.asset(
          'assets/icons/arrow_down.svg',
          width: _svgWidth,
          height: _svgHeight,
        ),
      ),
    );
  }

  void _handleCloseButtonTap(BuildContext context, TodoTimer todoTimer) {
    if (todoTimer.state == TimerState.idle) {
      Navigator.of(context).pop();
    } else {
      _showStopConfirmationDialog(context, todoTimer);
    }
  }

  Widget _buildTimerContent(
      BuildContext context, TodoTimer todoTimer, ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'TODO: ${todo.content}',
          style: _getBodyTextStyle(theme, todoTimer.state, false),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: _spaceBetweenElements),
        if (todoTimer.state == TimerState.idle)
          Text(
            '집중한 시간: ${todo.accumulatedTime.inMinutes}분',
            style: _getBodyTextStyle(theme, todoTimer.state, false),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: _verticalPadding),
        Text(
          _formatTime(todoTimer.focusedTime),
          style: _getTimerTextStyle(theme, todoTimer.state),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: _spaceBetweenElements * 2),
        SizedBox(
          width: double.infinity,
          child: Text(
            _getMessageByTimerState(todoTimer.state),
            style: _getBodyTextStyle(theme, todoTimer.state, false),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildDashedLine(ThemeData theme) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: DashedLinePainter(color: theme.colorScheme.onPrimary),
    );
  }

  Widget _buildControlButtons(
      TimerState state, BuildContext context, TodoTimer todoTimer) {
    switch (state) {
      case TimerState.idle:
        return _buildIdleButtons(context, todoTimer);
      case TimerState.running:
        return _buildRunningButtons(context, todoTimer);
      case TimerState.paused:
        return _buildPausedButtons(context, todoTimer);
      case TimerState.completed:
        return _buildCompletedButtons(context, todoTimer);
    }
  }

  Widget _buildIdleButtons(BuildContext context, TodoTimer todoTimer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CancelButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.error,
        ),
        PlayButton(
          onPressed: () => todoTimer.onEvent(TimerEvent.start),
        ),
      ],
    );
  }

  Widget _buildRunningButtons(BuildContext context, TodoTimer todoTimer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StopButton(
          onPressed: () => _showStopConfirmationDialog(context, todoTimer),
        ),
        PauseButton(
          onPressed: () => todoTimer.onEvent(TimerEvent.pause),
        ),
      ],
    );
  }

  Widget _buildPausedButtons(BuildContext context, TodoTimer todoTimer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StopButton(
          onPressed: () => _showStopConfirmationDialog(context, todoTimer),
        ),
        PlayButton(
          onPressed: () => todoTimer.onEvent(TimerEvent.start),
        ),
      ],
    );
  }

  Widget _buildCompletedButtons(BuildContext context, TodoTimer todoTimer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StopButton(
          onPressed: () => _showStopConfirmationDialog(context, todoTimer),
        ),
        PlayButton(
          onPressed: () => todoTimer.onEvent(TimerEvent.reset),
        ),
      ],
    );
  }

  String _getMessageByTimerState(TimerState state) {
    switch (state) {
      case TimerState.idle:
        return 'Play 버튼을 눌러\n타이머를 시작해보세요.';
      case TimerState.running:
        return '집중한 이 시간이\n빛나는 내일을 만들어 줄 거예요.';
      case TimerState.paused:
        return '다시 집중하고 싶다면\nPlay 버튼을 눌러주세요.';
      case TimerState.completed:
        return '훌륭해요! 오늘의 집중이\n내일의 성과로 이어질 거예요.';
    }
  }

  Color _getColorByTimerState(
      ThemeData theme, TimerState state, bool isReversed) {
    Color activeColor =
        isReversed ? theme.colorScheme.onPrimary : theme.colorScheme.secondary;
    Color inactiveColor =
        isReversed ? theme.colorScheme.secondary : theme.colorScheme.onPrimary;

    switch (state) {
      case TimerState.idle:
      case TimerState.paused:
        return inactiveColor;
      case TimerState.running:
      case TimerState.completed:
        return activeColor;
    }
  }

  TextStyle? _getBodyTextStyle(
      ThemeData theme, TimerState state, bool isReversed) {
    return theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w700,
      height: 18 / 14,
      letterSpacing: -0.005 * 14,
      color: _getColorByTimerState(theme, state, isReversed),
    );
  }

  TextStyle? _getTimerTextStyle(ThemeData theme, TimerState state) {
    return theme.textTheme.headlineLarge?.copyWith(
      fontFamily: 'Courier Prime',
      fontSize: _timerFontSize,
      fontWeight: FontWeight.w400,
      height: 103 / 92,
      letterSpacing: -0.005 * 92,
      color: _getColorByTimerState(theme, state, true),
    );
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _showStopConfirmationDialog(BuildContext context, TodoTimer todoTimer) {
    showDialog(
      context: Navigator.of(context, rootNavigator: true).context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'TODO: ${todo.content}',
          content: '타이머를 중지할까요?',
          onConfirm: () {
            todoTimer.onEvent(TimerEvent.complete);
            onCompleted(todoTimer.focusedTime);
          },
        );
      },
    );
  }
}
