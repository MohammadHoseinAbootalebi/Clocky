import 'dart:async';

import 'package:clock_app/cubit/timer_cubit/is_started_timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

class TimerWidgetBloc extends StatefulWidget {
  const TimerWidgetBloc({super.key});

  @override
  State<TimerWidgetBloc> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidgetBloc> {
  int _seconds = 0; // number for seconds picker
  int _minutes = 0; // number for minutes picker
  int _hours = 0; // number for hours picker

  @override
  Widget build(BuildContext context) {
    double widthOfWholeScreen = MediaQuery.of(context).size.width;
    double heightOfWholeScreen = MediaQuery.of(context).size.height;

    return SizedBox(
      width: widthOfWholeScreen,
      height: heightOfWholeScreen,
      child: BlocBuilder<IsStartedTimerCubit, IsStartedTimerState>(
        builder: (context, state) {

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // number pickers
              (state.isStarted)
                  ? Text(
                       BlocProvider.of<IsStartedTimerCubit>(context).formatDuration(state.myDuration),
                      style: TextStyle(
                        fontSize: widthOfWholeScreen / 6,
                        fontFamily: 'FredokaOne-Regular',
                        color: const Color.fromARGB(255, 0, 123, 255),
                      ),
                    )
                  : Row(
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
                              scale: 1.3,
                              child: NumberPicker(
                                value: _hours,
                                minValue: 0,
                                maxValue: 99,
                                onChanged: (value) => setState(() {
                                  _hours = value;
                                  state.myDuration = Duration(
                                      hours: _hours,
                                      minutes: _minutes,
                                      seconds: _seconds);
                                }),
                                textStyle: TextStyle(
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 16
                                          : heightOfWholeScreen / 16,
                                  color:
                                      const Color.fromARGB(255, 176, 176, 176),
                                ),
                                itemHeight:
                                    (MediaQuery.of(context).orientation ==
                                            Orientation.portrait)
                                        ? widthOfWholeScreen / 9
                                        : heightOfWholeScreen / 9,
                                selectedTextStyle: TextStyle(
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
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
                        Text(
                          "   :   ",
                          style: TextStyle(
                            fontSize: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 9
                                : heightOfWholeScreen / 9,
                            color: const Color.fromARGB(255, 0, 123, 255),
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
                              scale: 1.3,
                              child: NumberPicker(
                                key: const Key("Minutes"),
                                value: _minutes,
                                minValue: 0,
                                maxValue: 59,
                                onChanged: (value) => setState(() {
                                  _minutes = value;
                                  state.myDuration = Duration(
                                      hours: _hours,
                                      minutes: _minutes,
                                      seconds: _seconds);
                                }),
                                textStyle: TextStyle(
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 16
                                          : heightOfWholeScreen / 16,
                                  color:
                                      const Color.fromARGB(255, 176, 176, 176),
                                ),
                                itemHeight:
                                    (MediaQuery.of(context).orientation ==
                                            Orientation.portrait)
                                        ? widthOfWholeScreen / 9
                                        : heightOfWholeScreen / 9,
                                selectedTextStyle: TextStyle(
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
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
                        Text(
                          "   :   ",
                          style: TextStyle(
                            fontSize: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 9
                                : heightOfWholeScreen / 9,
                            color: const Color.fromARGB(255, 0, 123, 255),
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
                              scale: 1.3,
                              child: NumberPicker(
                                key: const Key("Seconds"),
                                value: _seconds,
                                minValue: 0,
                                maxValue: 59,
                                onChanged: (value) => setState(() {
                                  _seconds = value;
                                  state.myDuration = Duration(
                                      hours: _hours,
                                      minutes: _minutes,
                                      seconds: _seconds);
                                }),
                                textStyle: TextStyle(
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 16
                                          : heightOfWholeScreen / 16,
                                  color:
                                      const Color.fromARGB(255, 176, 176, 176),
                                ),
                                itemHeight:
                                    (MediaQuery.of(context).orientation ==
                                            Orientation.portrait)
                                        ? widthOfWholeScreen / 9
                                        : heightOfWholeScreen / 9,
                                selectedTextStyle: TextStyle(
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
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
              // fixed empty sized box
              SizedBox(
                height: widthOfWholeScreen / 1.5,
              ),
              // Set button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (state.isStarted)
                      ? TextButton(
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
                                borderRadius:
                                    BorderRadius.circular(widthOfWholeScreen),
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
                            BlocProvider.of<IsStartedTimerCubit>(context).resetTimer();
                          },
                        )
                      : const Text(""),
                  (state.isStarted)
                      ? SizedBox(
                          width: widthOfWholeScreen / 15,
                        )
                      : const SizedBox(width: 0),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 0, 123, 255),
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
                          borderRadius:
                              BorderRadius.circular(widthOfWholeScreen),
                        ),
                      ),
                    ),
                    child: Text(
                      () {
                        if (state.isStarted == true && state.isStopped == false) {
                          return "Stop";
                        } else if (state.isStarted == true && state.isStopped == true) {
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
                      if (state.isStarted == false && state.isStopped == false) {
                        if ((_hours != 0) ||
                            (_minutes != 0) ||
                            (_seconds != 0)) {
                          setState(() {
                            state.myDuration = Duration(
                                hours: _hours,
                                minutes: _minutes,
                                seconds: _seconds);
                            BlocProvider.of<IsStartedTimerCubit>(context).startTimer();
                          });
                          BlocProvider.of<IsStartedTimerCubit>(context)
                              .boolChangerTimerisStarted(true);
                        }
                      }
                      // This is when the timer is started but it is stopped so the pressing button should call the start timer method
                      else if (state.isStarted == true && state.isStopped == true) {
                        setState(() {
                          BlocProvider.of<IsStartedTimerCubit>(context).startTimer();
                          state.isStopped = false;
                        });
                      }
                      // This is when the timer is started but it is not stoppped so the stop timer method should be called
                      else if (state.isStarted == true && state.isStopped == false) {
                        BlocProvider.of<IsStartedTimerCubit>(context).stopTimer();
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
