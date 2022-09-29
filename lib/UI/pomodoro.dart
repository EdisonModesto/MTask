import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:mtask/dialogs/webDialog.dart';
import 'package:mtask/providers/counter.dart';
import 'package:provider/provider.dart';

class pomodoroScreen extends StatefulWidget {
  const pomodoroScreen({Key? key}) : super(key: key);

  @override
  State<pomodoroScreen> createState() => _pomodoroScreenState();
}

class _pomodoroScreenState extends State<pomodoroScreen> with TickerProviderStateMixin{

  bool isPreset = false;
  int workPreset = 0, restPreset = 0;

  int work = 30, rest = 10;
  var setMin;
  bool isWork = true;

  Timer? countdownTimer;
  Duration myDuration = Duration(minutes: 5);


  @override
  void initState() {
    readInterval();
    setMin = work;
    resetTimer();
    print(setMin);
    super.initState();
  }

  void readInterval(){
    print("ERROR");


    var collection = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid);
    var get = collection.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          work = data!["workMin"];
          rest = data!["restMin"];
        });
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(milliseconds: 100), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer?.cancel());
  }
  // Step 5
  void resetTimer() {
    stopTimer();
    setState(() {
      myDuration =
      isWork ? (isPreset ? Duration(minutes: workPreset) : Duration(
          minutes: work)) : (isPreset
          ? Duration(minutes: restPreset)
          : Duration(minutes: rest));
      setMin = myDuration.inMilliseconds;
      }
    );

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
        FlutterRingtonePlayer.play(
          android: AndroidSounds.notification,
          ios: IosSounds.glass,
          looping: true, // Android only - API >= 28
          volume: 1.0, // Android only - API >= 28
          asAlarm: true, // Android only - all APIs
        );
        showDialog(context: context, builder: (context){
          return Center(
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 300,
                decoration: BoxDecoration(
                  color: Color(0xffDADADA),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Session Done!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Container(
                      width: 125,
                      height: 125,
                      child: Lottie.asset(
                        "assets/lottie/done.json"
                      ),
                    ),
                    Text(
                      "Would you like to start the\nnext session?",
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: (){
                            FlutterRingtonePlayer.stop();
                            Navigator.pop(context);
                          },
                          child: Text("No"),
                        ),
                        TextButton(
                          onPressed: (){
                            if(isWork){
                              setState(() {
                                isWork = false;
                              });
                            } else{
                              setState(() {
                                isWork = true;
                              });
                            }
                            resetTimer();
                            startTimer();
                            FlutterRingtonePlayer.stop();
                            Navigator.pop(context);
                          },
                          child: Text("Yes"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
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
                    onPressed: (){
                      showDialog(context: context, builder: (context){
                        return webViewDialog(url: "https://devtastic.tech/blogposts/pomodoro",);
                      });
                    },
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
                    onPressed: (){
                      showDialog(context: context, builder: (context){
                        return Center(
                          child: Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 225,
                              padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Select Preset"
                                  ),
                                  ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        isPreset = false;
                                      });
                                      resetTimer();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                        "Custom"
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(MediaQuery.of(context).size.width, 40),
                                      elevation: 0,
                                      backgroundColor: Color(0xff0890BB)
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        isPreset = true;
                                        workPreset = 45;
                                        restPreset = 15;
                                      });
                                      resetTimer();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "45:15"
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                                        elevation: 0,
                                        backgroundColor: Color(0xff0890BB)
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        workPreset = 35;
                                        restPreset = 10;
                                        isPreset = true;
                                      });
                                      resetTimer();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                        "35:10"
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                                        elevation: 0,
                                        backgroundColor: Color(0xff0890BB)
                                    ),
                                  )

                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    },
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
                              style: const TextStyle(fontSize: 18)
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
                                  myDuration = isPreset? Duration(minutes: workPreset) : Duration(minutes: work);
                                  setMin = myDuration.inMilliseconds;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isWork? const Color(0xff0890BB): Colors.white,
                                side: BorderSide(
                                    color: isWork? const Color(0xff0890BB): const Color(0xff414141),
                                    width: 1),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(18)),
                                ),
                                fixedSize: const Size(100, 30),
                              ),
                              child: Text(
                                "Work",
                                style: TextStyle(
                                    color: isWork? Colors.white : const Color(0xff414141)
                                ),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  isWork = false;
                                  myDuration = isPreset? Duration(minutes: restPreset) : Duration(minutes: rest);
                                  setMin = myDuration.inMilliseconds;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: !isWork? const Color(0xff0890BB): Colors.white,
                                  side: BorderSide(color: !isWork? const Color(0xff0890BB): const Color(0xff414141), width: 1),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(18)),
                                  ),
                                  fixedSize: const Size(100, 30)
                              ),
                              child: Text(
                                "Rest",
                                style: TextStyle(
                                    color: !isWork? Colors.white : const Color(0xff414141)
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
