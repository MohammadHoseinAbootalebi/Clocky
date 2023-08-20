import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'world_time_zone_state.dart';

class WorldTimeZoneCubit extends Cubit<WorldTimeZoneState> {
  WorldTimeZoneCubit()
      : super(WorldTimeZoneState(
          worldTimeZones: "",
          worldTimeZonesInList: [[], []],
          numberOfWorldTimeZones: 5,
        ));

  void initializingWorldTimeZones() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    state.worldTimeZones = _prefs.getString('WorldClockTimeZones');

    if (state.worldTimeZones != null) {
      String myString = state.worldTimeZones
          .toString(); // Getting the string from shared preferences

      List<List> myTimeZone = [];

      int lengthOfMyString =
          myString.length; // Getting the length of whole string
      // Go through all the character and reading the time zones
      for (int index = 0; index < lengthOfMyString; ++index) {
        // Check whether the time zone is started or not
        if (myString[index] == "<") {
          int localIndex =
              index + 1; // local number for go throught the time zone string
          int numberOfStraingLine = 0; // number of |

          // Allocating the containers data
          String name = "";
          String hour = "";
          String min = "";
          String secs = "";
          String IsBehindOrAfter = "";

          while (myString[localIndex] != ">") {
            // Check whether string come to | or not
            if (myString[localIndex] == "|") {
              ++numberOfStraingLine; // Increment the number |s
              ++localIndex; // Incrementing the localIndex to skip the | character
            }

            // Storing the time zone to its city
            if (numberOfStraingLine == 0) {
              name = name +
                  myString[
                      localIndex]; // Adding the character to the name string
            }

            // Storing the hour integer
            if (numberOfStraingLine == 1) {
              hour = hour + myString[localIndex];
            }

            // Storing the minute integer
            if (numberOfStraingLine == 2) {
              min = min + myString[localIndex];
            }

            // Storing the seconds integer
            if (numberOfStraingLine == 3) {
              secs = secs + myString[localIndex];
            }

            // Storing the behind or after
            if ((numberOfStraingLine == 4) && (myString[localIndex] != ">")) {
              IsBehindOrAfter = IsBehindOrAfter + myString[localIndex];
            }

            // increment the index for string
            ++localIndex;
          }

          if (myTimeZone.isEmpty == true) {
            myTimeZone.add([
              name,
              int.parse(hour),
              int.parse(min),
              int.parse(secs),
              IsBehindOrAfter
            ]); // Add this found time zone to the list
          }

          // After ending the while and reading each time zone store to the list
          for (int jdex = 0; jdex < myTimeZone.length; ++jdex) {
            // Check whether this element is in the myTimeZone or not
            if (myTimeZone.isEmpty == true) {
              myTimeZone.add([
                name,
                int.parse(hour),
                int.parse(min),
                int.parse(secs),
                IsBehindOrAfter
              ]); // Add this found time zone to the list
            } else {
              if (myTimeZone[jdex][0] == name) {
                // Do nothing
              } else {
                myTimeZone.add([
                  name,
                  int.parse(hour),
                  int.parse(min),
                  int.parse(secs),
                  IsBehindOrAfter
                ]); // Add this found time zone to the list
              }
            }
          }
        }
      }

      myTimeZone = Set.of(myTimeZone).toList();

      List<List> myTimeZoneWithoutRepeatedItems = [];

      for (int j = 0; j < myTimeZone.length; j++) {
        int indexOfDuplicatedItem = 0;
        String key = "";
        int numberOfDuplicatedItem = 0;

        for (int jdex = 0; jdex < myTimeZone.length; jdex++) {
          if (myTimeZone[j][0] == myTimeZone[jdex][0]) {
            numberOfDuplicatedItem = numberOfDuplicatedItem + 1;
            key = myTimeZone[jdex][0];
            indexOfDuplicatedItem = jdex;
          }
        }

        if (numberOfDuplicatedItem >= 2) {
          for (int a = 0; a < myTimeZone.length; a++) {
            int counterDup =
                0; // number of duplicated items int the myTimeZoneWithoutRepeatedItems list

            // loop through to count the number of key items in the myTimeZoneWithoutRepeatedItems list
            for (int adex = 0;
                adex < myTimeZoneWithoutRepeatedItems.length;
                adex++) {
              if (key == myTimeZoneWithoutRepeatedItems[adex][0]) {
                counterDup = counterDup + 1;
              }
            }

            if (counterDup >= 2) {
              // neglecting to addd the repeated item to the list
            } else if (counterDup == 0) {
              // there is no such key item so consider add one
              myTimeZoneWithoutRepeatedItems.add(
                [
                  myTimeZone[indexOfDuplicatedItem][0],
                  myTimeZone[indexOfDuplicatedItem][1],
                  myTimeZone[indexOfDuplicatedItem][2],
                  myTimeZone[indexOfDuplicatedItem][3],
                  myTimeZone[indexOfDuplicatedItem][4],
                ],
              );
            } else {
              // there is at least one key in the list so ignore adding more
            }
          }
        } else {
          myTimeZoneWithoutRepeatedItems.add(
            [
              myTimeZone[j][0],
              myTimeZone[j][1],
              myTimeZone[j][2],
              myTimeZone[j][3],
              myTimeZone[j][4],
            ],
          );
        }
      }

      state.worldTimeZonesInList = myTimeZoneWithoutRepeatedItems;
    }
  }

  void savingWorldTimeZones(String cityName, int hour, int minute, int second,
      String afterOrBefore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? worldClokTimeZones = prefs.getString('WorldClockTimeZones');

    // check whether the worldClokTimeZones is null so this is first initialization
    if (worldClokTimeZones == null) {
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

      for (int counter = 0; counter < worldClokTimeZones.length; ++counter) {
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
    state.worldTimeZones = worldClokTimeZones;
    // prefs.remove('WorldClockTimeZones');
  }

  int calculatingTheNumberOfTimeZones() {
    String? timezones = state.worldTimeZones;
    int numberofzones = 0;

    if ((timezones != null) && (timezones != "")) {
      for (int i = 0; i < state.worldTimeZones.toString().length; i++) {
        if (timezones.toString()[i] == "<") {
          numberofzones = numberofzones + 1;
        }
      }
    }

    return numberofzones;
  }

  void deleteWorldTimeZone(int nthTimeZone) async {
    String? timezones = state.worldTimeZones;
    int numberInZones = -1;
    String toWritezones = "";

    for (int i = 0; i < state.worldTimeZones.toString().length; i++) {
      if (timezones.toString()[i] == "<") {
        numberInZones = numberInZones + 1;
      }

      if (numberInZones == nthTimeZone) {
        // ignore this timezone
      } else {
        // should consider this time zone
        toWritezones = "$toWritezones${() {
          return timezones.toString()[i];
        }()}";
      }
    }

    state.worldTimeZones = toWritezones;
    // toWritezones = timezones!.replaceAll(toWritezones, "");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('WorldClockTimeZones', toWritezones);

    if (toWritezones == "") {
      int number = -1;


      state.worldTimeZones = toWritezones;

      List<List> myTimeZone = [];

      if (state.worldTimeZones != null) {
        String myString = state.worldTimeZones
            .toString(); // Getting the string from shared preferences

        int lengthOfMyString =
            myString.length; // Getting the length of whole string
        // Go through all the character and reading the time zones
        for (int index = 0; index < lengthOfMyString; ++index) {
          // Check whether the time zone is started or not
          if (myString[index] == "<") {
            int localIndex =
                index + 1; // local number for go throught the time zone string
            int numberOfStraingLine = 0; // number of |

            // Allocating the containers data
            String name = "";
            String hour = "";
            String min = "";
            String secs = "";
            String IsBehindOrAfter = "";

            while (myString[localIndex] != ">") {
              // Check whether string come to | or not
              if (myString[localIndex] == "|") {
                ++numberOfStraingLine; // Increment the number |s
                ++localIndex; // Incrementing the localIndex to skip the | character
              }

              // Storing the time zone to its city
              if (numberOfStraingLine == 0) {
                name = name +
                    myString[
                        localIndex]; // Adding the character to the name string
              }

              // Storing the hour integer
              if (numberOfStraingLine == 1) {
                hour = hour + myString[localIndex];
              }

              // Storing the minute integer
              if (numberOfStraingLine == 2) {
                min = min + myString[localIndex];
              }

              // Storing the seconds integer
              if (numberOfStraingLine == 3) {
                secs = secs + myString[localIndex];
              }

              // Storing the behind or after
              if ((numberOfStraingLine == 4) && (myString[localIndex] != ">")) {
                IsBehindOrAfter = IsBehindOrAfter + myString[localIndex];
              }

              // increment the index for string
              ++localIndex;
            }

            if (myTimeZone.isEmpty == true) {
              myTimeZone.add([
                name,
                int.parse(hour),
                int.parse(min),
                int.parse(secs),
                IsBehindOrAfter
              ]); // Add this found time zone to the list
            }

            // After ending the while and reading each time zone store to the list
            for (int jdex = 0; jdex < myTimeZone.length; ++jdex) {
              // Check whether this element is in the myTimeZone or not
              if (myTimeZone.isEmpty == true) {
                myTimeZone.add([
                  name,
                  int.parse(hour),
                  int.parse(min),
                  int.parse(secs),
                  IsBehindOrAfter
                ]); // Add this found time zone to the list
              } else {
                if (myTimeZone[jdex][0] == name) {
                  // Do nothing
                } else {
                  myTimeZone.add([
                    name,
                    int.parse(hour),
                    int.parse(min),
                    int.parse(secs),
                    IsBehindOrAfter
                  ]); // Add this found time zone to the list
                }
              }
            }
          }
        }
      }

      myTimeZone = Set.of(myTimeZone).toList();

      List<List> myTimeZoneWithoutRepeatedItems = [];

      for (int j = 0; j < myTimeZone.length; j++) {
        int indexOfDuplicatedItem = 0;
        String key = "";
        int numberOfDuplicatedItem = 0;

        for (int jdex = 0; jdex < myTimeZone.length; jdex++) {
          if (myTimeZone[j][0] == myTimeZone[jdex][0]) {
            numberOfDuplicatedItem = numberOfDuplicatedItem + 1;
            key = myTimeZone[jdex][0];
            indexOfDuplicatedItem = jdex;
          }
        }

        if (numberOfDuplicatedItem >= 2) {
          for (int a = 0; a < myTimeZone.length; a++) {
            int counterDup =
                0; // number of duplicated items int the myTimeZoneWithoutRepeatedItems list

            // loop through to count the number of key items in the myTimeZoneWithoutRepeatedItems list
            for (int adex = 0;
                adex < myTimeZoneWithoutRepeatedItems.length;
                adex++) {
              if (key == myTimeZoneWithoutRepeatedItems[adex][0]) {
                counterDup = counterDup + 1;
              }
            }

            if (counterDup >= 2) {
              // neglecting to addd the repeated item to the list
            } else if (counterDup == 0) {
              // there is no such key item so consider add one
              myTimeZoneWithoutRepeatedItems.add(
                [
                  myTimeZone[indexOfDuplicatedItem][0],
                  myTimeZone[indexOfDuplicatedItem][1],
                  myTimeZone[indexOfDuplicatedItem][2],
                  myTimeZone[indexOfDuplicatedItem][3],
                  myTimeZone[indexOfDuplicatedItem][4],
                ],
              );
            } else {
              // there is at least one key in the list so ignore adding more
            }
          }
        } else {
          myTimeZoneWithoutRepeatedItems.add(
            [
              myTimeZone[j][0],
              myTimeZone[j][1],
              myTimeZone[j][2],
              myTimeZone[j][3],
              myTimeZone[j][4],
            ],
          );
        }
      }

      emit(
        WorldTimeZoneState(
          numberOfWorldTimeZones: number,
          worldTimeZones: toWritezones,
          worldTimeZonesInList: myTimeZoneWithoutRepeatedItems,
        ),
      );
    } else {
      int number = 5;

      state.worldTimeZones = toWritezones;

      List<List> myTimeZone = [];

      if (state.worldTimeZones != null) {
        String myString = state.worldTimeZones
            .toString(); // Getting the string from shared preferences

        int lengthOfMyString =
            myString.length; // Getting the length of whole string
        // Go through all the character and reading the time zones
        for (int index = 0; index < lengthOfMyString; ++index) {
          // Check whether the time zone is started or not
          if (myString[index] == "<") {
            int localIndex =
                index + 1; // local number for go throught the time zone string
            int numberOfStraingLine = 0; // number of |

            // Allocating the containers data
            String name = "";
            String hour = "";
            String min = "";
            String secs = "";
            String IsBehindOrAfter = "";

            while (myString[localIndex] != ">") {
              // Check whether string come to | or not
              if (myString[localIndex] == "|") {
                ++numberOfStraingLine; // Increment the number |s
                ++localIndex; // Incrementing the localIndex to skip the | character
              }

              // Storing the time zone to its city
              if (numberOfStraingLine == 0) {
                name = name +
                    myString[
                        localIndex]; // Adding the character to the name string
              }

              // Storing the hour integer
              if (numberOfStraingLine == 1) {
                hour = hour + myString[localIndex];
              }

              // Storing the minute integer
              if (numberOfStraingLine == 2) {
                min = min + myString[localIndex];
              }

              // Storing the seconds integer
              if (numberOfStraingLine == 3) {
                secs = secs + myString[localIndex];
              }

              // Storing the behind or after
              if ((numberOfStraingLine == 4) && (myString[localIndex] != ">")) {
                IsBehindOrAfter = IsBehindOrAfter + myString[localIndex];
              }

              // increment the index for string
              ++localIndex;
            }

            if (myTimeZone.isEmpty == true) {
              myTimeZone.add([
                name,
                int.parse(hour),
                int.parse(min),
                int.parse(secs),
                IsBehindOrAfter
              ]); // Add this found time zone to the list
            }

            // After ending the while and reading each time zone store to the list
            for (int jdex = 0; jdex < myTimeZone.length; ++jdex) {
              // Check whether this element is in the myTimeZone or not
              if (myTimeZone.isEmpty == true) {
                myTimeZone.add([
                  name,
                  int.parse(hour),
                  int.parse(min),
                  int.parse(secs),
                  IsBehindOrAfter
                ]); // Add this found time zone to the list
              } else {
                if (myTimeZone[jdex][0] == name) {
                  // Do nothing
                } else {
                  myTimeZone.add([
                    name,
                    int.parse(hour),
                    int.parse(min),
                    int.parse(secs),
                    IsBehindOrAfter
                  ]); // Add this found time zone to the list
                }
              }
            }
          }
        }
      }

      myTimeZone = Set.of(myTimeZone).toList();

      List<List> myTimeZoneWithoutRepeatedItems = [];

      for (int j = 0; j < myTimeZone.length; j++) {
        int indexOfDuplicatedItem = 0;
        String key = "";
        int numberOfDuplicatedItem = 0;

        for (int jdex = 0; jdex < myTimeZone.length; jdex++) {
          if (myTimeZone[j][0] == myTimeZone[jdex][0]) {
            numberOfDuplicatedItem = numberOfDuplicatedItem + 1;
            key = myTimeZone[jdex][0];
            indexOfDuplicatedItem = jdex;
          }
        }

        if (numberOfDuplicatedItem >= 2) {
          for (int a = 0; a < myTimeZone.length; a++) {
            int counterDup =
                0; // number of duplicated items int the myTimeZoneWithoutRepeatedItems list

            // loop through to count the number of key items in the myTimeZoneWithoutRepeatedItems list
            for (int adex = 0;
                adex < myTimeZoneWithoutRepeatedItems.length;
                adex++) {
              if (key == myTimeZoneWithoutRepeatedItems[adex][0]) {
                counterDup = counterDup + 1;
              }
            }

            if (counterDup >= 2) {
              // neglecting to addd the repeated item to the list
            } else if (counterDup == 0) {
              // there is no such key item so consider add one
              myTimeZoneWithoutRepeatedItems.add(
                [
                  myTimeZone[indexOfDuplicatedItem][0],
                  myTimeZone[indexOfDuplicatedItem][1],
                  myTimeZone[indexOfDuplicatedItem][2],
                  myTimeZone[indexOfDuplicatedItem][3],
                  myTimeZone[indexOfDuplicatedItem][4],
                ],
              );
            } else {
              // there is at least one key in the list so ignore adding more
            }
          }
        } else {
          myTimeZoneWithoutRepeatedItems.add(
            [
              myTimeZone[j][0],
              myTimeZone[j][1],
              myTimeZone[j][2],
              myTimeZone[j][3],
              myTimeZone[j][4],
            ],
          );
        }
      }

      emit(
        WorldTimeZoneState(
          numberOfWorldTimeZones: number,
          worldTimeZones: toWritezones,
          worldTimeZonesInList: myTimeZoneWithoutRepeatedItems,
        ),
      );
    }
  }

  // Check the strings created they are **incorrect**
  List gettingSpecifiedZone(int nthZone) {
    String? timeZones = state.worldTimeZones;
    int numberINZones = 0;
    String name = "";
    String hour = "";
    String min = "";
    String sec = "";
    String afterOrBehind = "";

    if (timeZones != null) {
      for (int i = 0; i < timeZones.toString().length; i++) {
        if (timeZones.toString()[i] == "<") {
          numberINZones = numberINZones + 1;
        }

        if (numberINZones == nthZone) {
          int dummyCounter = i;
          int whichpartOfString = 0;

          while (timeZones.toString()[dummyCounter] != ">") {
            // Getting the name
            if ((whichpartOfString == 0) &&
                (timeZones.toString()[dummyCounter] != "|")) {
              name = "$name${() {
                return timeZones.toString()[dummyCounter];
              }()}";
            } else {
              whichpartOfString = 1;
            }

            // Getting the hour
            if ((whichpartOfString == 1) &&
                (timeZones.toString()[dummyCounter] != "|")) {
              hour = "$hour${() {
                return timeZones.toString()[dummyCounter];
              }()}";
            } else {
              whichpartOfString = 2;
            }

            // Getting the min
            if ((whichpartOfString == 2) &&
                (timeZones.toString()[dummyCounter] != "|")) {
              min = "$min${() {
                return timeZones.toString()[dummyCounter];
              }()}";
            } else {
              whichpartOfString = 3;
            }

            // Getting the sec
            if ((whichpartOfString == 3) &&
                (timeZones.toString()[dummyCounter] != "|")) {
              sec = "$sec${() {
                return timeZones.toString()[dummyCounter];
              }()}";
            } else {
              whichpartOfString = 4;
            }

            // Getting the after or behind
            if ((whichpartOfString == 4) &&
                (timeZones.toString()[dummyCounter] != ">")) {
              afterOrBehind = "$afterOrBehind${() {
                return timeZones.toString()[dummyCounter];
              }()}";
            } else {
              break;
            }

            dummyCounter = dummyCounter + 1;
          }
        }
      }
    }

    List data = [name, hour, min, sec, afterOrBehind];

    return data;
  }

  void changeTheNumberOfTimeZones() {
    state.numberOfWorldTimeZones = 5;
  }

  bool isShowtheEarchImage() {
    if (state.numberOfWorldTimeZones != -1) {
      return false;
    } else {
      return true;
    }
  }
}
