import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class pomodoroScreen extends StatefulWidget {
  const pomodoroScreen({Key? key}) : super(key: key);

  @override
  State<pomodoroScreen> createState() => _pomodoroScreenState();
}

class _pomodoroScreenState extends State<pomodoroScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //TITLE
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.info, color: Colors.black38),
                  ),
                  const Text(
                    "Pomodoro Timer",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.settings, color: Colors.black38,),
                  )
                ],
              ),
            ),

            Container(
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    child: LiquidCircularProgressIndicator(
                      value: 0.9, // Defaults to 0.5.
                      valueColor: const AlwaysStoppedAnimation(Color(0xff0890BB)), // Defaults to the current Theme's accentColor.
                      backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                      borderColor: const Color(0xff0890BB),
                      borderWidth: 5.0,
                      direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                      center: const Text("30:00"),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * .6,
                    height: 80,
                    margin: const EdgeInsets.only(top: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                            "Current Session: "
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OutlinedButton(
                              onPressed: (){},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xff414141), width: 1),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(18)),
                                ),
                                fixedSize: const Size(100, 30),
                              ),
                              child: const Text(
                                "Work",
                                style: TextStyle(
                                    color: Color(0xff414141)
                                ),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: (){},
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xff414141), width: 1),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(18)),
                                  ),
                                  fixedSize: const Size(100, 30)
                              ),
                              child: const Text(
                                "Rest",
                                style: TextStyle(
                                    color: Color(0xff414141)
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),



            Container(
              height: 55,
              child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                      backgroundColor: const Color(0xff0890BB)
                    ),
                    child: const Text(
                      "START"
                    ),
                  )


            ),
          ],
        ),
      ),
    );
  }
}
