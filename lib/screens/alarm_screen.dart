import 'package:clock_app/cubit/alarm_cubit/alarm_cubit.dart';
import 'package:clock_app/screens/adding_city_time.dart';
import 'package:clock_app/screens/in_time_of_alarming_ringing.dart';
import 'package:clock_app/widgets/fade_page_route.dart';
import 'package:clock_app/widgets/slide_transition.dart';
import 'package:clock_app/widgets/stop_watch_widgets.dart';
import 'package:clock_app/widgets/timer_widget.dart';
import 'package:clock_app/widgets/timer_widget_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clock_app/assets/icons/widgets/add_icons.dart';
import 'package:clock_app/assets/icons/widgets/menu_icons.dart';
import 'package:clock_app/assets/icons/widgets/alarm_icons.dart' as alarm_icon;
import 'package:clock_app/assets/icons/widgets/timer_icons.dart';
import 'package:clock_app/assets/icons/widgets/world_clock_icons.dart';
import 'package:clock_app/assets/icons/widgets/stopwatch_icons.dart';
import 'package:clock_app/models/alarms_model.dart';
import 'package:clock_app/widgets/world_clock.dart' as WorldClockWidget;

import 'adding_new_alarm_screen.dart';

enum BottomNavigaionBarIndex {
  alarm,
  worldClock,
  stopwatch,
  timer,
}

List<Alarm> alarmDataToShow = [];

void storingTheIsToggle({bool? isTrunedOn, int? index}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (index != null) {
    alarmDataToShow[index].isToggle = isTrunedOn as bool;

    // Encode and store data in SharedPreferences
    final String encodedData = Alarm.encode(alarmDataToShow);

    await prefs.setString('Alarms', encodedData);
  }
}

void deletingTheAlarm({int? index}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Fetch and decode data
  final String alarmString = prefs.getString('Alarms').toString();

  if (alarmString.isEmpty) {
  } else {
    var dummyAlarms = Alarm.decode(alarmString);

    dummyAlarms.removeAt(index as int);

    // Encode and store data in SharedPreferences
    final String encodedData = Alarm.encode(dummyAlarms);

    alarmDataToShow = dummyAlarms;

    await prefs.setString('Alarms', encodedData);
  }
}

class AlarmScreen extends StatefulWidget {
  final BottomNavigaionBarIndex currentBottomnavigationBarIndex;
  const AlarmScreen({required this.currentBottomnavigationBarIndex, super.key});

  @override
  createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late BottomNavigaionBarIndex currentTap =
      widget.currentBottomnavigationBarIndex;

  // _AlarmScreenState(this.currentTap);

  bool boolean = true;

  int bottomNavigationBarNumber = 0;

  bool _showCircularProgress = true;
  bool _showCircularProgressForRemaingn = true;

