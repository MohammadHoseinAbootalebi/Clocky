import 'package:clock_app/assets/icons/widgets/search_icons.dart';
import 'package:clock_app/cubit/worldTimeZone/world_time_zone_cubit.dart';
import 'package:clock_app/screens/alarm_screen.dart';
import 'package:clock_app/widgets/fade_page_route.dart';
import 'package:clock_app/widgets/list_wheel_view_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/timezoes_locations.dart';

class AddingTimeCitiesAroundTheWorld extends StatefulWidget {
  const AddingTimeCitiesAroundTheWorld({super.key});

  @override
  State<AddingTimeCitiesAroundTheWorld> createState() =>
      _AddingTimeCitiesAroundTheWorldState();
}

class _AddingTimeCitiesAroundTheWorldState
    extends State<AddingTimeCitiesAroundTheWorld> {
  void addingTimeZone(String cityName, int hour, int minute, int second,
      String afterOrBefore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? worldClokTimeZones = prefs.getString('WorldClockTimeZones');

    // check whether the worldClokTimeZones is null so this is first initialization
    if (worldClokTimeZones == "") {
      worldClokTimeZones = "<$cityName|${() {
        if (hour < 10) {
          return "0$hour";
        } else {
          return "$hour";
        }
      }()}|${() {
        if (minute < 10) {
          return "0$minute";
        } else {
          return "$minute";
        }
      }()}|${() {
        if (second < 10) {
          return "0$second";
        } else {
          return "$second";
        }
      }()}|$afterOrBefore>";
    }
    // if worldClokTimeZones is not null so the worldclocktimezone should be added
    else {
      // You should check whether the worldClokTimeZones shouldn't have duplicated time zone. With for loop or ....

      bool isNOTDublicate = false;

      for (int counter = 0; counter < worldClokTimeZones!.length; ++counter) {
        // starting the world time zone
        if (worldClokTimeZones[counter] == "<") {
          // innerIndex is for start to find next |
          int innerIndex = counter + 1;
          bool finished = true;
          // a string to store result of search
          String findString = "";
          while (finished) {
            if (worldClokTimeZones[innerIndex] != "|") {
              findString = "$findString${worldClokTimeZones[innerIndex]}";
            } else {
              finished = false;
              break;
            }

            innerIndex = innerIndex + 1;
          }

          if (cityName == findString) {
            isNOTDublicate = false;
            break;
          } else {
            isNOTDublicate = true;
          }
        }
      }

      if (isNOTDublicate == true) {
        worldClokTimeZones = "$worldClokTimeZones<$cityName|${() {
          if (hour < 10) {
            return "0$hour";
          } else {
            return "$hour";
          }
        }()}|${() {
          if (minute < 10) {
            return "0$minute";
          } else {
            return "$minute";
          }
        }()}|${() {
          if (second < 10) {
            return "0$second";
          } else {
            return "$second";
          }
        }()}|$afterOrBefore>";

        isNOTDublicate = false;
      }
    }

    print(worldClokTimeZones);

    prefs.setString('WorldClockTimeZones', worldClokTimeZones);
    // prefs.remove('WorldClockTimeZones');
  }

  @override
  Widget build(BuildContext contextOfWholeScreen) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    double itemWidth = 60.0;
    int itemCount = 100;
    int selected = 50;
    FixedExtentScrollController _scrollController =
        FixedExtentScrollController(initialItem: 50);

    double widthOfWholeScreen = MediaQuery.of(contextOfWholeScreen).size.width;
    double heigthOfWholeScreen =
        MediaQuery.of(contextOfWholeScreen).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(contextOfWholeScreen).size.height * 0.09,
        ),
        child: AppBar(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          toolbarHeight: 100,
          actions: [
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(contextOfWholeScreen).size.width / 8,
                top: MediaQuery.of(contextOfWholeScreen).size.width / 15,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Search.search,
                  color: const Color.fromARGB(255, 0, 7, 215),
                  size: MediaQuery.of(contextOfWholeScreen).size.width / 12,
                  // weight: 2,
                ),
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
          ],
          title: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(contextOfWholeScreen).size.width / 15,
              top: MediaQuery.of(contextOfWholeScreen).size.width / 15,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(contextOfWholeScreen).pushReplacement(
                  FadePageRoute(
                    const AlarmScreen(
                      currentBottomnavigationBarIndex:
                          BottomNavigaionBarIndex.worldClock,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: const Color.fromARGB(255, 0, 7, 215),
                weight: 10,
                size: MediaQuery.of(contextOfWholeScreen).size.width / 20,
              ),
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(contextOfWholeScreen).size.width,
        height: MediaQuery.of(contextOfWholeScreen).size.height * 0.9,
        child: ListView(
          scrollDirection: Axis.vertical,
          // itemExtent: MediaQuery.of(contextOfWholeScreen).size.height * 0.08,
          children: <Widget>[
            for (int counter = 0;
                counter < timeZonesLocations.length;
                ++counter) ...[
              Builder(
                builder: (_) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(contextOfWholeScreen).size.height *
                          0.03,
                      bottom: MediaQuery.of(contextOfWholeScreen).size.height *
                          0.01,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(contextOfWholeScreen).size.height *
                            0.03,
                        right: MediaQuery.of(contextOfWholeScreen).size.height *
                            0.03,
                      ),
                      width: MediaQuery.of(contextOfWholeScreen).size.width,
                      height: MediaQuery.of(contextOfWholeScreen).size.height *
                          0.09,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 153, 255),
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(contextOfWholeScreen).size.height *
                              0.009,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          timeZonesLocations[counter]['Country']![0].toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(contextOfWholeScreen)
                                    .size
                                    .height *
                                0.025,
                            fontFamily: 'FredokaOne-Regular',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              for (int inderIndex = 0;
                  inderIndex < timeZonesLocations[counter]['City']!.length;
                  ++inderIndex)
                Builder(
                  builder: (context) {
                    return SizedBox(
                      height:
                          MediaQuery.of(contextOfWholeScreen).size.height * 0.1,
                      child: Padding(
                        padding: EdgeInsets.only(
                          // top: MediaQuery.of(contextOfWholeScreen).size.height *
                          //     0.01,
                          bottom:
                              MediaQuery.of(contextOfWholeScreen).size.height *
                                  0.01,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showDialog<void>(
                              context: contextOfWholeScreen,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        widthOfWholeScreen / 20),
                                  ),
                                  title: Text(
                                    'Notice',
                                    style: TextStyle(
                                      fontFamily: 'FredokaOne-Regular',
                                      // fontWeight: FontWeight.bold,
                                      fontSize: widthOfWholeScreen / 25,
                                      color:
                                          const Color.fromARGB(255, 7, 0, 196),
                                    ),
                                  ),
                                  content: Text(
                                    'Are you sure adding ${timeZonesLocations[counter]['City']![inderIndex]['Name']} time zone ?',
                                    style: TextStyle(
                                      fontFamily: 'FredokaOne-Regular',
                                      fontSize: widthOfWholeScreen / 30,
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: Text(
                                        'Yes, I\'m sure',
                                        style: TextStyle(
                                          fontFamily: 'FredokaOne-Regular',
                                          fontSize: widthOfWholeScreen / 30,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        addingTimeZone(
                                          timeZonesLocations[counter]
                                              ['City']![inderIndex]['Name'],
                                          timeZonesLocations[counter]
                                              ['City']![inderIndex]['Hours'],
                                          timeZonesLocations[counter]
                                              ['City']![inderIndex]['Minutes'],
                                          timeZonesLocations[counter]
                                              ['City']![inderIndex]['Seconds'],
                                          timeZonesLocations[counter]
                                                  ['City']![inderIndex]
                                              ['BehindOrAfter'],
                                        );

                                        BlocProvider.of<WorldTimeZoneCubit>(
                                                context)
                                            .changeTheNumberOfTimeZones();
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      child: Text(
                                        'No, neglect that',
                                        style: TextStyle(
                                          fontFamily: 'FredokaOne-Regular',
                                          fontSize: widthOfWholeScreen / 30,
                                          color: const Color.fromARGB(
                                              255, 171, 171, 171),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(contextOfWholeScreen)
                                      .size
                                      .height *
                                  0.02,
                              right: MediaQuery.of(contextOfWholeScreen)
                                      .size
                                      .height *
                                  0.02,
                            ),
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(contextOfWholeScreen)
                                      .size
                                      .height *
                                  0.03,
                              right: MediaQuery.of(contextOfWholeScreen)
                                      .size
                                      .height *
                                  0.03,
                            ),
                            width:
                                MediaQuery.of(contextOfWholeScreen).size.width,
                            height: MediaQuery.of(contextOfWholeScreen)
                                    .size
                                    .height *
                                0.09,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 154, 211, 255),
                              borderRadius: BorderRadius.circular(
                                MediaQuery.of(contextOfWholeScreen)
                                        .size
                                        .height *
                                    0.009,
                              ),
                            ),
                            child: Center(
                              child: ListTile(
                                leading: Text(
                                  timeZonesLocations[counter]
                                          ['City']![inderIndex]['Name']
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(contextOfWholeScreen)
                                                .size
                                                .height *
                                            0.025,
                                    fontFamily: 'FredokaOne-Regular',
                                  ),
                                ),
                                trailing: Text(
                                  () {
                                    String timeOfCity = "UTC";

                                    if (timeZonesLocations[counter]
                                                    ['City']![inderIndex]
                                                ['BehindOrAfter']
                                            .toString() ==
                                        "After") {
                                      timeOfCity = "UTC +";
                                    }
                                    if (timeZonesLocations[counter]
                                                    ['City']![inderIndex]
                                                ['BehindOrAfter']
                                            .toString() ==
                                        "Behind") {
                                      timeOfCity = "UTC -";
                                    }

                                    timeOfCity = "$timeOfCity ${() {
                                      if (timeZonesLocations[counter]
                                              ['City']![inderIndex]['Hours'] ==
                                          0) {
                                        return "00";
                                      } else if (timeZonesLocations[counter]
                                              ['City']![inderIndex]['Hours'] <
                                          10) {
                                        return "0${timeZonesLocations[counter]['City']![inderIndex]['Hours']}";
                                      } else if (timeZonesLocations[counter]
                                              ['City']![inderIndex]['Hours'] >=
                                          10) {
                                        return "${timeZonesLocations[counter]['City']![inderIndex]['Hours']}";
                                      }
                                    }()}:${() {
                                      if (timeZonesLocations[counter]
                                                  ['City']![inderIndex]
                                              ['Minutes'] ==
                                          0) {
                                        return "00";
                                      } else if (timeZonesLocations[counter]
                                              ['City']![inderIndex]['Minutes'] <
                                          10) {
                                        return "0${timeZonesLocations[counter]['City']![inderIndex]['Minutes']}";
                                      } else if (timeZonesLocations[counter]
                                                  ['City']![inderIndex]
                                              ['Minutes'] >=
                                          10) {
                                        return "${timeZonesLocations[counter]['City']![inderIndex]['Minutes']}";
                                      }
                                    }()}";

                                    return timeOfCity;
                                  }(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(contextOfWholeScreen)
                                                .size
                                                .height *
                                            0.025,
                                    fontFamily: 'FredokaOne-Regular',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ],
        ),
      ),
      // ScrollConfiguration(
      //   behavior: const ScrollBehavior(),
      //   child: GlowingOverscrollIndicator(
      //     axisDirection: AxisDirection.down,
      //     color: const Color.fromARGB(255, 240, 240, 240),
      //     child: ListWheelScrollView(
      //       itemExtent: MediaQuery.of(contextOfWholeScreen).size.height * 0.1,
      //       useMagnifier: true,
      //       diameterRatio: 4,
      //       children: <Widget>[
      //         for (int counter = 0;
      //             counter < timeZonesLocations.length;
      //             ++counter) ...[
      //           Builder(
      //             builder: (_) {
      //               return FittedBox(
      //                 child: Column(
      //                   children: [
      //                     Container(
      //                       margin: EdgeInsets.only(
      //                         left: MediaQuery.of(contextOfWholeScreen)
      //                                 .size
      //                                 .height *
      //                             0.03,
      //                         right: MediaQuery.of(contextOfWholeScreen)
      //                                 .size
      //                                 .height *
      //                             0.03,
      //                       ),
      //                       width:
      //                           MediaQuery.of(contextOfWholeScreen).size.width,
      //                       height: MediaQuery.of(contextOfWholeScreen)
      //                               .size
      //                               .height *
      //                           0.09,
      //                       decoration: BoxDecoration(
      //                         color: const Color.fromARGB(255, 0, 153, 255),
      //                         borderRadius: BorderRadius.circular(
      //                           MediaQuery.of(contextOfWholeScreen)
      //                                   .size
      //                                   .height *
      //                               0.009,
      //                         ),
      //                       ),
      //                       child: Center(
      //                         child: Text(
      //                           timeZonesLocations[counter]['Country']![0]
      //                               .toString(),
      //                           style: TextStyle(
      //                             color: Colors.white,
      //                             fontSize: MediaQuery.of(contextOfWholeScreen)
      //                                     .size
      //                                     .height *
      //                                 0.025,
      //                             fontFamily: 'FredokaOne-Regular',
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               );
      //             },
      //           ),
      //           for (int inderIndex = 0;
      //               inderIndex < timeZonesLocations[counter]['City']!.length;
      //               ++inderIndex)
      //             Builder(
      //               builder: (context) {
      //                 return SizedBox(
      //                   height:
      //                       MediaQuery.of(contextOfWholeScreen).size.height *
      //                           0.01,
      //                   child: FittedBox(
      //                     child: Container(
      //                       padding: EdgeInsets.only(
      //                         left: MediaQuery.of(contextOfWholeScreen)
      //                                 .size
      //                                 .height *
      //                             0.02,
      //                         right: MediaQuery.of(contextOfWholeScreen)
      //                                 .size
      //                                 .height *
      //                             0.02,
      //                       ),
      //                       margin: EdgeInsets.only(
      //                         left: MediaQuery.of(contextOfWholeScreen)
      //                                 .size
      //                                 .height *
      //                             0.03,
      //                         right: MediaQuery.of(contextOfWholeScreen)
      //                                 .size
      //                                 .height *
      //                             0.03,
      //                       ),
      //                       width:
      //                           MediaQuery.of(contextOfWholeScreen).size.width,
      //                       height: MediaQuery.of(contextOfWholeScreen)
      //                               .size
      //                               .height *
      //                           0.09,
      //                       decoration: BoxDecoration(
      //                         color: const Color.fromARGB(255, 154, 211, 255),
      //                         borderRadius: BorderRadius.circular(
      //                           MediaQuery.of(contextOfWholeScreen)
      //                                   .size
      //                                   .height *
      //                               0.009,
      //                         ),
      //                       ),
      //                       child: Center(
      //                         child: GestureDetector(
      //                           onLongPress: () {
      //                             print("Pressed !");
      //                           },
      //                           child: ListTile(
      //                             leading: Text(
      //                               timeZonesLocations[counter]
      //                                       ['City']![inderIndex]['Name']
      //                                   .toString(),
      //                               style: TextStyle(
      //                                 color: Colors.white,
      //                                 fontSize:
      //                                     MediaQuery.of(contextOfWholeScreen)
      //                                             .size
      //                                             .height *
      //                                         0.025,
      //                                 fontFamily: 'FredokaOne-Regular',
      //                               ),
      //                             ),
      //                             trailing: Text(
      //                               () {
      //                                 String timeOfCity = "UTC";

      //                                 if (timeZonesLocations[counter]
      //                                                 ['City']![inderIndex]
      //                                             ['BehindOrAfter']
      //                                         .toString() ==
      //                                     "After") {
      //                                   timeOfCity = "UTC +";
      //                                 }
      //                                 if (timeZonesLocations[counter]
      //                                                 ['City']![inderIndex]
      //                                             ['BehindOrAfter']
      //                                         .toString() ==
      //                                     "Behind") {
      //                                   timeOfCity = "UTC -";
      //                                 }

      //                                 timeOfCity = "$timeOfCity ${() {
      //                                   if (timeZonesLocations[counter]
      //                                               ['City']![inderIndex]
      //                                           ['Hours'] ==
      //                                       0) {
      //                                     return "00";
      //                                   } else if (timeZonesLocations[counter]
      //                                           ['City']![inderIndex]['Hours'] <
      //                                       10) {
      //                                     return "0${timeZonesLocations[counter]['City']![inderIndex]['Hours']}";
      //                                   } else if (timeZonesLocations[counter]
      //                                               ['City']![inderIndex]
      //                                           ['Hours'] >=
      //                                       10) {
      //                                     return "${timeZonesLocations[counter]['City']![inderIndex]['Hours']}";
      //                                   }
      //                                 }()}:${() {
      //                                   if (timeZonesLocations[counter]
      //                                               ['City']![inderIndex]
      //                                           ['Minutes'] ==
      //                                       0) {
      //                                     return "00";
      //                                   } else if (timeZonesLocations[counter]
      //                                               ['City']![inderIndex]
      //                                           ['Minutes'] <
      //                                       10) {
      //                                     return "0${timeZonesLocations[counter]['City']![inderIndex]['Minutes']}";
      //                                   } else if (timeZonesLocations[counter]
      //                                               ['City']![inderIndex]
      //                                           ['Minutes'] >=
      //                                       10) {
      //                                     return "${timeZonesLocations[counter]['City']![inderIndex]['Minutes']}";
      //                                   }
      //                                 }()}";

      //                                 return timeOfCity;
      //                               }(),
      //                               style: TextStyle(
      //                                 color: Colors.white,
      //                                 fontSize:
      //                                     MediaQuery.of(contextOfWholeScreen)
      //                                             .size
      //                                             .height *
      //                                         0.025,
      //                                 fontFamily: 'FredokaOne-Regular',
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 );
      //               },
      //             ),
      //         ],
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
