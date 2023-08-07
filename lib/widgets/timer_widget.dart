import 'dart:async';

import 'package:clock_app/cubit/timer_cubit/is_started_timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _seconds = 0; // number for seconds picker
  int _minutes = 0; // number for minutes picker
  int _hours = 0; // number for hours picker
  bool isStarted = false; // to show or hide the number changer
  bool isStopped = false; // a boolean to show or not show some components

  Timer countdownTimer = Timer(const Duration(milliseconds: 0), () {});
  Duration myDuration = const Duration(days: 0);

  // Start timer
  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        isStarted = true;
        setCountDown();
      });
    });
  }

  // stop timer
  void stopTimer() {
    setState(() {
      countdownTimer.cancel();
      isStopped = true;
      isStarted = true;
    });
  }

  // reset timer
  void resetTimer() {
    setState(() {
      countdownTimer.cancel();
      myDuration = const Duration(days: 0);
      isStarted = false;
      isStopped = false;
    });
  }

  // counter down
  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        setState(() {
          isStarted = false;
          isStopped = false;

          countdownTimer.cancel();
        });
      } else {
        myDuration = Duration(seconds: seconds);
        isStarted = true;
        print(seconds);
      }
    });
  }

  // number for timer stirngs
  String strDigits(int n) => n.toString().padLeft(2, '0');

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void didChangeDependencies() {
    setState(() {
      isStarted = false;
      isStopped = false;
      countdownTimer.cancel();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double widthOfWholeScreen = MediaQuery.of(context).size.width;
    double heightOfWholeScreen = MediaQuery.of(context).size.height;

    Duration duration = myDuration;
    String formattedDuration = _formatDuration(duration);

    return SizedBox(
      width: widthOfWholeScreen,
      height: heightOfWholeScreen,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // number pickers
          AnimatedCrossFade(
            secondChild: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hours number picker
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Hours text above the hour number selector
                    Text(
                      "Hours",
                      style: TextStyle(
                        fontFamily: 'FredokaOne-Regular',
                        color: const Color.fromARGB(255, 146, 146, 146),
                        fontSize: widthOfWholeScreen / 25,
                      ),
                    ),
                    SizedBox(
                      height: widthOfWholeScreen / 10,
                    ),
                    // Hour number selector
                    Transform.scale(
                      scale: 1.2,
                      child: NumberPicker(
                        value: _hours,
                        minValue: 0,
                        maxValue: 99,
                        onChanged: (value) => setState(() {
                          _hours = value;
                          myDuration = Duration(
                              hours: _hours,
                              minutes: _minutes,
                              seconds: _seconds);
                        }),
                        textStyle: TextStyle(
                          fontSize: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 16
                              : heightOfWholeScreen / 16,
                          color: const Color.fromARGB(255, 176, 176, 176),
                        ),
                        itemHeight: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 9
                            : heightOfWholeScreen / 9,
                        selectedTextStyle: TextStyle(
                          fontSize: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 11
                              : heightOfWholeScreen / 11,
                          color: const Color.fromARGB(255, 0, 123, 255),
                          // fontWeight: FontWeight.bold,
                        ),
                        zeroPad: true,
                        infiniteLoop: true,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: widthOfWholeScreen / 7,
                  ),
                  child: Text(
                    ":",
                    style: TextStyle(
                      fontSize: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 9
                          : heightOfWholeScreen / 9,
                      color: const Color.fromARGB(255, 0, 123, 255),
                    ),
                  ),
                ),
                // Minutes number picker
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Minutes text above the minutes number selector
                    Text(
                      "Minutes",
                      style: TextStyle(
                        fontFamily: 'FredokaOne-Regular',
                        color: const Color.fromARGB(255, 146, 146, 146),
                        fontSize: widthOfWholeScreen / 25,
                      ),
                    ),
                    SizedBox(
                      height: widthOfWholeScreen / 10,
                    ),
                    // Minutes number selector
                    Transform.scale(
                      scale: 1.2,
                      child: NumberPicker(
                        key: const Key("Minutes"),
                        value: _minutes,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (value) => setState(() {
                          _minutes = value;
                          myDuration = Duration(
                              hours: _hours,
                              minutes: _minutes,
                              seconds: _seconds);
                        }),
                        textStyle: TextStyle(
                          fontSize: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 16
                              : heightOfWholeScreen / 16,
                          color: const Color.fromARGB(255, 176, 176, 176),
                        ),
                        itemHeight: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 9
                            : heightOfWholeScreen / 9,
                        selectedTextStyle: TextStyle(
                          fontSize: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 11
                              : heightOfWholeScreen / 11,
                          color: const Color.fromARGB(255, 0, 123, 255),
                          // fontWeight: FontWeight.bold,
                        ),
                        zeroPad: true,
                        infiniteLoop: true,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: widthOfWholeScreen / 7,
                  ),
                  child: Text(
                    ":",
                    style: TextStyle(
                      fontSize: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 9
                          : heightOfWholeScreen / 9,
                      color: const Color.fromARGB(255, 0, 123, 255),
                    ),
                  ),
                ),
                // Seconds number picker
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Seconds text above the seconds number selector
                    Text(
                      "Seconds",
                      style: TextStyle(
                        fontFamily: 'FredokaOne-Regular',
                        color: const Color.fromARGB(255, 146, 146, 146),
                        fontSize: widthOfWholeScreen / 25,
                      ),
                    ),
                    SizedBox(
                      height: widthOfWholeScreen / 10,
                    ),
                    // Seconds number selector
                    Transform.scale(
                      scale: 1.2,
                      child: NumberPicker(
                        key: const Key("Seconds"),
                        value: _seconds,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (value) => setState(() {
                          _seconds = value;
                          myDuration = Duration(
                              hours: _hours,
                              minutes: _minutes,
                              seconds: _seconds);
                        }),
                        textStyle: TextStyle(
                          fontSize: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 16
                              : heightOfWholeScreen / 16,
                          color: const Color.fromARGB(255, 176, 176, 176),
                        ),
                        itemHeight: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 9
                            : heightOfWholeScreen / 9,
                        selectedTextStyle: TextStyle(
                          fontSize: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 11
                              : heightOfWholeScreen / 11,
                          color: const Color.fromARGB(255, 0, 123, 255),
                          // fontWeight: FontWeight.bold,
                        ),
                        zeroPad: true,
                        infiniteLoop: true,
                      ),
                    ),
                  ],
                ),
                // button
              ],
            ),
            firstChild: Text(
              formattedDuration,
              style: TextStyle(
                fontSize: widthOfWholeScreen / 6,
                fontFamily: 'FredokaOne-Regular',
                color: const Color.fromARGB(255, 0, 123, 255),
              ),
            ),
            crossFadeState: isStarted
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 500),
          ),
          // fixed empty sized box
          SizedBox(
            height: widthOfWholeScreen / 1.5,
          ),
          // Set button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedCrossFade(
                firstChild: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 209, 209, 209),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.only(
                        top: widthOfWholeScreen / 20,
                        bottom: widthOfWholeScreen / 20,
                        left: widthOfWholeScreen / 9,
                        right: widthOfWholeScreen / 9,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(widthOfWholeScreen),
                      ),
                    ),
                  ),
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 133, 133, 133),
                      fontFamily: "FredokaOne-Regular",
                      fontSize: widthOfWholeScreen / 20,
                    ),
                  ),
                  onPressed: () {
                    resetTimer();
                  },
                ),
                secondChild: const Text(""),
                crossFadeState: isStarted
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 500),
              ),
              AnimatedCrossFade(
                firstChild: SizedBox(
                  width: widthOfWholeScreen / 15,
                ),
                secondChild: const SizedBox(width: 0),
                crossFadeState: isStarted
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 500),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(() {
                    if (isStarted == true && isStopped == false) {
                      return const Color.fromARGB(255, 255, 0, 0); // Stop
                    } else if (isStarted == true && isStopped == true) {
                      return const Color.fromARGB(255, 0, 123, 255); // Resume
                    } else if (isStarted == false &&
                        isStopped == false &&
                        _hours == 0 &&
                        _minutes == 0 &&
                        _seconds == 0) {
                      return const Color.fromARGB(
                          255, 167, 167, 167); // unenable
                    } else {
                      return const Color.fromARGB(255, 0, 123, 255); // Start
                    }
                  }()),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.only(
                      top: widthOfWholeScreen / 20,
                      bottom: widthOfWholeScreen / 20,
                      left: widthOfWholeScreen / 9,
                      right: widthOfWholeScreen / 9,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widthOfWholeScreen),
                    ),
                  ),
                ),
                child: Text(
                  () {
                    if (isStarted == true && isStopped == false) {
                      return "Stop";
                    } else if (isStarted == true && isStopped == true) {
                      return "Resume";
                    } else {
                      return "Start";
                    }
                  }(),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "FredokaOne-Regular",
                    fontSize: widthOfWholeScreen / 20,
                  ),
                ),
                onPressed: () {
                  // This is the first time so the start timer should be called
                  if (isStarted == false && isStopped == false) {
                    if ((_hours != 0) || (_minutes != 0) || (_seconds != 0)) {
                      setState(() {
                        startTimer();
                        myDuration = Duration(
                            hours: _hours,
                            minutes: _minutes,
                            seconds: _seconds);
                      });
                      BlocProvider.of<IsStartedTimerCubit>(context)
                          .boolChangerTimerisStarted(true);
                    }
                  }
                  // This is when the timer is started but it is stopped so the pressing button should call the start timer method
                  else if (isStarted == true && isStopped == true) {
                    setState(() {
                      startTimer();
                      isStopped = false;
                    });
                  }
                  // This is when the timer is started but it is not stoppped so the stop timer method should be called
                  else if (isStarted == true && isStopped == false) {
                    stopTimer();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
