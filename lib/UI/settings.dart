import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtask/dialogs/editInterval.dart';
import 'package:mtask/dialogs/webDialog.dart';
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

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              /*
                              Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                  decoration: const BoxDecoration(
                                    color: Color(0xffE4E4E4),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Dark Mode"),
                                      Switch(value: false, onChanged: (value){},)
                                    ],
                                  ),
                                ),
                              ),

                              */
                              Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                                  height: 145,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffE4E4E4),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Priority Interval",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      const Text("You can change the day intervals of priority here.",  style: TextStyle( fontSize: 12)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: (){
                                              showDialog(context: context, builder: (BuildContext context){
                                                return const editInterval();
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xff0890BB),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                                )
                                            ),
                                            child: const Text(
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
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffE4E4E4),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Pomodoro Interval", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      const Text("You can change the session intervals of pomodoro here.",  style: TextStyle(
                                          fontSize: 12
                                      ),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: (){
                                              showDialog(context: context, builder: (BuildContext context){
                                                return const editSession();
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xff0890BB),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                                )
                                            ),

                                            child: const Text(
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
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                                  height: 175,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffE4E4E4),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Buy us a coffee", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                      const Text("MTask will always be free without the annoying ads. Your support will help us maintain a better user experience for users.",
                                      style: TextStyle(
                                        fontSize: 12
                                      ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: (){
                                              showDialog(context: context, builder: (BuildContext context){
                                                return const webViewDialog(url: "https://ko-fi.com/edisonmodesto");
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xff0890BB),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                                )
                                            ),
                                            child: const Text(
                                                "Buy us a coffee"
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                  decoration: const BoxDecoration(
                                    color: Color(0xffE4E4E4),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Logout of Account"),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await FirebaseAuth.instance.signOut();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff0890BB),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20))
                                            )
                                        ),
                                        child: const Text(
                                            "Logout"
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ]
              )
          )
      );
  }
}
