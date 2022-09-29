import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:mtask/dialogs/prioDialog.dart';
import 'package:mtask/dialogs/viewTask.dart';
import 'package:mtask/providers/counter.dart';
import 'package:provider/provider.dart';

import '../firebase_options.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  
  
  late var usersQuery = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('tasks').orderBy('parsedDate');
  int totalTasks = 0, urgentTotal = 0, normalTotal = 0, farTotal = 0;
  int urgentInt = 3, normalInt = 6, farInt = 7;

  void initFirebase()async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

 void updateCounters() {

    //loops through every task is collection
   usersQuery.snapshots().forEach((element) {
     setState(() {
       urgentTotal = 0;
       normalTotal = 0;
       farTotal = 0;
       print("COUNTERS RESET");
     });
      print("USER:");
      print(element.docs.length);
      //SETS TOTAL COUNTER TO THE LENGTH
      setState((){
        totalTasks = element.docs.length;
      });

      //LOOPS TRHOUGH EVERY TASK AND CHECK PRIORITY AND ADD THEM TO PRIORITY COUNTER
      element.docs.forEach((element1) {
        var taskData = element1.data();
        print(element1.data()["Priority"]);
        if(taskData["Priority"].toString() == "Urgent"){
          setState(() {
            urgentTotal = urgentTotal + 1;
          });
        } else if(taskData["Priority"].toString() == "Normal"){
          setState(() {
            normalTotal = normalTotal + 1;
          });
        } else{
          setState(() {
            farTotal = farTotal + 1;
          });
        }
      });
    });
    /*
    num = await usersQuery.snapshots().length.whenComplete(() => {
      print("USER:"),
      print(num.toString()),
    });*/




  }

  void updatePrio()  {

    var docID;
    var taskDateTime;

    var snap = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('tasks');
    usersQuery.get().then(
          (res) {
            res.docs.forEach((element) {
              docID = element.id;
              taskDateTime = element["parsedDate"];
              print("TASKDATE TIME");
              print(taskDateTime);

              var prio = "";

              var parsedDateTime = DateTime.parse(taskDateTime);

              if(parsedDateTime!.difference(DateTime.now()).inDays < urgentInt){
                prio = "Urgent";
              } else if(parsedDateTime!.difference(DateTime.now()).inDays < normalInt){
                prio = "Normal";

              } else{
                prio = "Far";
              }

              var collection = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('tasks');
              collection.doc(docID) // <-- Doc ID where data should be updated.
                  .update({

                "Priority": prio,
              }
              );
            });
          },
      onError: (e) => print("Error completing: $e"),
    );


    setState(() {
      urgentTotal = 0;
      normalTotal = 0;
      farTotal = 0;
    });
    updateCounters();

  }

  void readInterval(){
    print("ERROR");


    var collection = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid);
    var get = collection.get().then(
          (DocumentSnapshot doc) {
           final data = doc.data() as Map<String, dynamic>;
            print(data["normalDone"]);
           setState(() {
             urgentInt = data!["urgentInterval"];
             normalInt = data!["normalInterval"];
             farInt = data!["farInterval"];
           });
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  void initState() {

    initFirebase();
    readInterval();
    updatePrio();
    //updateCounters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return SafeArea(
      child: Column(
        children: [
          //total task counter container
          Container(
            width: MediaQuery.of(context).size.width,
            height: 190,
            color: const Color(0xff0890BB),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${totalTasks} Tasks",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),

                    ),
                    const Text(
                      "Recommended by MTask",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.white
                      ),
                    )
                  ],
                ),
            ),
          ),
          //Priority Counter
          Container(
            width: MediaQuery.of(context).size.width,
            height: 110,
            padding: const EdgeInsets.only(left: 25, right: 25),
            color: const Color(0xffE4E4E4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: (){
                    showDialog(context: context, builder: (context){
                      return prioDialog(
                        color: Color(0xff923939),
                        title: "Urgent Priority",
                        subtitle: "All tasks under the urgent priority are close to the deadline! Theses tasks must be finished ASAP!",

                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(75, 75),
                    backgroundColor: const Color(0xff923939)
                  ),
                  child: Text(
                    "${urgentTotal}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    showDialog(context: context, builder: (context){
                      return prioDialog(
                        color: Color(0xffC2854B),
                        title: "Normal Priority",
                        subtitle: "All tasks under the normal priority are considered to be the ideal time to do your tasks! Doing tasks this early will benefit you in the long run!",

                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(75, 75),
                      backgroundColor: const Color(0xffC2854B)
                  ),
                  child:  Text(
                    "${normalTotal}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    showDialog(context: context, builder: (context){
                      return prioDialog(
                        color: Color(0xff259CAC),
                        title: "Far Priority",
                        subtitle: "Tasks under the far priority are tasks that has a far deadline. This indicates that you sill have time to relax.",

                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(75, 75),
                      backgroundColor: const Color(0xff259CAC)
                  ),
                  child: Text(
                    "${farTotal}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                )
              ],
            ),
          ),

          //List Container
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recommended Tasks",
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),

                    Expanded(

                      child: FirestoreListView<Map<String, dynamic>>(
                        query: usersQuery,
                        itemBuilder: (context, snapshot) {
                          Map<String, dynamic> user = snapshot.data();

                          var dateTimeString = user['dateTime'].toString().split(' ');
                          var dateString = dateTimeString[0].split("-");
                       //   print(dateString);
                         // updatePrio(snapshot.id, user['parsedDate']);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              onPressed: (){
                                showDialog(context: context, builder: (context)=>viewTask(title: "${user['Title']}", desc: "${user['Description']}", date: "${user['dateTime']}", priority: "${user["Priority"]}", taskUid: snapshot.id,));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffE4E4E4),
                                  padding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: "${user["Priority"]}" == "Urgent" ? const Color(0xff923939) : "${user["Priority"]}" == "Normal" ? const Color(0xffC2854B) : const Color(0xff259CAC),
                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          dateString[2],
                                          style: const TextStyle(
                                              fontSize: 16
                                          ),
                                        ),
                                        Text(
                                          dateString[1],
                                          style: const TextStyle(
                                              fontSize: 12
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                    child: Container(
                                      height: 75,
                                      padding: const EdgeInsets.only(left: 13),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            "${user['Title']}",
                                            maxLines: 1,
                                            minFontSize: 1,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16
                                            ),
                                          ),
                                          Text(
                                            user['dateTime'].toString().split(" ")[1] + " " + user['dateTime'].toString().split(" ")[2],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      /*
                      ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 10),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffE4E4E4),
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15))
                              )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 75,
                                  height: 75,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff923939),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "08",
                                        style: TextStyle(
                                          fontSize: 16
                                        ),
                                      ),
                                      Text(
                                        "Sept",
                                        style: TextStyle(
                                            fontSize: 12
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Container(
                                    height: 75,
                                    padding: const EdgeInsets.only(left: 13),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Meeting",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18
                                          ),
                                        ),
                                        Text(
                                          "9:00AM",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      ),

            */
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
