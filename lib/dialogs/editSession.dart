import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';

class editSession extends StatefulWidget {
  const editSession({Key? key}) : super(key: key);

  @override
  State<editSession> createState() => _editSessionState();
}

class _editSessionState extends State<editSession> {

  int work = 30, rest = 10;


  void saveInterval(){
    var collection = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid);
    collection.update({
      'workMin' : work,
      'restMin' : rest,
    });
  }

  void readInterval(){
    var collection = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid);
    var snapshot = collection.snapshots().forEach((element) {
      var temp = element.data();
      setState(() {
        work = temp!["workMin"];
        rest = temp!["restMin"];
      });
    });
  }

  @override
  void initState() {
    readInterval();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 300,
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Edit Interval",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NumberPicker(
                        minValue: 1,
                        maxValue: 60,
                        value: work,
                        itemCount: 3,
                        onChanged: (value){
                          setState(() {
                            work = value;
                          });
                        },
                        itemWidth: 50,
                        selectedTextStyle: const TextStyle(
                          color: Colors.blue,
                        ),
                        decoration: const BoxDecoration(
                          //  borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border(
                              top: BorderSide(
                                  width: 5, color: Color(0xffC2854B)
                              ),
                              bottom: BorderSide(
                                  width: 5, color: Color(0xffC2854B)
                              ),

                            )
                        ),
                      ),
                      NumberPicker(
                        minValue: 1,
                        maxValue: 60,
                        value: rest,
                        itemCount: 3,
                        onChanged: (value){
                          setState(() {
                            rest = value;
                          });
                        },
                        itemWidth: 50,
                        selectedTextStyle: const TextStyle(
                          color: Colors.blue,
                        ),
                        decoration: const BoxDecoration(
                          //  borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border(
                              top: BorderSide(
                                  width: 5, color: Color(0xff259CAC)
                              ),
                              bottom: BorderSide(
                                  width: 5, color: Color(0xff259CAC)
                              ),

                            )
                        ),
                      ),
                    ],
                  ),
                  Text(
                      "Swipe to edit values"
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: (){
                          saveInterval();
                          Fluttertoast.showToast(msg: "Intervals Saved");
                          Navigator.pop(context);
                        },
                        child: Text("Save"),
                      )
                    ],
                  )
                ],
              ),
            )
        )
    );;
  }
}
