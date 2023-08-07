import 'package:clock_app/assets/icons/widgets/cancel_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InTimeOfAlarmRinging extends StatefulWidget {
  const InTimeOfAlarmRinging({super.key});

  @override
  State<InTimeOfAlarmRinging> createState() => _InTimeOfAlarmRingingState();
}

class _InTimeOfAlarmRingingState extends State<InTimeOfAlarmRinging> {
  @override
  Widget build(BuildContext context) {
    double widthOfWholeScreen = MediaQuery.of(context).size.width;
    double heightOfWholeScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.amber,
      body: SizedBox(
        width: widthOfWholeScreen,
        height: heightOfWholeScreen,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'lib/assets/pngs/Vertical.png',
                fit: BoxFit.fitHeight,
                height: heightOfWholeScreen,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 8
                          : heightOfWholeScreen / 8,
                    ),
                    Text(
                      "09:15",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "FredokaOne-Regular",
                        fontSize: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 4
                            : heightOfWholeScreen / 4,
                      ),
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    Text(
                      "Every Saturday",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto-Light",
                        fontSize: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 20
                            : heightOfWholeScreen / 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    Text(
                      "Webinar",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto-Regular",
                        fontSize: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 15
                            : heightOfWholeScreen / 15,
                      ),
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 1.5
                          : heightOfWholeScreen / 1.5,
                    ),
                    Container(
                      padding: const EdgeInsets.all(
                        20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen
                              : heightOfWholeScreen,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(20, 0, 0, 0),
                            offset: Offset.zero,
                            blurRadius: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 20
                                : heightOfWholeScreen / 20,
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.all(
                              (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 20
                                  : heightOfWholeScreen / 20,
                            ),
                          ),
                          iconColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 0, 82, 255),
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen
                                    : heightOfWholeScreen,
                              ),
                            ),
                          ),
                        ),
                        child: Icon(
                          Cancel.cancel,
                          size: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 15
                              : heightOfWholeScreen / 15,
                          color: const Color.fromARGB(255, 0, 82, 255),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 8
                          : heightOfWholeScreen / 8,
                    ),
                    TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          const BorderSide(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        overlayColor: MaterialStateProperty.all(
                          const Color.fromARGB(53, 255, 255, 255),
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.only(
                            top: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 20
                                : heightOfWholeScreen / 20,
                            bottom: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 20
                                : heightOfWholeScreen / 20,
                            left: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 5
                                : heightOfWholeScreen / 5,
                            right: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 5
                                : heightOfWholeScreen / 5,
                          ),
                        ),
                        iconColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 0, 82, 255),
                        ),
                        foregroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen
                                  : heightOfWholeScreen,
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        "Snooze",
                        style: TextStyle(
                          fontSize: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 24
                              : heightOfWholeScreen / 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
