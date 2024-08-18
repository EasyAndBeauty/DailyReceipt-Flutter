import 'dart:async';
import 'package:flutter/material.dart';

enum TimerState { idle, running, paused, completed }

enum TimerEvent { start, pause, complete, reset }

class TodoTimer extends ChangeNotifier {
  static const Duration _timerInterval = Duration(seconds: 1);

  Duration focusedTime = Duration.zero;
  TimerState _state = TimerState.idle;
  Timer? _timer;
  bool _isDisposed = false;

  TodoTimer();

  TimerState get state => _state;

  void onEvent(TimerEvent event) {
    _transitionState(event);
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _transitionState(TimerEvent event) {
    if (_isDisposed) return;

    switch (_state) {
      case TimerState.idle:
        if (event == TimerEvent.start) {
          _startTimer();
        }
        break;
      case TimerState.running:
        if (event == TimerEvent.pause) {
          _pauseTimer();
        } else if (event == TimerEvent.complete) {
          _completeTimer();
        }
        break;
      case TimerState.paused:
        if (event == TimerEvent.start) {
          _startTimer();
        } else if (event == TimerEvent.complete) {
          _completeTimer();
        }
        break;
      case TimerState.completed:
        if (event == TimerEvent.reset) {
          _resetTimer();
        }
        break;
    }
  }

  void _startTimer() {
    _state = TimerState.running;
    _timer = Timer.periodic(_timerInterval, _updateTimer);
  }

  void _updateTimer(Timer timer) {
    focusedTime += _timerInterval;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _pauseTimer() {
    _state = TimerState.paused;
    _timer?.cancel();
  }

  void _completeTimer() {
    _state = TimerState.completed;
    _timer?.cancel();
  }

  void _resetTimer() {
    _state = TimerState.idle;
    focusedTime = Duration.zero;
    _timer?.cancel();
  }

  Duration getFocusedTime() => focusedTime;

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
