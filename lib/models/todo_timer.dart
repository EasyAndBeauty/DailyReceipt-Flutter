import 'dart:async';
import 'package:flutter/material.dart';

// Define the states
enum TimerState { idle, running, paused, completed }

// Define the events
enum TimerEvent { start, pause, complete, reset }

class TodoTimer extends ChangeNotifier {
  Duration focusedTime = Duration.zero;
  TimerState _state = TimerState.idle;
  Timer? _timer;
  bool _isDisposed = false;

  TodoTimer();

  TimerState get state => _state;

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

  void onEvent(TimerEvent event) {
    _transitionState(event);
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _startTimer() {
    _state = TimerState.running;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      focusedTime += const Duration(seconds: 1);
      if (!_isDisposed) {
        notifyListeners();
      }
    });
    print('Timer started.');
  }

  void _pauseTimer() {
    _state = TimerState.paused;
    _timer?.cancel();
    print('Timer paused.');
  }

  void _completeTimer() {
    _state = TimerState.completed;
    _timer?.cancel();
    print('Timer completed.');
  }

  void _resetTimer() {
    _state = TimerState.idle;
    focusedTime = Duration.zero;
    _timer?.cancel();
    print('Timer reset.');
  }

  Duration getFocusedTime() {
    return focusedTime;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
