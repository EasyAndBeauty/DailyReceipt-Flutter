import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum TimerState { idle, running, paused, completed }

enum TimerEvent { start, pause, complete, reset }

class TodoTimer extends ChangeNotifier {
  Duration _focusedTime = Duration.zero;
  TimerState _state = TimerState.idle;
  Ticker? _ticker;
  Duration _lastTickerTime = Duration.zero;
  bool _isDisposed = false;

  TodoTimer();

  TimerState get state => _state;
  Duration get focusedTime => _focusedTime;

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
    _ticker ??= Ticker(_onTick);
    _lastTickerTime = Duration.zero;
    _ticker!.start();
  }

  void _onTick(Duration elapsed) {
    final tickDuration = elapsed - _lastTickerTime;
    _focusedTime += tickDuration;
    _lastTickerTime = elapsed;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _pauseTimer() {
    _state = TimerState.paused;
    _ticker?.stop();
  }

  void _completeTimer() {
    _state = TimerState.completed;
    _ticker?.stop();
  }

  void _resetTimer() {
    _state = TimerState.idle;
    _focusedTime = Duration.zero;
    _ticker?.stop();
    _lastTickerTime = Duration.zero;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _ticker?.dispose();
    super.dispose();
  }
}
