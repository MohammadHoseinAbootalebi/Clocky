import 'dart:async';

import 'package:bloc/bloc.dart';

part 'is_started_timer_state.dart';

class IsStartedTimerCubit extends Cubit<IsStartedTimerState> {
  IsStartedTimerCubit()
      : super(IsStartedTimerState(
          isStarted: false,
          isStopped: false,
          countdownTimer: Timer(const Duration(milliseconds: 0), () {}),
          myDuration: const Duration(days: 0),
        ));

  void boolChangerTimerisStarted(bool currentBool) {
    // change the Is started boolean
    if (currentBool == true) {
      // if the passed bool is true, then the is Started boolean should be true
      state.isStarted = true;
    } else {
      // if the passed bool is false, then the is Started boolean should be false
      state.isStarted = false;
    }
  }

  void boolChangerTimerisStopped(bool currentBool) {
    // change the Is stopped boolean
    if (currentBool == true) {
      // if the passed bool is true, then the is Stopped boolean should be true
      state.isStopped = true;
    } else {
      // if the passed bool is false, then the is Stopped boolean should be false
      state.isStopped = false;
    }
  }

  // Start timer
  void startTimer() {
    state.countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state.isStarted = true;
      setCountDown();
    });
  }

  // counter down
  void setCountDown() {
    const reduceSecondsBy = 1;
    final seconds = state.myDuration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      state.isStarted = false;
      state.isStopped = false;

      state.countdownTimer.cancel();
    } else {
      state.myDuration = Duration(seconds: seconds);
      print(seconds);
    }

    state.isStarted = true;
  }

  // reset timer
  void resetTimer() {
    
  }

  // stop timer
  void stopTimer() {
    state.countdownTimer.cancel();
    state.isStopped = true;
    state.isStarted = true;
  }

  // number for timer stirngs
  String strDigits(int n) => n.toString().padLeft(2, '0');

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
