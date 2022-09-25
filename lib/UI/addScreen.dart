import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';


class addScreen extends StatefulWidget {
  const addScreen({Key? key}) : super(key: key);

  @override
  State<addScreen> createState() => _addScreenState();
}

class _addScreenState extends State<addScreen> {

  DateTime? dateTime;

  @override
  void initState() {
    print("Loaded");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 45),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                child: Container(
                  height: 420,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Add Task",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      TextFormField(
                        style: const TextStyle(
                          fontSize: 14
                        ),
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
                        maxLines: 3,
                          style: const TextStyle(
                              fontSize: 14
                          ),
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
                                fixedSize: const Size(double.infinity, 60),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8),),
                                )
                              ),
                              onPressed: () async {
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
                              },
                              child: const Text(
                                  "Choose Date"
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              enabled: true,
                                style: const TextStyle(
                                    fontSize: 14
                                ),
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
                        height: 60,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Color(0xffC2854B),
                        ),
                        child: Center(
                          child: const Text(
                            "Priority: Normal",
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
                    onPressed: (){},
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
    );
  }
}
