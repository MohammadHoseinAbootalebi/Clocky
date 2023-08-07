import 'package:clock_app/cubit/alarm_cubit/alarm_cubit.dart';
import 'package:clock_app/cubit/timer_cubit/is_started_timer_cubit.dart';
import 'package:clock_app/cubit/worldTimeZone/world_time_zone_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clock_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AlarmCubit(),
        ),
        BlocProvider(
          create: (context) => WorldTimeZoneCubit(),
        ),
        BlocProvider(
          create: (context) => IsStartedTimerCubit(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Clock App',
        home: SplashScreen(),
      ),
    );
  }
}
