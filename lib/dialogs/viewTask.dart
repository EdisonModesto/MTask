import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mtask/dialogs/doneDialog.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class viewTask extends StatefulWidget {
  const viewTask({@required this.title, this.desc, this.date, this.priority, this.taskUid, Key? key}) : super(key: key);
  final title;
  final desc;
  final date;
  final priority;
  final taskUid;

  @override
  State<viewTask> createState() => _viewTaskState();
}

class _viewTaskState extends State<viewTask> {

  int urgentInt = 3, normalInt = 6, farInt = 7;

  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController dateCtrl = TextEditingController();
  String prio = "";

  bool isEditing = false;
  DateTime? dateTime;

  final _formKey = GlobalKey<FormState>();
  var valid = AutovalidateMode.onUserInteraction;

  @override
  void initState() {
    readInterval();
    titleCtrl.text = widget.title;
    descCtrl.text = widget.desc;
    dateCtrl.text = widget.date;
    prio = widget.priority;
    super.initState();
  }

  void readInterval(){
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

  void deleteTask(){
    var collection = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('tasks');
    collection.doc(widget.taskUid) // <-- Doc ID to be deleted.
        .delete();
  }

  void updateTask(){
    var collection = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('tasks');
    collection.doc(widget.taskUid) // <-- Doc ID where data should be updated.
        .update({
      "Title": titleCtrl.text,
      "Description": descCtrl.text,
      "dateTime": dateCtrl.text,
      "parsedDate" : dateTime.toString(),
      "Priority": prio,
      }
    );

    Fluttertoast.showToast(msg: "Task Updated Succesfully!");
    Navigator.pop(context);
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
          height: 450,
          padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                       isEditing? "Edit Task" : "View Task",
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 16
                       ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20, color: Color(0xff923939),),
                          onPressed: (){
                            deleteTask();
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20, color: Color(0xff0890BB),),
                          onPressed: (){
                            setState(() {
                              if(isEditing){
                                isEditing = false;
                                Fluttertoast.showToast(msg: "You're now in VIEW mode.");
                              } else{
                                isEditing = true;
                                Fluttertoast.showToast(msg: "You're now in EDIT mode.");
                              }
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
                TextFormField(
                  enabled: isEditing? true : false,
                    autovalidateMode:  valid,
                    onChanged: (value){
                      setState(() {
                        valid = AutovalidateMode.onUserInteraction;
                      });
                    },
                    validator: (value){
                      if(value!.isEmpty){return 'Empty name.';}
                    },
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 14
                    ),
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
                      label: Text("Title"),
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.blue
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8),),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),

                    )
                ),
                TextFormField(
                    enabled: isEditing? true : false,
                    autovalidateMode:  valid,
                    onChanged: (value){
                      setState(() {
                        valid = AutovalidateMode.onUserInteraction;
                      });
                    },
                    validator: (value){
                      if(value!.isEmpty){return 'Empty description.';}
                    },
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 14
                    ),
                    controller: descCtrl,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
                      label: Text("Description"),
                      labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.blue
                      ),
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
                    Expanded(
                      child: TextFormField(
                          enabled: false,
                          autovalidateMode: AutovalidateMode.always,

                          validator: (value){
                            if(value!.isEmpty){return 'Empty description.';}
                          },
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14
                          ),
                          controller: dateCtrl,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
                            label: Text("Date & Time"),
                            labelStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.blue
                            ),
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
                    IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: isEditing? () async {
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

                        setState(() {
                          if(dateTime!.difference(DateTime.now()).inDays < urgentInt){
                            prio = "Urgent";
                          } else if(dateTime!.difference(DateTime.now()).inDays < normalInt){
                            prio = "Normal";
                          } else{
                            prio = "Far";
                          }
                        });

                        //gets minute
                        var time = dateTime.toString().split(" ");
                        String forMin = time[1].substring(3,5);


                        final DateFormat formatter = DateFormat('yyyy-MMM-dd h:${forMin} a');
                        final String formatted = formatter.format(dateTime!);

                        dateCtrl.text = formatted;
                      } : null,



                    ),
                  ],
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: prio == "Urgent" ? Color(0xff923939) : prio == "Normal" ? Color(0xffC2854B) : Color(0xff259CAC),
                  ),
                  child: Center(
                    child: Text(
                      prio,
                      style: const TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Close"
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if(isEditing){
                            updateTask();
                          }else{

                            var userCol = FirebaseFirestore.instance.collection('Users');
                            userCol
                                .doc(FirebaseAuth.instance.currentUser?.uid) // <-- Doc ID where data should be updated.
                                .update({'totalDone': FieldValue.increment(1)});

                            var taskCol = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('tasks').doc(widget.taskUid);
                               await taskCol.snapshots().forEach((element) {
                                print("DONEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
                                var temp = element.data();
                                print(temp!["Priority"]);

                                if(temp!["Priority"] == "Urgent"){
                                  userCol.doc(FirebaseAuth.instance.currentUser?.uid).update({'urgentDone': FieldValue.increment(1)});
                                } else if(temp!["Priority"] == "Normal"){
                                  userCol.doc(FirebaseAuth.instance.currentUser?.uid).update({'normalDone': FieldValue.increment(1)});
                                } else{
                                  userCol.doc(FirebaseAuth.instance.currentUser?.uid).update({'farDone': FieldValue.increment(1)});
                                }
                                deleteTask();
                                Navigator.pop(context);
                                showDialog(context: context, builder: (context){
                                  return doneDialog();
                                });
                              });
                          }
                        }

                        setState(() {
                          valid = AutovalidateMode.disabled;
                        });
                      },
                      child: Text(
                        isEditing? "Save Changes" : "Mark as done",

                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
