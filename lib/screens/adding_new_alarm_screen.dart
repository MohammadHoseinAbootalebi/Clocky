import 'package:clock_app/cubit/alarm_cubit/alarm_cubit.dart';
import 'package:clock_app/widgets/slide_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:clock_app/assets/icons/widgets/calendar_icons.dart';
import 'package:clock_app/models/alarms_model.dart';
import 'package:clock_app/screens/alarm_screen.dart';

class AddingNewAlarmScreen extends StatefulWidget {
  final int alarmHour;
  final int alarmMinute;
  final String alarmTitle;
  final String alarmDate;
  final bool isToggleThisOneAlarm;
  final int indexOfAlarm;

  const AddingNewAlarmScreen({
    required this.alarmHour,
    required this.alarmMinute,
    required this.alarmTitle,
    required this.alarmDate,
    required this.isToggleThisOneAlarm,
    required this.indexOfAlarm,
    required super.key,
  });

  @override
  State<AddingNewAlarmScreen> createState() => _AddingNewAlarmScreenState();
}

Future<bool> addingToAlarms(
    String name, String day, String time, String id, bool isToggle) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Fetch and decode data
  final String alarmString = prefs.getString('Alarms').toString();

  List<Alarm> alarms = [];

  if (alarmString == null) {
    alarms = [];
  } else {
    alarms = Alarm.decode(alarmString);
  }

  alarms.add(
    Alarm(
      name: name,
      day: day,
      time: time,
      id: id,
      isToggle: isToggle,
    ),
  );

  // Encode and store data in SharedPreferences
  final String encodedData = Alarm.encode(alarms);

  await prefs.setString('Alarms', encodedData);

  // Checking if the alarm has successfully been saved
  final String alarmsAfterString = prefs.getString('Alarms').toString();

  List<Alarm> alarmsAfterSaving = [];

  if (alarmsAfterString == null) {
    alarmsAfterSaving = [];
  } else {
    alarmsAfterSaving = Alarm.decode(alarmsAfterString);
  }

  if (alarmsAfterSaving.contains(
      Alarm(name: name, day: day, time: time, id: id, isToggle: isToggle))) {
    return true;
  } else {
    return false;
  }
}

class _AddingNewAlarmScreenState extends State<AddingNewAlarmScreen> {
  int _hourValue = 0;
  int _minValue = 0;
  TextEditingController nameTextEditingController = TextEditingController();
  bool isSaturday = false;
  bool isSunday = false;
  bool isMonday = false;
  bool isTuesday = false;
  bool isWednesday = false;
  bool isThursday = false;
  bool isFriday = false;
  // ------------------------ Picking the date --------------------------------
  String _selectedDate = '';
  String _textHolderToShow = "";

