import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:mtask/dialogs/viewTask.dart';

import '../firebase_options.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  
  
  late var usersQuery = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('tasks').orderBy('Title');

  void initFirebase()async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void updatePrio(docID, taskDateTime) async{

    var prio = "";

    var parsedDateTime = DateTime.parse(taskDateTime);

    if(parsedDateTime!.difference(DateTime.now()).inDays < 3){
      prio = "Urgent";
    } else if(parsedDateTime!.difference(DateTime.now()).inDays < 6){
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

    print("updating priority");
  }

  @override
  void initState() {

    initFirebase();
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
                  children: const [
                    Text(
                      "3 Tasks",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),

                    ),
                    Text(
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
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(75, 75),
                    backgroundColor: const Color(0xff923939)
                  ),
                  child: const Text(
                    "1",
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
                  child: const Text(
                    "1",
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
                  child: const Text(
                    "1",
                    style: TextStyle(
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
                          print(dateString);

                          updatePrio(snapshot.id, user['parsedDate']);
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
                                      color: "${user["Priority"]}" == "Urgent" ? Color(0xff923939) : "${user["Priority"]}" == "Normal" ? Color(0xffC2854B) : Color(0xff259CAC),
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          dateString[2],
                                          style: TextStyle(
                                              fontSize: 16
                                          ),
                                        ),
                                        Text(
                                          dateString[1],
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
                                        children: [
                                          AutoSizeText(
                                            "${user['Title']}",
                                            maxLines: 1,
                                            minFontSize: 1,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18
                                            ),
                                          ),
                                          Text(
                                            "${user['dateTime'].toString().substring(11, 19)}",
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
