part of 'is_started_timer_cubit.dart';

class IsStartedTimerState {
  bool isStarted; // to show or hide the number changer
  bool isStopped; // a boolean to show or not show some components

  Timer countdownTimer;
  Duration myDuration;

  IsStartedTimerState({
    required this.isStarted,
    required this.isStopped,
    required this.countdownTimer,
    required this.myDuration,
  });
}
