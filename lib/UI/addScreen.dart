import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';


class addScreen extends StatefulWidget {
  const addScreen({Key? key}) : super(key: key);

  @override
  State<addScreen> createState() => _addScreenState();
}

class _addScreenState extends State<addScreen> {

  int urgentInt = 3, normalInt = 6, farInt = 7;

  DateTime? dateTime;
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDesc = TextEditingController();
  TextEditingController taskDateTime = TextEditingController();
  TextEditingController taskPriority = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var valid = AutovalidateMode.onUserInteraction;

  @override
  void initState() {
    readInterval();
    super.initState();
  }

  void readInterval()async{
    var collection = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid);
    var snapshot = collection.snapshots().forEach((element) {
      var temp = element.data();
      setState(() {
        urgentInt = temp!["urgentInterval"];
        normalInt = temp!["normalInterval"];
        farInt = temp!["farInterval"];
      });
    });
  }

  void addTask(String tName, tDesc, tDate, tPriority)async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    FirebaseFirestore.instance.collection('Users').doc(uid).collection("tasks").doc().set({
      'Title': tName,
      'Description': tDesc,
      'dateTime' : tDate,
      'parsedDate' : dateTime.toString(),
      'Priority' : tPriority
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        behavior: HitTestBehavior.opaque;
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 45),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    height: 380,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Add Task",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        TextFormField(
                            autovalidateMode:  valid,
                          onChanged: (value){
                              setState(() {
                                valid = AutovalidateMode.onUserInteraction;
                              });
                          },
                          style: const TextStyle(
                            fontSize: 12
                          ),
                          controller: taskName,
                            validator: (value){
                              if(value!.isEmpty){return 'Empty name.';}
                            },
                          decoration: const InputDecoration(

                            label: Text("Name"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),

                          )
                        ),
                        TextFormField(
                            autovalidateMode:  valid,
                          maxLines: 2,
                            validator: (value){
                              if(value!.isEmpty){return 'Empty description.';}
                            },
                            style: const TextStyle(
                                fontSize: 12
                            ),
                            controller: taskDesc,
                            decoration: const InputDecoration(
                              label: Text("Description"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8),),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),

                            )
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: ElevatedButton(

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff0890BB),
                                  fixedSize: const Size(double.infinity, 55),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8),),
                                  )
                                ),
                                onPressed: () async {
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  dateTime = await showOmniDateTimePicker(
                                      context: context,
                                      type: OmniDateTimePickerType.dateAndTime,
                                      primaryColor: Colors.cyan,
                                      backgroundColor: Colors.grey[900],
                                      calendarTextColor: Colors.white,
                                      tabTextColor: Colors.white,
                                      unselectedTabBackgroundColor: Colors.grey[700],
                                      buttonTextColor: Colors.white,
                                      timeSpinnerTextStyle:
                                      const TextStyle(color: Colors.white70, fontSize: 18),
                                      timeSpinnerHighlightedTextStyle:
                                      const TextStyle(color: Colors.white, fontSize: 24),
                                      is24HourMode: false,
                                      isShowSeconds: false,
                                      startInitialDate: DateTime.now(),
                                      startFirstDate:
                                      DateTime(1600).subtract(const Duration(days: 3652)),
                                      startLastDate: DateTime.now().add(
                                      const Duration(days: 3652),
                                      ),
                                    borderRadius: const Radius.circular(16),
                                  );
                                  print(dateTime);

                                  setState(() {
                                    if(dateTime!.difference(DateTime.now()).inDays < urgentInt){
                                      taskPriority.text = "Urgent";
                                    } else if(dateTime!.difference(DateTime.now()).inDays < normalInt){
                                      taskPriority.text = "Normal";
                                    } else{
                                      taskPriority.text = "Far";
                                    }

                                  });

                                  //gets minute
                                  var time = dateTime.toString().split(" ");
                                  String forMin = time[1].substring(3,5);


                                  final DateFormat formatter = DateFormat('yyyy-MMM-dd h:${forMin} a');
                                  final String formatted = formatter.format(dateTime!);
                                  taskDateTime.text = formatted;
                                  print(formatted);
                                },
                                child: const Text(
                                    "Choose Date"
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                  autovalidateMode:  AutovalidateMode.always,
                                enabled: false,
                                  validator: (value){
                                    if(value!.isEmpty){return 'No date specified';}
                                  },
                                  style: const TextStyle(
                                      fontSize: 12
                                  ),
                                  controller: taskDateTime,
                                  decoration: const InputDecoration(
                                    label: Text("Date"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8),),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),

                                  )
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: taskPriority.text == "Urgent" ? Color(0xff923939) : taskPriority.text == "Normal" ? Color(0xffC2854B) : Color(0xff259CAC),
                          ),
                          child: Center(
                            child: Text(
                              "Priority: ${taskPriority.text}",
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addTask(taskName.text, taskDesc.text, taskDateTime.text, taskPriority.text);
                          taskName.text = "";
                          taskDesc.text = "";
                          taskDateTime.text = "";
                          taskPriority.text = "";
                          FocusScope.of(context).requestFocus(new FocusNode());
                        }

                        setState(() {
                          valid = AutovalidateMode.disabled;
                        });


                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(MediaQuery.of(context).size.width, 50),
                          backgroundColor: const Color(0xff0890BB)
                      ),
                      child: const Text(
                          "SAVE"
                      ),
                    )
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