  @override
  void initState() {
    currentTap = widget.currentBottomnavigationBarIndex;

    BlocProvider.of<AlarmCubit>(context).readingAlarms();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showCircularProgress = false;
        _showCircularProgressForRemaingn = false;
      });
    });
    super.initState();
  }

  void changeTheState() {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        _showCircularProgress = false;
        _showCircularProgressForRemaingn = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<AlarmCubit>(context).readingAlarms();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showCircularProgress = true;
      });
    });
    super.didChangeDependencies();
  }

  Future<List<Alarm>> readingFromMemory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Fetch and decode data
    final String alarmString = prefs.getString('Alarms').toString();

    if (alarmString.isEmpty) {
      alarmDataToShow = [];
    } else {
      print("Reading From Memory method : $alarmString");
      alarmDataToShow = Alarm.decode(alarmString);
    }

    return alarmDataToShow;
  }

  String howcouldBeNearTheSecondAlarm = "";

  void gettingTheMostRecentAlarm(List<Alarm> list) {
    List<Alarm> dummyList = list;

    dummyList.sort((first, second) {
      return first.time.compareTo(second.time);
    });

    DateTime _current = DateTime.now();
  }

  void formatedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  }

  String upToNextAlarmString =
      ""; // Should be the number of days or weeks or months or years that up to the near next alarm
  String nameUpToNextAlarmString = ""; // Name of the next alarm

  void upToNextAlarmStringMethod(List<Alarm> alarms) {
    DateTime now = DateTime.now();

    List<Map<String, int>> _listOfAlarmsInIndexAndSeconds =
        List<Map<String, int>>.filled(
      alarms.length,
      {
        "index": 0,
        "second": 0,
      },
      growable: false,
    );

    if (alarms.isNotEmpty) {
      for (int index = 0; index < alarms.length; ++index) {
        if (alarms[index].isToggle == true) {
          if (alarms[index].day.contains("-")) {
            //  that is the picked date with calendar

            String dateTimeNow = "";
            for (int j = 0; j < alarms[index].day.length - 1; ++j) {
              dateTimeNow = dateTimeNow + alarms[index].day[j];
            }

            DateTime currentIndexed = DateTime.parse(dateTimeNow);

            _listOfAlarmsInIndexAndSeconds[index] = {
              "index": index,
              "second": currentIndexed.difference(now).inSeconds,
            };
          } else {
            // that is the button pressed selected day of week
            if (alarms[index].day.contains("1")) {
              // Saturday
              DateTime current = DateTime.now();

              int currentDay = current.weekday;
              int desiredDay = 6;

              // Getting the difference between current day and desired day
              int difference = (currentDay - desiredDay).abs();

              if (difference == 0) {
                // The desired day is like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds =
                    desiredInSeconds - currentInSeconds;

                if (diffreceOfHoursInSeconds >= 0) {
                  // The Alarm will go off soon
                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                } else {
                  // The Alarm will be for next week
                  current = current.add(const Duration(days: 7));

                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                }
              } else {
                // The desired day isn't like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds0 =
                    desiredInSeconds - currentInSeconds;

                current =
                    current.add(Duration(seconds: diffreceOfHoursInSeconds0));

                // Ready for storing to the list List<Map<String, int>>
                _listOfAlarmsInIndexAndSeconds[index] = {
                  "index": index,
                  "second": current.difference(now).inSeconds,
                };
              }
            }
            if (alarms[index].day.contains("2")) {
              // Sunday
              DateTime current = DateTime.now();

              int currentDay = current.weekday;
              int desiredDay = 7;

              // Getting the difference between current day and desired day
              int difference = (currentDay - desiredDay).abs();

              if (difference == 0) {
                // The desired day is like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds =
                    desiredInSeconds - currentInSeconds;

                if (diffreceOfHoursInSeconds >= 0) {
                  // The Alarm will go off soon
                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                } else {
                  // The Alarm will be for next week
                  current = current.add(const Duration(days: 7));

                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                }
              } else {
                // The desired day isn't like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds0 =
                    desiredInSeconds - currentInSeconds;

                current =
                    current.add(Duration(seconds: diffreceOfHoursInSeconds0));

                // Ready for storing to the list List<Map<String, int>>
                _listOfAlarmsInIndexAndSeconds[index] = {
                  "index": index,
                  "second": current.difference(now).inSeconds,
                };
              }
            }
            if (alarms[index].day.contains("3")) {
              // Monday
              DateTime current = DateTime.now();

              int currentDay = current.weekday;
              int desiredDay = 1;

              // Getting the difference between current day and desired day
              int difference = (currentDay - desiredDay).abs();

              if (difference == 0) {
                // The desired day is like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds =
                    desiredInSeconds - currentInSeconds;

                if (diffreceOfHoursInSeconds >= 0) {
                  // The Alarm will go off soon
                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                } else {
                  // The Alarm will be for next week
                  current = current.add(const Duration(days: 7));

                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                }
              } else {
                // The desired day isn't like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds0 =
                    desiredInSeconds - currentInSeconds;

                current =
                    current.add(Duration(seconds: diffreceOfHoursInSeconds0));

                // Ready for storing to the list List<Map<String, int>>
                _listOfAlarmsInIndexAndSeconds[index] = {
                  "index": index,
                  "second": current.difference(now).inSeconds,
                };
              }
            }
            if (alarms[index].day.contains("4")) {
              // Tuesday
              DateTime current = DateTime.now();

              int currentDay = current.weekday;
              int desiredDay = 2;

              // Getting the difference between current day and desired day
              int difference = (currentDay - desiredDay).abs();

              if (difference == 0) {
                // The desired day is like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds =
                    desiredInSeconds - currentInSeconds;

                if (diffreceOfHoursInSeconds >= 0) {
                  // The Alarm will go off soon
                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                } else {
                  // The Alarm will be for next week
                  current = current.add(const Duration(days: 7));

                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                }
              } else {
                // The desired day isn't like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds0 =
                    desiredInSeconds - currentInSeconds;

                current =
                    current.add(Duration(seconds: diffreceOfHoursInSeconds0));

                // Ready for storing to the list List<Map<String, int>>
                _listOfAlarmsInIndexAndSeconds[index] = {
                  "index": index,
                  "second": current.difference(now).inSeconds,
                };
              }
            }
            if (alarms[index].day.contains("5")) {
              // Wednesday
              DateTime current = DateTime.now();

              int currentDay = current.weekday;
              int desiredDay = 3;

              // Getting the difference between current day and desired day
              int difference = (currentDay - desiredDay).abs();

              if (difference == 0) {
                // The desired day is like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds =
                    desiredInSeconds - currentInSeconds;

                if (diffreceOfHoursInSeconds >= 0) {
                  // The Alarm will go off soon
                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                } else {
                  // The Alarm will be for next week
                  current = current.add(const Duration(days: 7));

                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                }
              } else {
                // The desired day isn't like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds0 =
                    desiredInSeconds - currentInSeconds;

                current =
                    current.add(Duration(seconds: diffreceOfHoursInSeconds0));

                // Ready for storing to the list List<Map<String, int>>
                _listOfAlarmsInIndexAndSeconds[index] = {
                  "index": index,
                  "second": current.difference(now).inSeconds,
                };
              }
            }
            if (alarms[index].day.contains("6")) {
              // Thursday
              DateTime current = DateTime.now();

              int currentDay = current.weekday;
              int desiredDay = 4;

              // Getting the difference between current day and desired day
              int difference = (currentDay - desiredDay).abs();

              if (difference == 0) {
                // The desired day is like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds =
                    desiredInSeconds - currentInSeconds;

                if (diffreceOfHoursInSeconds >= 0) {
                  // The Alarm will go off soon
                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                } else {
                  // The Alarm will be for next week
                  current = current.add(const Duration(days: 7));

                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                }
              } else {
                // The desired day isn't like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds0 =
                    desiredInSeconds - currentInSeconds;

                current =
                    current.add(Duration(seconds: diffreceOfHoursInSeconds0));

                // Ready for storing to the list List<Map<String, int>>
                _listOfAlarmsInIndexAndSeconds[index] = {
                  "index": index,
                  "second": current.difference(now).inSeconds,
                };
              }
            }
            if (alarms[index].day.contains("7")) {
              // Friday
              DateTime current = DateTime.now();

              int currentDay = current.weekday;
              int desiredDay = 5;

              // Getting the difference between current day and desired day
              int difference = (currentDay - desiredDay).abs();

              if (difference == 0) {
                // The desired day is like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds =
                    desiredInSeconds - currentInSeconds;

                if (diffreceOfHoursInSeconds >= 0) {
                  // The Alarm will go off soon
                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                } else {
                  // The Alarm will be for next week
                  current = current.add(const Duration(days: 7));

                  current =
                      current.add(Duration(seconds: diffreceOfHoursInSeconds));

                  // Ready for storing to the list List<Map<String, int>>
                  _listOfAlarmsInIndexAndSeconds[index] = {
                    "index": index,
                    "second": current.difference(now).inSeconds,
                  };
                }
              } else {
                // The desired day isn't like current day
                current = current.add(Duration(days: difference));

                int currentInSeconds = int.parse(
                            "${current.toString()[11]}${current.toString()[12]}") *
                        60 *
                        60 +
                    int.parse(
                            "${current.toString()[14]}${current.toString()[15]}") *
                        60;
                int desiredInSeconds = int.parse(
                            "${alarms[index].time.toString()[0]}${alarms[index].time.toString()[1]}") *
                        60 *
                        60 +
                    int.parse(
                            "${alarms[index].time.toString()[3]}${alarms[index].time.toString()[4]}") *
                        60;

                int diffreceOfHoursInSeconds0 =
                    desiredInSeconds - currentInSeconds;

                current =
                    current.add(Duration(seconds: diffreceOfHoursInSeconds0));

                // Ready for storing to the list List<Map<String, int>>
                _listOfAlarmsInIndexAndSeconds[index] = {
                  "index": index,
                  "second": current.difference(now).inSeconds,
                };
              }
            }
          }
        } else {
          continue;
        }
      }
    }

    int indexOfNearest = 0;
    int secondsOfNearest = _listOfAlarmsInIndexAndSeconds[0]["second"]!;

    if (alarms.isNotEmpty) {
      for (int j = 0; j < alarms.length; ++j) {
        if (_listOfAlarmsInIndexAndSeconds[j]["second"]! > 0) {
          indexOfNearest = j;
          secondsOfNearest = _listOfAlarmsInIndexAndSeconds[j]["second"]!;
        }
      }
    }

    // find the nearest
    if (alarms.isNotEmpty) {
      for (int i = 0; i < alarms.length; ++i) {
        if (_listOfAlarmsInIndexAndSeconds[i]["second"]! > 0) {
          if (_listOfAlarmsInIndexAndSeconds[i]["second"]! <=
              secondsOfNearest) {
            indexOfNearest = i;
            secondsOfNearest = _listOfAlarmsInIndexAndSeconds[i]["second"]!;
          }
        }
      }
    }

    if (alarms[indexOfNearest].isToggle == true) {
      // Saving the next nearest alarm
      if ((secondsOfNearest / (24 * 60 * 60)).floor() == 0) {
        // It is smaller than one day
        if ((secondsOfNearest / (60 * 60)).floor() == 0) {
          // It is smaller than one hour
          if ((secondsOfNearest / (60)).floor() == 0) {
            // It is smaller than one minute
            if ((secondsOfNearest / (1)).floor() == 0) {
              // It is smaller than one second
              upToNextAlarmString = "Less than one second";
            } else {
              // It is bigger than one second
              upToNextAlarmString = "${(secondsOfNearest / (1)).floor()} ${() {
                if ((secondsOfNearest / (1)).floor() == 1) {
                  return "second";
                } else {
                  return "seconds";
                }
              }()}";
            }
          } else {
            // It is bigger than one minute
            upToNextAlarmString = "${(secondsOfNearest / (60)).floor()} ${() {
              if ((secondsOfNearest / (60)).floor() == 1) {
                return "minute";
              } else {
                return "minutes";
              }
            }()}";
          }
        } else {
          // It is bigger than one hour
          upToNextAlarmString =
              "${(secondsOfNearest / (60 * 60)).floor()} ${() {
            if ((secondsOfNearest / (60 * 60)).floor() == 1) {
              return "hour";
            } else {
              return "hours";
            }
          }()}";
        }
      } else {
        // It is bigger than one day
        upToNextAlarmString =
            "${(secondsOfNearest / (24 * 60 * 60)).floor()} ${() {
          if ((secondsOfNearest / (24 * 60 * 60)).floor() == 1) {
            return "day";
          } else {
            return "days";
          }
        }()}";
      }
    }

    if (alarms[indexOfNearest].isToggle == true) {
      nameUpToNextAlarmString = alarms[indexOfNearest].name;
    }

    if (alarms[indexOfNearest].isToggle == false) {
      upToNextAlarmString =
          ""; // Should be the number of days or weeks or months or years that up to the near next alarm
      nameUpToNextAlarmString = ""; // Name of the next alarm
    }
  }

  @override
  Widget build(BuildContext contextOfWholeScreen) {
    PageController controller = PageController(
      initialPage: () {
        int index = 0;

        switch (widget.currentBottomnavigationBarIndex) {
          case BottomNavigaionBarIndex.alarm:
            {
              index = 0;
            }
            break;
          case BottomNavigaionBarIndex.worldClock:
            {
              index = 1;
            }
            break;
          case BottomNavigaionBarIndex.stopwatch:
            {
              index = 2;
            }
            break;
          case BottomNavigaionBarIndex.timer:
            {
              index = 3;
            }
            break;
        }

        return index;
      }(),
    );

    double heightOfWholeScreen = MediaQuery.of(context).size.height;
    double widthOfWholeScreen = MediaQuery.of(context).size.width;

    BlocProvider.of<AlarmCubit>(contextOfWholeScreen).readingAlarms();

    Future<void> refresh() {
      return Future.delayed(
        const Duration(
          seconds: 1,
        ),
        () {
          BlocProvider.of<AlarmCubit>(contextOfWholeScreen).readingAlarms();

          if (alarmDataToShow.isNotEmpty) {
            upToNextAlarmStringMethod(alarmDataToShow);
          }

          didChangeDependencies();
          changeTheState();
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Padding(
        padding: EdgeInsets.only(
          top: widthOfWholeScreen / 20,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                // main contents
                PageView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (value) {
                    setState(() {
                      if (value == 0) {
                        currentTap = BottomNavigaionBarIndex.alarm;
                      } else if (value == 1) {
                        currentTap = BottomNavigaionBarIndex.worldClock;
                      } else if (value == 2) {
                        currentTap = BottomNavigaionBarIndex.stopwatch;
                      } else if (value == 3) {
                        currentTap = BottomNavigaionBarIndex.timer;
                      }
                    });
                  },
                  children: [
                    // Alarms
                    BlocBuilder<AlarmCubit, AlarmState>(
                      builder: (contextOfBlocBuilderParent, state) {
                        BlocProvider.of<AlarmCubit>(contextOfBlocBuilderParent)
                            .readingAlarms();

                        if (state.alarmData.isNotEmpty) {
                          upToNextAlarmStringMethod(state.alarmData);
                        }

                        return Container(
                          width: widthOfWholeScreen,
                          // height: widthOfWholeScreen / 2,
                          margin: EdgeInsets.only(
                            top: widthOfWholeScreen / 3.5,
                            bottom: widthOfWholeScreen / 5,
                          ),
                          child: (state.alarmData.isNotEmpty)
                              ? RefreshIndicator(
                                  onRefresh: refresh,
                                  child: ListView.builder(
                                    itemCount: state.alarmData.length,
                                    itemBuilder:
                                        (contextAlarmBloc, indexOfContainers) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(contextOfWholeScreen)
                                              .pushReplacement(
                                            CustomSlideTransitionPageRoute(
                                              child: AddingNewAlarmScreen(
                                                alarmHour: int.parse(state
                                                            .alarmData[
                                                                indexOfContainers]
                                                            .time
                                                            .toString()[0]) *
                                                        10 +
                                                    int.parse(state
                                                        .alarmData[
                                                            indexOfContainers]
                                                        .time
                                                        .toString()[1]),
                                                alarmMinute: int.parse(state
                                                            .alarmData[
                                                                indexOfContainers]
                                                            .time
                                                            .toString()[3]) *
                                                        10 +
                                                    int.parse(state
                                                        .alarmData[
                                                            indexOfContainers]
                                                        .time
                                                        .toString()[4]),
                                                alarmTitle: state
                                                    .alarmData[
                                                        indexOfContainers]
                                                    .name
                                                    .toString(),
                                                alarmDate: state
                                                    .alarmData[
                                                        indexOfContainers]
                                                    .day
                                                    .toString(),
                                                isToggleThisOneAlarm: state
                                                    .alarmData[
                                                        indexOfContainers]
                                                    .isToggle,
                                                indexOfAlarm: indexOfContainers,
                                                key: const Key("Passed Widget"),
                                              ),
                                              direction: AxisDirection.up,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                            bottom: 50,
                                            left: 45,
                                            right: 45,
                                          ),
                                          height: widthOfWholeScreen / 2.2,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  widthOfWholeScreen / 15),
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color:
                                                    Color.fromARGB(25, 0, 0, 0),
                                                blurRadius: 20,
                                                offset: Offset(0, 11),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // Showing the name
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 10,
                                                      left: 30,
                                                    ),
                                                    child: Text(
                                                      state
                                                          .alarmData[
                                                              indexOfContainers]
                                                          .name
                                                          .toString(),
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 7, 0, 196),
                                                        fontFamily:
                                                            'FredokaOne-Regular',
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        fontSize:
                                                            widthOfWholeScreen /
                                                                16,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      bottom: 10,
                                                      right: 30,
                                                    ),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        BlocProvider.of<
                                                                    AlarmCubit>(
                                                                contextAlarmBloc)
                                                            .deletingTheAlarm(
                                                                index:
                                                                    indexOfContainers);

                                                        didChangeDependencies();
                                                        upToNextAlarmStringMethod(
                                                            state.alarmData);
                                                        print(
                                                            "UP TO THE NEXT ALARM $upToNextAlarmString");
                                                        print(
                                                            nameUpToNextAlarmString);
                                                        changeTheState();
                                                      },
                                                      alignment:
                                                          Alignment.center,
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 160, 160, 160),
                                                        size: MediaQuery.of(
                                                                        context)
                                                                    .orientation ==
                                                                Orientation
                                                                    .portrait
                                                            ? widthOfWholeScreen /
                                                                12
                                                            : heightOfWholeScreen /
                                                                12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Showing the date
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 20,
                                                      right: 30,
                                                    ),
                                                    child: Text(
                                                      (() {
                                                        String days = "";
                                                        if (state
                                                            .alarmData[
                                                                indexOfContainers]
                                                            .day
                                                            .toString()
                                                            .contains('1')) {
                                                          days =
                                                              '$days${"Sa "}';
                                                        }
                                                        if (state
                                                            .alarmData[
                                                                indexOfContainers]
                                                            .day
                                                            .toString()
                                                            .contains("2")) {
                                                          days =
                                                              '$days${"Su "}';
                                                        }
                                                        if (state
                                                            .alarmData[
                                                                indexOfContainers]
                                                            .day
                                                            .toString()
                                                            .contains("3")) {
                                                          days =
                                                              '$days${"Mo "}';
                                                        }
                                                        if (state
                                                            .alarmData[
                                                                indexOfContainers]
                                                            .day
                                                            .toString()
                                                            .contains("4")) {
                                                          days =
                                                              '$days${"Tu "}';
                                                        }
                                                        if (state
                                                            .alarmData[
                                                                indexOfContainers]
                                                            .day
                                                            .toString()
                                                            .contains("5")) {
                                                          days =
                                                              '$days${"We "}';
                                                        }
                                                        if (state
                                                            .alarmData[
                                                                indexOfContainers]
                                                            .day
                                                            .toString()
                                                            .contains("6")) {
                                                          days =
                                                              '$days${"Th "}';
                                                        }
                                                        if (state
                                                            .alarmData[
                                                                indexOfContainers]
                                                            .day
                                                            .toString()
                                                            .contains("7")) {
                                                          days =
                                                              '$days${"Fr "}';
                                                        }

                                                        if (state
                                                            .alarmData[
                                                                indexOfContainers]
                                                            .day
                                                            .toString()
                                                            .contains("-")) {
                                                          String list = state
                                                              .alarmData[
                                                                  indexOfContainers]
                                                              .day
                                                              .toString();
                                                          List month = [
                                                            "1",
                                                            "2"
                                                          ];
                                                          int counter = 0;
                                                          for (int i = 5;
                                                              i < 7;
                                                              ++i) {
                                                            month[counter] =
                                                                list[i];
                                                            ++counter;
                                                          }
                                                          String con =
                                                              month[0] +
                                                                  month[1];
                                                          int monthInteger =
                                                              int.parse(con);

                                                          days = "${() {
                                                            int lastDigit = state
                                                                    .alarmData[
                                                                        indexOfContainers]
                                                                    .day
                                                                    .toString()
                                                                    .length -
                                                                1;
                                                            if (state
                                                                        .alarmData[
                                                                            indexOfContainers]
                                                                        .day
                                                                        .toString()[
                                                                    lastDigit] ==
                                                                "6") {
                                                              return "Sat, ";
                                                            }
                                                            if (state
                                                                        .alarmData[
                                                                            indexOfContainers]
                                                                        .day
                                                                        .toString()[
                                                                    lastDigit] ==
                                                                "7") {
                                                              return "Sun, ";
                                                            }
                                                            if (state
                                                                        .alarmData[
                                                                            indexOfContainers]
                                                                        .day
                                                                        .toString()[
                                                                    lastDigit] ==
                                                                "1") {
                                                              return "Mon, ";
                                                            }
                                                            if (state
                                                                        .alarmData[
                                                                            indexOfContainers]
                                                                        .day
                                                                        .toString()[
                                                                    lastDigit] ==
                                                                "2") {
                                                              return "Tue, ";
                                                            }
                                                            if (state
                                                                        .alarmData[
                                                                            indexOfContainers]
                                                                        .day
                                                                        .toString()[
                                                                    lastDigit] ==
                                                                "3") {
                                                              return "Wed, ";
                                                            }
                                                            if (state
                                                                        .alarmData[
                                                                            indexOfContainers]
                                                                        .day
                                                                        .toString()[
                                                                    lastDigit] ==
                                                                "4") {
                                                              return "Thu, ";
                                                            }
                                                            if (state
                                                                        .alarmData[
                                                                            indexOfContainers]
                                                                        .day
                                                                        .toString()[
                                                                    lastDigit] ==
                                                                "5") {
                                                              return "Fri, ";
                                                            }
                                                          }()}${() {
                                                            if (int.parse(state
                                                                    .alarmData[
                                                                        indexOfContainers]
                                                                    .day
                                                                    .toString()[8]) ==
                                                                0) {
                                                              return "";
                                                            } else {
                                                              return state
                                                                  .alarmData[
                                                                      indexOfContainers]
                                                                  .day
                                                                  .toString()[8];
                                                            }
                                                          }()}${state.alarmData[indexOfContainers].day.toString()[9]}, ${() {
                                                            if (monthInteger ==
                                                                1) {
                                                              return "January";
                                                            }
                                                            if (monthInteger ==
                                                                2) {
                                                              return "February";
                                                            }
                                                            if (monthInteger ==
                                                                3) {
                                                              return "March";
                                                            }
                                                            if (monthInteger ==
                                                                4) {
                                                              return "April";
                                                            }
                                                            if (monthInteger ==
                                                                5) {
                                                              return "May";
                                                            }
                                                            if (monthInteger ==
                                                                6) {
                                                              return "June";
                                                            }
                                                            if (monthInteger ==
                                                                7) {
                                                              return "July";
                                                            }
                                                            if (monthInteger ==
                                                                8) {
                                                              return "August";
                                                            }
                                                            if (monthInteger ==
                                                                9) {
                                                              return "September";
                                                            }
                                                            if (monthInteger ==
                                                                10) {
                                                              return "October";
                                                            }
                                                            if (monthInteger ==
                                                                11) {
                                                              return "November";
                                                            }
                                                            if (monthInteger ==
                                                                12) {
                                                              return "December";
                                                            }
                                                          }()} ${() {
                                                            return state
                                                                        .alarmData[
                                                                            indexOfContainers]
                                                                        .day
                                                                        .toString()[
                                                                    0] +
                                                                state
                                                                        .alarmData[
                                                                            indexOfContainers]
                                                                        .day
                                                                        .toString()[
                                                                    1] +
                                                                state
                                                                        .alarmData[
                                                                            indexOfContainers]
                                                                        .day
                                                                        .toString()[
                                                                    2] +
                                                                state
                                                                    .alarmData[
                                                                        indexOfContainers]
                                                                    .day
                                                                    .toString()[3];
                                                          }()}";
                                                        }

                                                        return days;
                                                      }()),
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 0, 163, 255),
                                                        fontFamily:
                                                            'FredokaOne-Regular',
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        fontSize:
                                                            widthOfWholeScreen /
                                                                20,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 20,
                                                      right: 30,
                                                    ),
                                                    child: Transform.scale(
                                                      scale: 2,
                                                      child: Switch.adaptive(
                                                        value: state
                                                            .alarmData[
                                                                indexOfContainers]
                                                            .isToggle,
                                                        onChanged: (value) {
                                                          BlocProvider.of<
                                                                      AlarmCubit>(
                                                                  contextOfWholeScreen)
                                                              .storingTheIsToggleCubit(
                                                            index:
                                                                indexOfContainers,
                                                            isTrunedOn: value,
                                                          );

                                                          BlocProvider.of<
                                                                      AlarmCubit>(
                                                                  contextOfWholeScreen)
                                                              .readingAlarms();

                                                          didChangeDependencies();
                                                          upToNextAlarmStringMethod(
                                                              state.alarmData);

                                                          setState(() {
                                                            _showCircularProgressForRemaingn =
                                                                true;
                                                          });

                                                          changeTheState();
                                                        },
                                                        activeColor: const Color
                                                                .fromARGB(
                                                            255, 0, 163, 255),
                                                        activeTrackColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                94,
                                                                196,
                                                                255),
                                                        inactiveThumbColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                209,
                                                                209,
                                                                209),
                                                        inactiveTrackColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                186,
                                                                186,
                                                                186),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Showing time
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      bottom: 9,
                                                      left: 30,
                                                    ),
                                                    child: Text(
                                                      state
                                                          .alarmData[
                                                              indexOfContainers]
                                                          .time,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 7, 0, 196),
                                                        fontFamily:
                                                            'Roboto-Bold',
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        fontSize:
                                                            widthOfWholeScreen /
                                                                10,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : () {
                                  if (_showCircularProgress) {
                                    changeTheState();

                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Color.fromARGB(255, 0, 7, 215),
                                      ),
                                    );
                                  } else {
                                    return AnimatedCrossFade(
                                      firstChild: Center(
                                        child: Image.asset(
                                          'lib/assets/pngs/No Reminder placeholder Image.png',
                                          width: widthOfWholeScreen / 1.2,
                                          height: widthOfWholeScreen / 1.2,
                                        ),
                                      ),
                                      secondChild: Center(
                                        child: Image.asset(
                                          'lib/assets/pngs/No Reminder placeholder Image.png',
                                          width: widthOfWholeScreen / 1.2,
                                          height: widthOfWholeScreen / 1.2,
                                        ),
                                      ),
                                      crossFadeState: _showCircularProgress
                                          ? CrossFadeState.showSecond
                                          : CrossFadeState.showFirst,
                                      duration:
                                          const Duration(milliseconds: 1000),
                                    );
                                  }
                                }(),
                        );
                      },
                    ),
                    // World Clock
                    const WorldClockWidget.WorldClock(),
                    // Stop watch
                    const StopWatchWidget(),
                    // Timer
                    const TimerWidget(),
                  ],
                ),
                // the stack of floating action buttons and text show of alaram
                Padding(
                  padding: EdgeInsets.only(
                    top: widthOfWholeScreen / 13,
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: widthOfWholeScreen / 60,
                        ),
                        child: (currentTap == BottomNavigaionBarIndex.alarm)
                            ? BlocBuilder<AlarmCubit, AlarmState>(
                                builder: (context, state) {
                                  if (state.alarmData.isNotEmpty) {
                                    upToNextAlarmStringMethod(state.alarmData);
                                  }

                                  return RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: (((state.alarmData.isNotEmpty) ||
                                                  (_showCircularProgressForRemaingn)) &&
                                              (upToNextAlarmString.isNotEmpty))
                                          ? "$upToNextAlarmString remaining to the\n"
                                          : "",
                                      style: TextStyle(
                                        fontSize: widthOfWholeScreen / 24,
                                        color: const Color.fromARGB(
                                            255, 7, 0, 196),
                                        fontFamily: 'FredokaOne-Regular',
                                        height: 1.7,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: ((state.alarmData.isNotEmpty) &&
                                                  (nameUpToNextAlarmString
                                                      .isNotEmpty))
                                              ? nameUpToNextAlarmString
                                              : "",
                                          style: TextStyle(
                                            fontSize: widthOfWholeScreen / 24,
                                            color: const Color.fromARGB(
                                                255, 0, 163, 255),
                                            fontFamily: 'FredokaOne-Regular',
                                            height: 1.7,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text(""),
                              ),
                      ),
                      // Upper floating action buttons
                      Container(
                        margin: EdgeInsets.only(
                          bottom: (heightOfWholeScreen - 24) / 1.1,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: widthOfWholeScreen / 7,
                              height: widthOfWholeScreen / 7,
                              child: FloatingActionButton(
                                heroTag: "LeftMenu",
                                onPressed: () {
                                  Navigator.of(contextOfWholeScreen).push(
                                    CustomSlideTransitionPageRoute(
                                      child: const InTimeOfAlarmRinging(),
                                      direction: AxisDirection.left,
                                    ),
                                  );
                                },
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 122, 255),
                                child: Icon(
                                  Menu.menu,
                                  size: widthOfWholeScreen / 13.5,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: widthOfWholeScreen / 1.55,
                            ),
                            SizedBox(
                              width: widthOfWholeScreen / 7,
                              height: widthOfWholeScreen / 7,
                              child: FloatingActionButton(
                                heroTag: "AddFloatingActionButton",
                                onPressed: () {
                                  if (currentTap ==
                                      BottomNavigaionBarIndex.alarm) {
                                    Navigator.of(contextOfWholeScreen)
                                        .pushReplacement(
                                      CustomSlideTransitionPageRoute(
                                        child: const AddingNewAlarmScreen(
                                          alarmHour: 0,
                                          alarmMinute: 0,
                                          alarmTitle: "",
                                          alarmDate: "",
                                          isToggleThisOneAlarm: true,
                                          indexOfAlarm: -1,
                                          key: Key("Empty Widget"),
                                        ),
                                        direction: AxisDirection.up,
                                      ),
                                    );
                                  }
                                  if (currentTap ==
                                      BottomNavigaionBarIndex.worldClock) {
                                    Navigator.of(context).pushReplacement(
                                      FadePageRoute(
                                        const AddingTimeCitiesAroundTheWorld(),
                                      ),
                                    );
                                  }
                                },
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 122, 255),
                                child: Icon(
                                  Add.add,
                                  size: widthOfWholeScreen / 13.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.only(
                left: 11,
                right: 11,
              ),
              margin: const EdgeInsets.only(
                right: 25,
                left: 25,
                bottom: 50,
              ),
              alignment: Alignment.center,
              height: widthOfWholeScreen / 5.5,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(45, 0, 0, 0),
                    offset: Offset(0, 20),
                    blurRadius: 40,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(widthOfWholeScreen),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      icon: AnimatedCrossFade(
                        firstChild: Icon(
                          alarm_icon.Alarm.alarm,
                          color: const Color.fromARGB(255, 0, 0, 255),
                          size: widthOfWholeScreen / 12,
                        ),
                        secondChild: Icon(
                          alarm_icon.Alarm.alarm,
                          color: const Color.fromARGB(255, 140, 140, 140),
                          size: widthOfWholeScreen / 10,
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.alarm)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      label: AnimatedCrossFade(
                        firstChild: Text(
                          "  Alarm",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: const Color.fromARGB(255, 0, 0, 255),
                            fontSize: widthOfWholeScreen / 21,
                          ),
                        ),
                        secondChild: const Text(
                          "",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: Color.fromARGB(255, 0, 0, 255),
                          ),
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.alarm)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      // iconSize: widthOfWholeScreen / 10,
                      onPressed: () {
                        setState(() {
                          currentTap = BottomNavigaionBarIndex.alarm;

                          bottomNavigationBarNumber = 0;

                          controller.animateToPage(
                            bottomNavigationBarNumber,
                            duration: const Duration(
                              milliseconds: 1000,
                            ),
                            curve: Curves.elasticOut,
                          );
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(widthOfWholeScreen),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: AnimatedCrossFade(
                        firstChild: Icon(
                          WorldClock.worldClock,
                          color: const Color.fromARGB(255, 0, 0, 255),
                          size: widthOfWholeScreen / 12,
                        ),
                        secondChild: Icon(
                          WorldClock.worldClock,
                          color: const Color.fromARGB(255, 140, 140, 140),
                          size: widthOfWholeScreen / 10,
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.worldClock)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      label: AnimatedCrossFade(
                        firstChild: Text(
                          " World Clock",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: const Color.fromARGB(255, 0, 0, 255),
                            fontSize: widthOfWholeScreen / 21,
                          ),
                        ),
                        secondChild: const Text(
                          "",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: Color.fromARGB(255, 0, 0, 255),
                          ),
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.worldClock)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      // iconSize: widthOfWholeScreen / 10,
                      onPressed: () {
                        setState(() {
                          currentTap = BottomNavigaionBarIndex.worldClock;

                          bottomNavigationBarNumber = 1;

                          controller.animateToPage(
                            bottomNavigationBarNumber,
                            duration: const Duration(
                              milliseconds: 1000,
                            ),
                            curve: Curves.elasticOut,
                          );
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(widthOfWholeScreen),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: AnimatedCrossFade(
                        firstChild: FittedBox(
                          child: Icon(
                            Stopwatch.stopwatch,
                            color: const Color.fromARGB(255, 0, 0, 255),
                            size: widthOfWholeScreen / 12,
                          ),
                        ),
                        secondChild: Icon(
                          Stopwatch.stopwatch,
                          color: const Color.fromARGB(255, 140, 140, 140),
                          size: widthOfWholeScreen / 10,
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.stopwatch)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      label: AnimatedCrossFade(
                        firstChild: Text(
                          "  Stopwatch",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: const Color.fromARGB(255, 0, 0, 255),
                            fontSize: widthOfWholeScreen / 21,
                          ),
                        ),
                        secondChild: const Text(
                          "",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: Color.fromARGB(255, 0, 0, 255),
                          ),
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.stopwatch)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      // iconSize: widthOfWholeScreen / 10,
                      onPressed: () {
                        setState(() {
                          currentTap = BottomNavigaionBarIndex.stopwatch;

                          bottomNavigationBarNumber = 2;

                          controller.animateToPage(
                            bottomNavigationBarNumber,
                            duration: const Duration(
                              milliseconds: 1000,
                            ),
                            curve: Curves.elasticOut,
                          );
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(widthOfWholeScreen),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: AnimatedCrossFade(
                        firstChild: Icon(
                          Timer.timer,
                          color: const Color.fromARGB(255, 0, 0, 255),
                          size: widthOfWholeScreen / 12,
                        ),
                        secondChild: Icon(
                          Timer.timer,
                          color: const Color.fromARGB(255, 140, 140, 140),
                          size: widthOfWholeScreen / 10,
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.timer)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      label: AnimatedCrossFade(
                        firstChild: Text(
                          "Timer",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: const Color.fromARGB(255, 0, 0, 255),
                            fontSize: widthOfWholeScreen / 21,
                          ),
                        ),
                        secondChild: const Text(
                          "",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: Color.fromARGB(255, 0, 0, 255),
                          ),
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.timer)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      // iconSize: widthOfWholeScreen / 10,
                      onPressed: () {
                        setState(() {
                          currentTap = BottomNavigaionBarIndex.timer;

                          bottomNavigationBarNumber = 3;

                          controller.animateToPage(
                            bottomNavigationBarNumber,
                            duration: const Duration(
                              milliseconds: 1000,
                            ),
                            curve: Curves.elasticOut,
                          );
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(widthOfWholeScreen),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
