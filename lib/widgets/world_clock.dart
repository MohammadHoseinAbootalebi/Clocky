import 'package:clock_app/cubit/worldTimeZone/world_time_zone_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorldClock extends StatefulWidget {
  const WorldClock({
    super.key,
  });

  @override
  State<WorldClock> createState() => _WorldClockState();
}

class _WorldClockState extends State<WorldClock> {
  bool _showCircularProgressForRemaingnWorldClock = true;

  void changeShowEarchImageBoolean(bool boolean) {
    _showCircularProgressForRemaingnWorldClock = boolean;
    // setState(() {
    //   _showCircularProgressForRemaingnWorldClock = boolean;
    // });
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        // _showCircularProgressForRemaingnWorldClock = false;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        _showCircularProgressForRemaingnWorldClock =
            !_showCircularProgressForRemaingnWorldClock;
        _showCircularProgressForRemaingnWorldClock =
            !_showCircularProgressForRemaingnWorldClock;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<WorldTimeZoneCubit>(context).initializingWorldTimeZones();

    double widthOfWholeScreen = MediaQuery.of(context).size.width;
    double heightOfWholeScreen = MediaQuery.of(context).size.height;

    int counter = BlocProvider.of<WorldTimeZoneCubit>(context)
        .calculatingTheNumberOfTimeZones();

    if (counter == 0) {
      _showCircularProgressForRemaingnWorldClock = false;
    } else {
      _showCircularProgressForRemaingnWorldClock = true;
    }

    return Container(
      width: widthOfWholeScreen,
      height: heightOfWholeScreen,
      margin: EdgeInsets.only(
        top: widthOfWholeScreen / 3.5,
        bottom: widthOfWholeScreen / 5,
      ),
      child: BlocBuilder<WorldTimeZoneCubit, WorldTimeZoneState>(
        builder: (_, state) {
          print("Number of time zones : ${state.numberOfWorldTimeZones}");
          print("List of time zones : ${state.worldTimeZonesInList}");

          return ((state.numberOfWorldTimeZones! > -1) &&
                  (state.worldTimeZones != "") &&
                  (BlocProvider.of<WorldTimeZoneCubit>(context)
                          .calculatingTheNumberOfTimeZones() !=
                      0))
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: BlocProvider.of<WorldTimeZoneCubit>(context)
                      .calculatingTheNumberOfTimeZones(),
                  itemBuilder: (_, index) {
                    return Dismissible(
                      key: Key(state.worldTimeZonesInList![index][0]),
                      onDismissed: (_) {
                        BlocProvider.of<WorldTimeZoneCubit>(context)
                            .deleteWorldTimeZone(index);
                      },
                      background: Container(
                        margin: const EdgeInsets.only(
                          bottom: 50,
                          left: 45,
                          right: 45,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.all(
                            Radius.circular(widthOfWholeScreen / 15),
                          ),
                        ),
                        child: Center(
                          child: ListTile(
                            leading: Text(
                              "Delete this timezone",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 60, 60, 60),
                                fontFamily: 'FredokaOne-Regular',
                                fontWeight: FontWeight.w100,
                                fontSize: widthOfWholeScreen / 30,
                              ),
                            ),
                            trailing: Icon(
                              Icons.delete,
                              size: widthOfWholeScreen / 15,
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                          bottom: 50,
                          left: 45,
                          right: 45,
                        ),
                        height: widthOfWholeScreen / 3.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(widthOfWholeScreen / 15),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(25, 0, 0, 0),
                              blurRadius: 20,
                              offset: Offset(0, 11),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Showing the name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      left: 30,
                                    ),
                                    child: Text(
                                      state.worldTimeZonesInList?[index][0],
                                      // BlocProvider.of<WorldTimeZoneCubit>(context).gettingSpecifiedZone(index)[0],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 7, 0, 196),
                                        fontFamily: 'FredokaOne-Regular',
                                        fontWeight: FontWeight.w100,
                                        fontSize: widthOfWholeScreen / 20,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      right: 30,
                                    ),
                                    child: Text(
                                      () {
                                        String country_time = "";

                                        DateTime current_date =
                                            DateTime.now().toUtc();
                                        print(current_date);

                                        if (state.worldTimeZonesInList?[index]
                                                [4] ==
                                            "After") {
                                          DateTime dummyToAddTimeZones =
                                              current_date.add(
                                            Duration(
                                              hours:
                                                  state.worldTimeZonesInList?[
                                                      index][1],
                                              minutes:
                                                  state.worldTimeZonesInList?[
                                                      index][2],
                                              seconds:
                                                  state.worldTimeZonesInList?[
                                                      index][3],
                                            ),
                                          );

                                          country_time = "${() {
                                            if (dummyToAddTimeZones.hour < 10) {
                                              return "0${dummyToAddTimeZones.hour}";
                                            } else {
                                              return "${dummyToAddTimeZones.hour}";
                                            }
                                          }()}:${() {
                                            if (dummyToAddTimeZones.minute <
                                                10) {
                                              return "0${dummyToAddTimeZones.minute}";
                                            } else {
                                              return "${dummyToAddTimeZones.minute}";
                                            }
                                          }()}";
                                        }
                                        if (state.worldTimeZonesInList?[index]
                                                [4] ==
                                            "Behind") {
                                          DateTime dummyToAddTimeZones =
                                              current_date.add(
                                            Duration(
                                              hours:
                                                  state.worldTimeZonesInList?[
                                                      index][1],
                                              minutes:
                                                  state.worldTimeZonesInList?[
                                                      index][2],
                                              seconds:
                                                  state.worldTimeZonesInList?[
                                                      index][3],
                                            ),
                                          );

                                          country_time = "${() {
                                            if (dummyToAddTimeZones.hour < 10) {
                                              return "0${dummyToAddTimeZones.hour}";
                                            } else {
                                              return "${dummyToAddTimeZones.hour}";
                                            }
                                          }()}:${() {
                                            if (dummyToAddTimeZones.minute <
                                                10) {
                                              return "0${dummyToAddTimeZones.minute}";
                                            } else {
                                              return "${dummyToAddTimeZones.minute}";
                                            }
                                          }()}";
                                        }

                                        // current_date.hour +
                                        //     ;

                                        return country_time;
                                      }(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 0, 163, 255),
                                        fontFamily: 'FredokaOne-Regular',
                                        fontWeight: FontWeight.w100,
                                        fontSize: widthOfWholeScreen / 20,
                                      ),
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
                )
              : Center(
                  child: Image.asset(
                    'lib/assets/pngs/Earth.png',
                    width: widthOfWholeScreen / 0.9,
                    height: widthOfWholeScreen / 0.9,
                  ),
                );
        },
      ),
    );
  }
}
