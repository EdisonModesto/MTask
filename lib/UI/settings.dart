import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtask/dialogs/editInterval.dart';
import 'package:numberpicker/numberpicker.dart';

import '../dialogs/editSession.dart';

class settingScreen extends StatefulWidget {
  const settingScreen({Key? key}) : super(key: key);

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 45),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Settings",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    Card(
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                        color: Color(0xffE4E4E4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Dark Mode"),
                            Switch(value: false, onChanged: (value){},)
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        padding: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                        color: Color(0xffE4E4E4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Priority Interval"),
                            Text("You can change the day intervals of priority here."),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: (){
                                    showDialog(context: context, builder: (BuildContext context){
                                      return editInterval();
                                    });
                                  },
                                  child: Text(
                                      "Edit Intervals"
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        padding: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                        color: Color(0xffE4E4E4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Pomodoro Interval"),
                            Text("You can change the session intervals of pomodoro here."),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: (){
                                    showDialog(context: context, builder: (BuildContext context){
                                      return editSession();
                                    });
                                  },
                                  child: Text(
                                      "Edit Intervals"
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ]
              )
          )
      );
  }
}