  @override
  void initState() {
    _hourValue = widget.alarmHour;
    _minValue = widget.alarmMinute;
    nameTextEditingController.text = widget.alarmTitle;

    if (widget.alarmDate.contains("1")) {
      isSaturday = true;
    } if (widget.alarmDate.contains("2")) {
      isSunday = true;
    } if (widget.alarmDate.contains("3")) {
      isMonday = true;
    } if (widget.alarmDate.contains("4")) {
      isTuesday = true;
    } if (widget.alarmDate.contains("5")) {
      isWednesday = true;
    } if (widget.alarmDate.contains("6")) {
      isThursday = true;
    } if (widget.alarmDate.contains("7")) {
      isFriday = true;
    } 

    if (widget.indexOfAlarm == -1) {
      _selectedDate = '';
      _textHolderToShow = "Selected a date";
    } else {
      _selectedDate = widget.alarmDate;

      if (isSaturday ||
          isSunday ||
          isMonday ||
          isTuesday ||
          isWednesday ||
          isThursday ||
          isFriday) {
        _textHolderToShow = "Every";

        if (isSaturday) {
          setState(() {
            _textHolderToShow = "$_textHolderToShow Sat,";
          });
        }
        if (isSunday) {
          setState(() {
            _textHolderToShow = "$_textHolderToShow Sun,";
          });
        }
        if (isMonday) {
          setState(() {
            _textHolderToShow = "$_textHolderToShow Mon,";
          });
        }
        if (isTuesday) {
          setState(() {
            _textHolderToShow = "$_textHolderToShow Tue,";
          });
        }
        if (isWednesday) {
          setState(() {
            _textHolderToShow = "$_textHolderToShow Wed,";
          });
        }
        if (isThursday) {
          setState(() {
            _textHolderToShow = "$_textHolderToShow Thu,";
          });
        }
        if (isFriday) {
          setState(() {
            _textHolderToShow = "$_textHolderToShow Fri,";
          });
        }
      }

      setState(() {
        if (_selectedDate.isNotEmpty) {
          if ((isSaturday == false) &&
              (isSunday == false) &&
              (isMonday == false) &&
              (isTuesday == false) &&
              (isWednesday == false) &&
              (isThursday == false) &&
              (isFriday == false)) {
            String list = _selectedDate;
            List month = ["1", "2"];
            int counter = 0;
            for (int i = 5; i < 7; ++i) {
              month[counter] = list[i];
              ++counter;
            }
            String con = month[0] + month[1];
            int monthInteger = int.parse(con);

            _textHolderToShow = "${() {
              int lastDigit = _selectedDate.length - 1;
              if (_selectedDate[lastDigit] == "6") {
                return "Saturday, ";
              }
              if (_selectedDate[lastDigit] == "7") {
                return "Sunday, ";
              }
              if (_selectedDate[lastDigit] == "1") {
                return "Monday, ";
              }
              if (_selectedDate[lastDigit] == "2") {
                return "Tuesday, ";
              }
              if (_selectedDate[lastDigit] == "3") {
                return "Wednesday, ";
              }
              if (_selectedDate[lastDigit] == "4") {
                return "Thursday, ";
              }
              if (_selectedDate[lastDigit] == "5") {
                return "Friday, ";
              }
            }()}${() {
              if (int.parse(_selectedDate[8]) == 0) {
                return "";
              } else {
                return _selectedDate[8];
              }
            }()}${_selectedDate[9]} ${() {
              if (monthInteger == 1) {
                return "January";
              }
              if (monthInteger == 2) {
                return "February";
              }
              if (monthInteger == 3) {
                return "March";
              }
              if (monthInteger == 4) {
                return "April";
              }
              if (monthInteger == 5) {
                return "May";
              }
              if (monthInteger == 6) {
                return "June";
              }
              if (monthInteger == 7) {
                return "July";
              }
              if (monthInteger == 8) {
                return "August";
              }
              if (monthInteger == 9) {
                return "September";
              }
              if (monthInteger == 10) {
                return "October";
              }
              if (monthInteger == 11) {
                return "November";
              }
              if (monthInteger == 12) {
                return "December";
              }
            }()} ${() {
              return _selectedDate[0] +
                  _selectedDate[1] +
                  _selectedDate[2] +
                  _selectedDate[3];
            }()}";
          }
        }
      });
    }

    if (widget.alarmDate.contains("-")) {
      _selectedDate = widget.alarmDate;
    } else {
      if (widget.alarmDate.contains("1")) {
        isSaturday = true;
      }
      if (widget.alarmDate.contains("2")) {
        isSunday = true;
      }
      if (widget.alarmDate.contains("3")) {
        isMonday = true;
      }
      if (widget.alarmDate.contains("4")) {
        isTuesday = true;
      }
      if (widget.alarmDate.contains("5")) {
        isWednesday = true;
      }
      if (widget.alarmDate.contains("6")) {
        isThursday = true;
      }
      if (widget.alarmDate.contains("7")) {
        isFriday = true;
      }
    }

    super.initState();
  }

  bool isAlarmHaveSound = false;
  bool isAlarmHasVibration = false;
  bool isAlarmHasSnooze = false;

  bool showingCircularProgree = false;

  void showingTheCircularProg() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        showingCircularProgree = false;
      });
    });
  }

  void changeToTrue() {
    setState(() {
      showingCircularProgree = true;
    });
  }

  void textPlaceHolder() {
    if (isSaturday) {
      setState(() {
        _textHolderToShow = "Every Saturday";
      });
    }
    if (isSunday) {
      setState(() {
        _textHolderToShow = "Every Sunday";
      });
    }
    if (isMonday) {
      setState(() {
        _textHolderToShow = "Every Monday";
      });
    }
    if (isTuesday) {
      setState(() {
        _textHolderToShow = "Every Tuesday";
      });
    }
    if (isWednesday) {
      setState(() {
        _textHolderToShow = "Every Wednesday";
      });
    }
    if (isThursday) {
      setState(() {
        _textHolderToShow = "Every Thursday";
      });
    }
    if (isFriday) {
      setState(() {
        _textHolderToShow = "Every Friday";
      });
    }

    setState(() {
      if (_selectedDate.isNotEmpty) {
        if ((isSaturday == false) &&
            (isSunday == false) &&
            (isMonday == false) &&
            (isTuesday == false) &&
            (isWednesday == false) &&
            (isThursday == false) &&
            (isFriday == false)) {
          String list = _selectedDate;
          List month = ["1", "2"];
          int counter = 0;
          for (int i = 5; i < 7; ++i) {
            month[counter] = list[i];
            ++counter;
          }
          String con = month[0] + month[1];
          int monthInteger = int.parse(con);

          _textHolderToShow = "${() {
            int lastDigit = _selectedDate.length - 1;
            if (_selectedDate[lastDigit] == "6") {
              return "Saturday, ";
            }
            if (_selectedDate[lastDigit] == "7") {
              return "Sunday, ";
            }
            if (_selectedDate[lastDigit] == "1") {
              return "Monday, ";
            }
            if (_selectedDate[lastDigit] == "2") {
              return "Tuesday, ";
            }
            if (_selectedDate[lastDigit] == "3") {
              return "Wednesday, ";
            }
            if (_selectedDate[lastDigit] == "4") {
              return "Thursday, ";
            }
            if (_selectedDate[lastDigit] == "5") {
              return "Friday, ";
            }
          }()}${() {
            if (int.parse(_selectedDate[8]) == 0) {
              return "";
            } else {
              return _selectedDate[8];
            }
          }()}${_selectedDate[9]} ${() {
            if (monthInteger == 1) {
              return "January";
            }
            if (monthInteger == 2) {
              return "February";
            }
            if (monthInteger == 3) {
              return "March";
            }
            if (monthInteger == 4) {
              return "April";
            }
            if (monthInteger == 5) {
              return "May";
            }
            if (monthInteger == 6) {
              return "June";
            }
            if (monthInteger == 7) {
              return "July";
            }
            if (monthInteger == 8) {
              return "August";
            }
            if (monthInteger == 9) {
              return "September";
            }
            if (monthInteger == 10) {
              return "October";
            }
            if (monthInteger == 11) {
              return "November";
            }
            if (monthInteger == 12) {
              return "December";
            }
          }()} ${() {
            return _selectedDate[0] +
                _selectedDate[1] +
                _selectedDate[2] +
                _selectedDate[3];
          }()}";
        }
      }
    });
  }

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {
        DateTime daysOfPickedDate = args.value;
        _selectedDate =
            args.value.toString() + daysOfPickedDate.weekday.toString();
        print("The selected date time : $_selectedDate");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightOfWholeScreen = MediaQuery.of(context).size.height;
    double widthOfWholeScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: (1 / 3) * heightOfWholeScreen,
              width: widthOfWholeScreen,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: NumberPicker(
                      value: _hourValue,
                      minValue: 0,
                      maxValue: 23,
                      onChanged: (value) => setState(() => _hourValue = value),
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
                  Transform.scale(
                    scale: 1.5,
                    child: NumberPicker(
                      key: const Key("Minutes"),
                      value: _minValue,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (value) => setState(() => _minValue = value),
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
            ),
            Container(
              alignment: Alignment.center,
              height: (2 / 3) * heightOfWholeScreen,
              width: widthOfWholeScreen,
              padding: EdgeInsets.only(
                right:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? widthOfWholeScreen / 19
                        : heightOfWholeScreen / 19,
                left:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? widthOfWholeScreen / 19
                        : heightOfWholeScreen / 19,
                top:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? widthOfWholeScreen / 18
                        : heightOfWholeScreen / 18,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 10
                          : heightOfWholeScreen / 10),
                  topRight: Radius.circular(
                      (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 10
                          : heightOfWholeScreen / 10),
                ),
                shape: BoxShape.rectangle,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(3, 0, 0, 0),
                    offset: Offset(0, -8),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    // Selecting the day on the calendar
                    Padding(
                      padding: EdgeInsets.only(
                        left: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 20
                            : heightOfWholeScreen / 20,
                        right: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 20
                            : heightOfWholeScreen / 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (_selectedDate != "")
                                ? _textHolderToShow
                                : "Select a date",
                            style: TextStyle(
                              fontSize: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 21
                                  : heightOfWholeScreen / 21,
                              fontFamily: "Roboto-Regular",
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Calendar.calendar),
                            iconSize: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 11
                                : heightOfWholeScreen / 11,
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        (MediaQuery.of(context).orientation ==
                                                Orientation.portrait)
                                            ? widthOfWholeScreen / 15
                                            : heightOfWholeScreen / 15,
                                      ),
                                    ),
                                    title: Padding(
                                      padding: EdgeInsets.only(
                                        left: (MediaQuery.of(context)
                                                    .orientation ==
                                                Orientation.portrait)
                                            ? widthOfWholeScreen / 30
                                            : heightOfWholeScreen / 30,
                                        top: (MediaQuery.of(context)
                                                    .orientation ==
                                                Orientation.portrait)
                                            ? widthOfWholeScreen / 50
                                            : heightOfWholeScreen / 50,
                                      ),
                                      child: Text(
                                        'Pick your desired day:',
                                        style: TextStyle(
                                          fontFamily: 'FredokaOne-Regular',
                                          fontSize: (MediaQuery.of(context)
                                                      .orientation ==
                                                  Orientation.portrait)
                                              ? widthOfWholeScreen / 25
                                              : heightOfWholeScreen / 25,
                                        ),
                                      ),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: heightOfWholeScreen * (1 / 3),
                                        width: widthOfWholeScreen * (2.3 / 3),
                                        child: SfDateRangePicker(
                                          onSelectionChanged:
                                              _onSelectionChanged,
                                          selectionMode:
                                              DateRangePickerSelectionMode
                                                  .single,
                                          enablePastDates: false,
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: (MediaQuery.of(context)
                                                      .orientation ==
                                                  Orientation.portrait)
                                              ? widthOfWholeScreen / 30
                                              : heightOfWholeScreen / 30,
                                          bottom: (MediaQuery.of(context)
                                                      .orientation ==
                                                  Orientation.portrait)
                                              ? widthOfWholeScreen / 40
                                              : heightOfWholeScreen / 40,
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              isSaturday = false;
                                              isSunday = false;
                                              isMonday = false;
                                              isTuesday = false;
                                              isWednesday = false;
                                              isThursday = false;
                                              isFriday = false;
                                            });

                                            textPlaceHolder();

                                            Navigator.of(context).pop();
                                          },
                                          style: ButtonStyle(
                                            overlayColor:
                                                MaterialStateProperty.all(
                                              const Color.fromARGB(
                                                  255, 235, 242, 255),
                                            ),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        widthOfWholeScreen),
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            'Save Selected Day',
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 0, 94, 255),
                                              fontFamily: 'FredokaOne-Regular',
                                              fontSize: (MediaQuery.of(context)
                                                          .orientation ==
                                                      Orientation.portrait)
                                                  ? widthOfWholeScreen / 25
                                                  : heightOfWholeScreen / 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    // A space between selecting on calendar and day of week
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 20
                          : heightOfWholeScreen / 20,
                    ),
                    // the day of the week to select to alarm
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // sunday
                          TextButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widthOfWholeScreen),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isSunday = !isSunday;
                              });
                            },
                            child: Text(
                              "Su",
                              style: TextStyle(
                                color: (isSunday)
                                    ? const Color.fromARGB(255, 255, 17, 0)
                                    : const Color.fromARGB(100, 255, 17, 0),
                                fontFamily: "Roboto-Black",
                                fontSize: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 14
                                    : heightOfWholeScreen / 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Monday
                          TextButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widthOfWholeScreen),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isMonday = !isMonday;
                              });
                            },
                            child: Text(
                              "Mo",
                              style: TextStyle(
                                color: (isMonday)
                                    ? const Color.fromARGB(255, 7, 0, 196)
                                    : const Color.fromARGB(100, 7, 0, 196),
                                fontFamily: "Roboto-Black",
                                fontSize: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 14
                                    : heightOfWholeScreen / 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Tuesday
                          TextButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widthOfWholeScreen),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isTuesday = !isTuesday;
                              });
                            },
                            child: Text(
                              "Tu",
                              style: TextStyle(
                                color: (isTuesday)
                                    ? const Color.fromARGB(255, 7, 0, 196)
                                    : const Color.fromARGB(100, 7, 0, 196),
                                fontFamily: "Roboto-Black",
                                fontSize: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 14
                                    : heightOfWholeScreen / 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Wednesday
                          TextButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widthOfWholeScreen),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isWednesday = !isWednesday;
                              });
                            },
                            child: Text(
                              "We",
                              style: TextStyle(
                                color: (isWednesday)
                                    ? const Color.fromARGB(255, 7, 0, 196)
                                    : const Color.fromARGB(100, 7, 0, 196),
                                fontFamily: "Roboto-Black",
                                fontSize: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 14
                                    : heightOfWholeScreen / 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Thursday
                          TextButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widthOfWholeScreen),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isThursday = !isThursday;
                              });
                            },
                            child: Text(
                              "Th",
                              style: TextStyle(
                                color: (isThursday)
                                    ? const Color.fromARGB(255, 7, 0, 196)
                                    : const Color.fromARGB(100, 7, 0, 196),
                                fontFamily: "Roboto-Black",
                                fontSize: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 14
                                    : heightOfWholeScreen / 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Friday
                          TextButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widthOfWholeScreen),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isFriday = !isFriday;
                              });
                            },
                            child: Text(
                              "Fr",
                              style: TextStyle(
                                color: (isFriday)
                                    ? const Color.fromARGB(255, 7, 0, 196)
                                    : const Color.fromARGB(100, 7, 0, 196),
                                fontFamily: "Roboto-Black",
                                fontSize: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 14
                                    : heightOfWholeScreen / 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Saturday
                          TextButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widthOfWholeScreen),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isSaturday = !isSaturday;
                              });
                            },
                            child: Text(
                              "Sa",
                              style: TextStyle(
                                color: (isSaturday)
                                    ? const Color.fromARGB(255, 7, 0, 196)
                                    : const Color.fromARGB(100, 7, 0, 196),
                                fontFamily: "Roboto-Black",
                                fontSize: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 14
                                    : heightOfWholeScreen / 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Space betweeen the day selection and Name Edit Field
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    // Enterin the name of the alarm
                    Container(
                      width: widthOfWholeScreen,
                      margin: EdgeInsets.only(
                        left: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 17
                            : heightOfWholeScreen / 17,
                        right: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 17
                            : heightOfWholeScreen / 17,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 20
                              : heightOfWholeScreen / 20,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 0),
                            color: Color.fromARGB(40, 0, 0, 0),
                            blurRadius: 50,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: nameTextEditingController,
                        cursorHeight: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 18
                            : heightOfWholeScreen / 18,
                        style: TextStyle(
                          fontSize: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 18
                              : heightOfWholeScreen / 18,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 20
                                  : heightOfWholeScreen / 20,
                            ),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 20
                                  : heightOfWholeScreen / 20,
                            ),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 20
                                  : heightOfWholeScreen / 20,
                            ),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 20
                                  : heightOfWholeScreen / 20,
                            ),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          hintText: "Alarm name ...",
                          hintStyle: TextStyle(
                            fontSize: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 18
                                : heightOfWholeScreen / 18,
                          ),
                          contentPadding: EdgeInsets.only(
                            left: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 15
                                : heightOfWholeScreen / 15,
                            top: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 20
                                : heightOfWholeScreen / 20,
                            bottom: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 20
                                : heightOfWholeScreen / 20,
                          ),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                        ),
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    // Space betweeen the alarm sound selection and Name Edit Field
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    // Sound Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                "Alarm sound",
                                style: TextStyle(
                                  fontFamily: "Roboto-Black",
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 20
                                          : heightOfWholeScreen / 20,
                                  color: const Color.fromARGB(255, 30, 30, 30),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 500
                                  : heightOfWholeScreen / 500,
                            ),
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                "Beep Once",
                                style: TextStyle(
                                  fontFamily: "Roboto-Regular",
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 30
                                          : heightOfWholeScreen / 30,
                                  color: const Color.fromARGB(255, 0, 123, 255),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 12
                              : heightOfWholeScreen / 12,
                        ),
                        Container(
                          height: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 6
                              : heightOfWholeScreen / 6,
                          width: 1,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(40, 83, 83, 83),
                            borderRadius:
                                BorderRadius.circular(widthOfWholeScreen),
                          ),
                          // child: Text("Hi"),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? 0
                              : heightOfWholeScreen / 100,
                        ),
                        Transform.scale(
                          scale: 1.6,
                          child: CupertinoSwitch(
                            value: isAlarmHaveSound,
                            onChanged: (value) {
                              setState(() {
                                isAlarmHaveSound = value;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 0, 123, 255),
                          ),
                        ),
                      ],
                    ),
                    // Space between the Alarm sound and Vibration
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    // The divider between the Alarm sound and the bellow weidget one
                    Container(
                      width: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 1.2
                          : heightOfWholeScreen / 1.2,
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(40, 83, 83, 83),
                        borderRadius: BorderRadius.circular(widthOfWholeScreen),
                      ),
                      // child: Text("Hi"),
                    ),
                    // Space between the Alarm sound and Vibration
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    // Vibration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                "Vibration",
                                style: TextStyle(
                                  fontFamily: "Roboto-Black",
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 20
                                          : heightOfWholeScreen / 20,
                                  color: const Color.fromARGB(255, 30, 30, 30),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 500
                                  : heightOfWholeScreen / 500,
                            ),
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                "Basic Call",
                                style: TextStyle(
                                  fontFamily: "Roboto-Regular",
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 30
                                          : heightOfWholeScreen / 30,
                                  color: const Color.fromARGB(255, 0, 123, 255),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 12
                              : heightOfWholeScreen / 3,
                        ),
                        Container(
                          height: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 6
                              : heightOfWholeScreen / 6,
                          width: 1,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(60, 83, 83, 83),
                            borderRadius:
                                BorderRadius.circular(widthOfWholeScreen),
                          ),
                          // child: Text("Hi"),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? 0
                              : heightOfWholeScreen / 40,
                        ),
                        Transform.scale(
                          scale: 1.6,
                          child: CupertinoSwitch(
                            value: isAlarmHasSnooze,
                            onChanged: (value) {
                              setState(() {
                                isAlarmHasSnooze = value;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 0, 123, 255),
                          ),
                        ),
                      ],
                    ),
                    // Space between the Alarm sound and Vibration
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    // The divider between the Alarm sound and the bellow weidget one
                    Container(
                      width: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 1.2
                          : heightOfWholeScreen / 1.2,
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(60, 83, 83, 83),
                        borderRadius: BorderRadius.circular(widthOfWholeScreen),
                      ),
                      // child: Text("Hi"),
                    ),
                    // Space between the Alarm sound and Vibration
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    // Snooze
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                "Snooze",
                                style: TextStyle(
                                  fontFamily: "Roboto-Black",
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 20
                                          : heightOfWholeScreen / 20,
                                  color: const Color.fromARGB(255, 30, 30, 30),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 500
                                  : heightOfWholeScreen / 500,
                            ),
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                "5 minutes, 3 times",
                                style: TextStyle(
                                  fontFamily: "Roboto-Regular",
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 30
                                          : heightOfWholeScreen / 30,
                                  color: const Color.fromARGB(255, 0, 123, 255),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 12
                              : heightOfWholeScreen / 3,
                        ),
                        Container(
                          height: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 6
                              : heightOfWholeScreen / 6,
                          width: 1,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(60, 83, 83, 83),
                            borderRadius:
                                BorderRadius.circular(widthOfWholeScreen),
                          ),
                          // child: Text("Hi"),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 40
                              : heightOfWholeScreen / 40,
                        ),
                        Transform.scale(
                          scale: 1.6,
                          child: CupertinoSwitch(
                            value: isAlarmHasVibration,
                            onChanged: (value) {
                              setState(() {
                                isAlarmHasVibration = value;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 0, 123, 255),
                          ),
                        ),
                      ],
                    ),
                    // Space between the Alarm sound and Vibration
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              CustomSlideTransitionPageRoute(
                                child: const AlarmScreen(
                                  currentBottomnavigationBarIndex:
                                      BottomNavigaionBarIndex.alarm,
                                ),
                                direction: AxisDirection.down,
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 202, 201, 255)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widthOfWholeScreen),
                              ),
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.only(
                                top: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 35
                                    : heightOfWholeScreen / 35,
                                bottom: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 35
                                    : heightOfWholeScreen / 35,
                                right: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 10
                                    : heightOfWholeScreen / 10,
                                left: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 10
                                    : heightOfWholeScreen / 10,
                              ),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 20
                                  : heightOfWholeScreen / 20,
                              fontFamily: "Roboto-Black",
                              color: const Color.fromARGB(255, 0, 79, 170),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            String days = "";

                            if (isSaturday) {
                              days = "${days}1";
                            }
                            if (isSunday) {
                              days = "${days}2";
                            }
                            if (isMonday) {
                              days = "${days}3";
                            }
                            if (isTuesday) {
                              days = "${days}4";
                            }
                            if (isWednesday) {
                              days = "${days}5";
                            }
                            if (isThursday) {
                              days = "${days}6";
                            }
                            if (isFriday) {
                              days = "${days}7";
                            }

                            if ((isSaturday == false) &&
                                (isSunday == false) &&
                                (isMonday == false) &&
                                (isTuesday == false) &&
                                (isWednesday == false) &&
                                (isThursday == false) &&
                                (isFriday == false)) {
                              days = _selectedDate;
                            }

                            var uuid = const Uuid();

                            if (widget.indexOfAlarm == -1) {
                              addingToAlarms(
                                nameTextEditingController.text,
                                days,
                                "${((_hourValue < 10) && (_hourValue >= 0)) ? "0$_hourValue" : _hourValue}:${((_minValue < 10) && (_minValue >= 0)) ? "0$_minValue" : _minValue}",
                                uuid.v1().toString(),
                                true,
                              );
                            } else {
                              BlocProvider.of<AlarmCubit>(context)
                                  .editingTheAlarm(
                                name: nameTextEditingController.text,
                                day: days,
                                time:
                                    "${((_hourValue < 10) && (_hourValue >= 0)) ? "0$_hourValue" : _hourValue}:${((_minValue < 10) && (_minValue >= 0)) ? "0$_minValue" : _minValue}",
                                isToggle: true,
                                index: widget.indexOfAlarm,
                              );
                            }

                            changeToTrue();

                            Future.delayed(const Duration(milliseconds: 600),
                                () {
                              Navigator.of(context).pushReplacement(
                                CustomSlideTransitionPageRoute(
                                  child: const AlarmScreen(
                                    currentBottomnavigationBarIndex:
                                        BottomNavigaionBarIndex.alarm,
                                  ),
                                  direction: AxisDirection.down,
                                ),
                              );
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 4, 0, 255)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widthOfWholeScreen),
                              ),
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.only(
                                top: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 35
                                    : heightOfWholeScreen / 35,
                                bottom: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 35
                                    : heightOfWholeScreen / 35,
                                right: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 8
                                    : heightOfWholeScreen / 8,
                                left: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 8
                                    : heightOfWholeScreen / 8,
                              ),
                            ),
                          ),
                          child: (showingCircularProgree)
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Save",
                                  style: TextStyle(
                                    fontSize:
                                        (MediaQuery.of(context).orientation ==
                                                Orientation.portrait)
                                            ? widthOfWholeScreen / 20
                                            : heightOfWholeScreen / 20,
                                    fontFamily: "Roboto-Black",
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
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
