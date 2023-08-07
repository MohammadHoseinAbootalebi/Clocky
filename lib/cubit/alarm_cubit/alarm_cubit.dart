import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/alarms_model.dart';

part 'alarm_state.dart';

class AlarmCubit extends Cubit<AlarmState> {
  AlarmCubit() : super(AlarmState(alarmData: []));

  Future<void> readingAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Fetch and decode data
    final String alarmString = prefs.getString('Alarms').toString();

    if (alarmString.isEmpty) {
      state.alarmData = [];
    } else {
      print("Reading From Memory method with Bloc : $alarmString");
      state.alarmData = Alarm.decode(alarmString);
    }
  }

  void storingTheIsToggleCubit({bool? isTrunedOn, int? index}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (index != null) {
      state.alarmData[index].isToggle = isTrunedOn as bool;

      // Encode and store data in SharedPreferences
      final String encodedData = Alarm.encode(state.alarmData);

      await prefs.setString('Alarms', encodedData);
    }
  }

  void editingTheAlarm({String? name, String? day, String? time, bool? isToggle, int? index}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (index != null) {
      state.alarmData[index].name = name as String;
      state.alarmData[index].day = day as String;
      state.alarmData[index].time = time as String;
      state.alarmData[index].isToggle = isToggle as bool;

      // Encode and store data in SharedPreferences
      final String encodedData = Alarm.encode(state.alarmData);

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

      state.alarmData = dummyAlarms;

      await prefs.setString('Alarms', encodedData);
    }
  }
}
