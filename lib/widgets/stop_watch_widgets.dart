import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class StopWatchWidget extends StatefulWidget {
  const StopWatchWidget({super.key});

  @override
  State<StopWatchWidget> createState() => _StopWatchWidgetState();
}

class _StopWatchWidgetState extends State<StopWatchWidget> {
  int _counter = 0;
  Timer _timer = Timer(const Duration(milliseconds: 0), () {});
  bool _isRunning = false;
  List<String> _lapTimes = [];
  List<Duration> _lapTimesDuration = [];
  List<String> _overallTimes = [];

  // Start the stopwatch timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      setState(() {
        _counter = _counter + 1;
        print(_counter);
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _resetTimer() {
    if (_timer != null) {
      _timer.cancel();
      setState(() {
        _counter = 0;
        _isRunning = false;
        _lapTimes = [];
        _overallTimes = [];
        _lapTimesDuration = [];
      });
    }
  }

  void _lapTimer() {
    Duration duration = Duration(milliseconds: _counter);
    String formattedDuration = _formatDuration(duration);

    _lapTimesDuration.add(duration); // Add the current lap pushed duration

    // Check whether the laps time is the first or not
    if (_lapTimes.length == 0) {
      _lapTimes.add(formattedDuration);
      _overallTimes.add(formattedDuration);
    } else {
      // for other elapsed time
      int length_of_time_Duration =
          _lapTimesDuration.length; // get the length of the elapsed time
      Duration differences_elapsed_time = _lapTimesDuration[
              length_of_time_Duration - 1] -
          _lapTimesDuration[length_of_time_Duration -
              2]; // Calculate the differences between the current time and previous one
      String formattedDurationOthers =
          _formatDuration(differences_elapsed_time);
      _lapTimes.add(formattedDurationOthers);
      _overallTimes.add(formattedDuration);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String threeDigits(int n) => n.toString().padLeft(3, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds =
        threeDigits(duration.inMilliseconds.remainder(1000)).substring(0, 2);
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds";
  }

  @override
  Widget build(BuildContext context) {
    double widthOfWholeScreen = MediaQuery.of(context).size.width;
    double heaightOfWholeScreen = MediaQuery.of(context).size.height;

    Duration duration = Duration(milliseconds: _counter);
    String formattedDuration = _formatDuration(duration);

    return SizedBox(
      width: widthOfWholeScreen,
      height: heaightOfWholeScreen,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              formattedDuration,
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 122, 255),
                fontFamily: 'FredokaOne-Regular',
                fontSize: widthOfWholeScreen / 9,
              ),
            ), // time shower
            // Lap time table shower
            Container(
              margin: EdgeInsets.only(
                top: widthOfWholeScreen / 15,
                bottom: widthOfWholeScreen / 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Lap & Lap time & Overall time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AnimatedCrossFade(
                        firstChild: Text(
                          "Lap",
                          style: TextStyle(
                            fontFamily: 'FredokaOne-Regular',
                            fontSize: widthOfWholeScreen / 25,
                            color: const Color.fromARGB(255, 120, 120, 120),
                          ),
                        ),
                        secondChild: Text(
                          "",
                          style: TextStyle(
                            fontFamily: 'FredokaOne-Regular',
                            fontSize: widthOfWholeScreen / 25,
                            color: const Color.fromARGB(255, 120, 120, 120),
                          ),
                        ),
                        crossFadeState: _lapTimes.isNotEmpty
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 500),
                      ),
                      AnimatedCrossFade(
                        firstChild: Text(
                          "Lap time",
                          style: TextStyle(
                            fontFamily: 'FredokaOne-Regular',
                            fontSize: widthOfWholeScreen / 25,
                            color: const Color.fromARGB(255, 120, 120, 120),
                          ),
                        ),
                        secondChild: Text(
                          "",
                          style: TextStyle(
                            fontFamily: 'FredokaOne-Regular',
                            fontSize: widthOfWholeScreen / 25,
                            color: const Color.fromARGB(255, 120, 120, 120),
                          ),
                        ),
                        crossFadeState: _lapTimes.isNotEmpty
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 500),
                      ),
                      AnimatedCrossFade(
                        firstChild: Text(
                          "Overall time",
                          style: TextStyle(
                            fontFamily: 'FredokaOne-Regular',
                            fontSize: widthOfWholeScreen / 25,
                            color: const Color.fromARGB(255, 120, 120, 120),
                          ),
                        ),
                        secondChild: Text(
                          "",
                          style: TextStyle(
                            fontFamily: 'FredokaOne-Regular',
                            fontSize: widthOfWholeScreen / 25,
                            color: const Color.fromARGB(255, 120, 120, 120),
                          ),
                        ),
                        crossFadeState: _lapTimes.isNotEmpty
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 500),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: widthOfWholeScreen / 50,
                  ),
                  AnimatedCrossFade(
                    firstChild: Divider(
                      color: const Color.fromARGB(255, 196, 196, 196),
                      endIndent: widthOfWholeScreen / 15,
                      indent: widthOfWholeScreen / 15,
                      // height: 10,
                      thickness: 1,
                    ),
                    secondChild: Divider(
                      color: const Color.fromARGB(0, 196, 196, 196),
                      endIndent: widthOfWholeScreen / 15,
                      indent: widthOfWholeScreen / 15,
                      // height: 10,
                      thickness: 1,
                    ),
                    crossFadeState: _lapTimes.isNotEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: widthOfWholeScreen / 40,
                      // bottom: widthOfWholeScreen / 40,
                    ),
                    child: SizedBox(
                      width: widthOfWholeScreen,
                      height: widthOfWholeScreen / 1.1,
                      // Lap times gotten
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _lapTimes.length,
                        itemBuilder: (_, index) {
                          return SizedBox(
                            width: widthOfWholeScreen,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: widthOfWholeScreen / 20,
                                  ),
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                      fontSize: widthOfWholeScreen / 26,
                                      color: const Color.fromARGB(
                                          255, 142, 142, 142),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: widthOfWholeScreen / 20,
                                  ),
                                  child: Text(
                                    _lapTimes.length > index
                                        ? _lapTimes[index]
                                        : '',
                                    style: TextStyle(
                                      fontSize: widthOfWholeScreen / 26,
                                      color: const Color.fromARGB(
                                          255, 142, 142, 142),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: widthOfWholeScreen / 20,
                                  ),
                                  child: Text(
                                    _overallTimes.length > index
                                        ? _overallTimes[index]
                                        : '',
                                    style: TextStyle(
                                      fontSize: widthOfWholeScreen / 26,
                                      color: const Color.fromARGB(
                                          255, 142, 142, 142),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lap and reset butotn
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 255, 255),
                    ),
                    foregroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 69, 93, 119),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.only(
                        left: widthOfWholeScreen / 8,
                        right: widthOfWholeScreen / 8,
                        top: widthOfWholeScreen / 26,
                        bottom: widthOfWholeScreen / 26,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(widthOfWholeScreen),
                      ),
                    ),
                    shadowColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 255, 255),
                    ),
                    overlayColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  child: Text(
                    () {
                      if ((_isRunning)) {
                        return "Lap";
                      } else if ((!_isRunning) && (_counter > 0)) {
                        return "Reset";
                      } else {
                        return "Lap";
                      }
                    }(),
                    style: TextStyle(
                      fontFamily: 'FredokaOne-Regular',
                      fontSize: widthOfWholeScreen / 25,
                    ),
                  ),
                  onPressed: () {
                    if (_isRunning) {
                      _lapTimer();
                    } else {
                      _resetTimer();
                      _isRunning = false;
                    }
                  },
                ),
                // Fixed size space between lap button and start button
                SizedBox(
                  width: widthOfWholeScreen / 30,
                ),
                // Start and resume button
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(() {
                      if ((_isRunning)) {
                        return Colors.red;
                      } else if ((!_isRunning) && (_counter > 0)) {
                        return const Color.fromARGB(255, 0, 122, 255);
                      } else {
                        return const Color.fromARGB(255, 0, 122, 255);
                      }
                    }()),
                    foregroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 255, 255),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.only(
                        left: widthOfWholeScreen / 10,
                        right: widthOfWholeScreen / 10,
                        top: widthOfWholeScreen / 26,
                        bottom: widthOfWholeScreen / 26,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(widthOfWholeScreen),
                      ),
                    ),
                    shadowColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  child: Text(
                    () {
                      if ((_isRunning)) {
                        return "Stop";
                      } else if ((!_isRunning) && (_counter > 0)) {
                        return "Resume";
                      } else {
                        return "Start";
                      }
                    }(),
                    style: TextStyle(
                      fontFamily: 'FredokaOne-Regular',
                      fontSize: widthOfWholeScreen / 25,
                    ),
                  ),
                  onPressed: () {
                    if (_isRunning) {
                      _stopTimer();
                    } else {
                      _isRunning = true;
                      _startTimer();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
