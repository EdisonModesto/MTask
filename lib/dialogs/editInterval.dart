import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';

class editInterval extends StatefulWidget {
  const editInterval({Key? key}) : super(key: key);

  @override
  State<editInterval> createState() => _editIntervalState();
}

class _editIntervalState extends State<editInterval> {

  int urgent = 3, normal = 6, far = 7;

  void saveInterval(){
    var collection = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid);
    collection.update({
      'urgentInterval' : urgent,
      'normalInterval' : normal,
      'farInterval' : normal+1,
    });
  }

  void readInterval(){
    var collection = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid);
    var snapshot = collection.snapshots().forEach((element) {
      var temp = element.data();
      setState(() {
        urgent = temp!["urgentInterval"];
        normal = temp!["normalInterval"];
        far = temp!["farInterval"];
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NumberPicker(
                        value: urgent,
                        minValue: 3,
                        maxValue: 5,
                        itemCount: 3,
                        step: 1,
                        haptics: true,
                        onChanged: (value){
                          setState(() {
                            if(normal < 8){
                              normal += (value-urgent);
                            }
                            urgent = value;
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
                                width: 5, color: Color(0xff923939)
                            ),
                            bottom: BorderSide(
                                width: 5, color: Color(0xff923939)
                            ),

                          )
                        ),
                      ),
                      NumberPicker(
                        minValue: urgent,
                        maxValue: 10,
                        value: normal,
                        itemCount: 3,
                        onChanged: (value){
                          setState(() {
                            normal = value;
                            far = normal+1;
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
                        minValue: normal+1,
                        maxValue: normal+1,
                        value: normal+1,
                        itemCount: 3,
                        onChanged: (value){
                          setState((){
                            far = value;
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
      );
  }
}
