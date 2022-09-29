import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class analyticsScreen extends StatefulWidget {
  const analyticsScreen({Key? key}) : super(key: key);

  @override
  State<analyticsScreen> createState() => _analyticsScreenState();
}

class _analyticsScreenState extends State<analyticsScreen> {

  int total = 0, urgent = 0, normal = 0, far = 0;

  void updateCounters()async{
    var userCol = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid); // <-- Doc ID where data should be updated.
    await userCol.snapshots().forEach((element) {
      var temp = element.data();
      setState(() {
        total = temp!["totalDone"];
        urgent = temp!["urgentDone"];
        normal = temp!["normalDone"];
        far = temp!["farDone"];
      });
    });
  }

  void resetAnalytics()async{
    var userCol = FirebaseFirestore.instance.collection('Users');
    userCol
        .doc(FirebaseAuth.instance.currentUser?.uid) // <-- Doc ID where data should be updated.
        .update({'totalDone': FieldValue.increment(1)});

    var taskCol = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid);
    await taskCol.update(
      {
        "totalDone": 0,
        "urgentDone": 0,
        "normalDone": 0,
        "farDone": 0
      }
    );
  }

  @override
  void initState() {
    updateCounters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 45),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Analytics",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),

            Container(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 135,
                    decoration: const BoxDecoration(
                        color: Color(0xff0890BB),
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "${total}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18
                          ),
                        ),
                        Text(
                          "Completed Tasks",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        )
                      ],
                    ),
                  ),
                  const Text(
                    "Priorities:",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(75, 75),
                            backgroundColor: const Color(0xff923939)
                        ),
                        child: Text(
                          "${urgent}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(75, 75),
                            backgroundColor: const Color(0xffC2854B)
                        ),
                        child:  Text(
                          "${normal}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(75, 75),
                            backgroundColor: const Color(0xff259CAC)
                        ),
                        child: Text(
                          "${far}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              decoration: const BoxDecoration(
                  color: Color(0xffE4E4E4),
                  borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Center(
                child: Text(
                  "Best way to fight procastination is doing tasks\nwhen they are at the orange or blue priority",
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),
              ),
            ),

            ElevatedButton(
              onPressed: (){
                resetAnalytics();
              },
              child: Text(
                "Reset Analytics"
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width, 50),
                backgroundColor: Color(0xff414141),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                )
              ),
            ),
            ElevatedButton(
              onPressed: (){
                Fluttertoast.showToast(msg: "Coming soon.");
              },
              child: Text(
                  "Share Analytics"
              ),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 50),
                  backgroundColor: Color(0xff0890BB),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  )
              ),
            ),
          ]
        )
      )
    );
  }
}
