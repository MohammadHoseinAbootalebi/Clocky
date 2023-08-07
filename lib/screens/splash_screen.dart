import 'dart:async';

import 'package:clock_app/assets/icons/widgets/clocky_logo_icon.dart';
import 'package:clock_app/screens/alarm_screen.dart';
import 'package:clock_app/widgets/fade_page_route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          FadePageRoute(
            const AlarmScreen(
              currentBottomnavigationBarIndex: BottomNavigaionBarIndex.alarm,
            ),
          ),
        );
      },
    );

    double heightOfWholeScreen = MediaQuery.of(context).size.height;
    double widthOfWholeScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 255),
      body: (MediaQuery.of(context).orientation == Orientation.portrait)
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 122, 255),
                    Color.fromARGB(255, 0, 0, 255),
                    Color.fromARGB(255, 0, 122, 255),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: widthOfWholeScreen / 3,
                    ),
                    Icon(
                      ClockyLogo.clockyLogo,
                      color: Colors.white,
                      size: widthOfWholeScreen / 1.2,
                      shadows: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 255, 255, 255),
                          offset: Offset.zero,
                          blurRadius: 50,
                        ),
                      ],
                    ),
                    FittedBox(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: widthOfWholeScreen / 2,
                          right: widthOfWholeScreen / 2,
                        ),
                        child: Text(
                          "Don't Miss The Time",
                          style: TextStyle(
                            fontSize: widthOfWholeScreen / 5,
                            fontFamily: "Roboto-Regular",
                            color: Colors.white,
                            shadows: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 255, 255, 255),
                                offset: Offset.zero,
                                blurRadius: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: widthOfWholeScreen / 4,
                    ),
                    Lottie.asset(
                      "lib/assets/animation/lottie_animation/Loading Spinner.json",
                      width: widthOfWholeScreen / 2,
                      height: widthOfWholeScreen / 2,
                    ),
                  ],
                ),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 122, 255),
                    Color.fromARGB(255, 0, 0, 255),
                    Color.fromARGB(255, 0, 122, 255),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: heightOfWholeScreen / 10,
                    ),
                    Icon(
                      ClockyLogo.clockyLogo,
                      color: Colors.white,
                      size: heightOfWholeScreen / 2,
                      shadows: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 255, 255, 255),
                          offset: Offset.zero,
                          blurRadius: 50,
                        ),
                      ],
                    ),
                    FittedBox(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: heightOfWholeScreen / 2,
                          right: heightOfWholeScreen / 2,
                        ),
                        child: Text(
                          "Don't Miss The Time",
                          style: TextStyle(
                            fontSize: heightOfWholeScreen / 20,
                            fontFamily: "Roboto-Regular",
                            color: Colors.white,
                            shadows: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 255, 255, 255),
                                offset: Offset.zero,
                                blurRadius: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: heightOfWholeScreen / 30,
                    // ),
                    Lottie.asset(
                      "lib/assets/animation/lottie_animation/Loading Spinner.json",
                      width: heightOfWholeScreen / 3,
                      height: heightOfWholeScreen / 3,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
