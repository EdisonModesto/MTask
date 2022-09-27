import 'dart:async';

import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:mtask/UI/timer.dart';
import 'package:mtask/providers/pomodoroProvider.dart';
import 'package:provider/provider.dart';

class pomodoroScreen extends StatefulWidget {
  const pomodoroScreen({Key? key}) : super(key: key);

  @override
  State<pomodoroScreen> createState() => _pomodoroScreenState();
}

class _pomodoroScreenState extends State<pomodoroScreen> {

  var setMin;
  bool isWork = true;

  Timer? countdownTimer;
  Duration myDuration = Duration(minutes: 5);


  @override
  void initState() {
    setMin = myDuration.inMilliseconds;
    print(setMin);
    super.initState();
  }

  void startTimer() {
    countdownTimer = Timer.periodic(Duration(milliseconds: 100), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer?.cancel());
  }
  // Step 5
  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(days: 5));
  }
  // Step 6
  void setCountDown() {
    final reduceSecondsBy = 100;
    setState(() {
      final seconds = myDuration.inMilliseconds - reduceSecondsBy;
      print(seconds);
      print(setMin);
      print("------------------");
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(milliseconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    String strDigits(int n) => n.toString().padLeft(2, '0');
    final days = strDigits(myDuration.inDays);
    // Step 7
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

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
                          value: myDuration.inMilliseconds/setMin, // Defaults to 0.5.
                          valueColor: const AlwaysStoppedAnimation(Color(0xff0890BB)), // Defaults to the current Theme's accentColor.
                          backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                          borderColor: const Color(0xff0890BB),
                          borderWidth: 5.0,
                          direction: Axis.vertical,
                          center: Text(
                              '$hours:$minutes:$seconds',
                              style: TextStyle(fontSize: 18)
                          ),// The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
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
                              onPressed: (){
                                setState(() {
                                  isWork = true;
                                  myDuration = Duration(minutes: 30);
                                  setMin = myDuration.inMilliseconds;
                                });
                              },
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
                              onPressed: (){
                                setState(() {
                                  isWork = false;
                                  myDuration = Duration(minutes: 1);
                                  setMin = myDuration.inMilliseconds;
                                });
                              },
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
                    onPressed: (){
                      if(countdownTimer == null || !countdownTimer!.isActive){
                        startTimer();
                      }else{
                        stopTimer();
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                      backgroundColor: const Color(0xff0890BB)
                    ),
                    child: Text(
                        countdownTimer == null || !countdownTimer!.isActive ? "START" : "PAUSE"
                    ),
                  )


            ),
          ],
        ),
      ),
    );
  }
}
