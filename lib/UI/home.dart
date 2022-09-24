import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
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
                      child: ListView.separated(
                      itemCount: 5,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 10),
                      itemBuilder: (BuildContext context, int index) {
                        return ElevatedButton(
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
                        );
                      }, separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 10,);
                      },
                      ),
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
