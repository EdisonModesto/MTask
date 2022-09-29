import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:mtask/UI/navigator.dart';
import 'package:mtask/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'baseScreen.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {

  PageController _pageController = PageController();
  double currPage = 0;

  //body of screens
  _buildBody(){
    return SafeArea(
      child: Column(
        children: [
          Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page){
                  setState((){
                    currPage = page.toDouble();
                  });
                },
                children: [
                  baseScreen(titleStr: "Welcome to MTask", descStr: "The app that helps you keep track of the tasks that matters the most! Let me show you around!", isNext: true,lottie: "assets/lottie/mtask.json",),
                  baseScreen(titleStr: "What are Priorities?", descStr: "Priorities helps you to group your tasks depending on their priority. A priority will change depending on the date of the task.", isNext: false,lottie: "assets/lottie/prio.json"),
                  baseScreen(titleStr: "Pomodoro Timer", descStr: "With Mtask's Pomodoro timer, it can help you be more productive and get you into the 'flow' much faster.", isNext: false, lottie: "assets/lottie/timer.json",),
                  baseScreen(titleStr: "You're all set!", descStr: "That's all for now, it's time for you to explore MTask! Make sure to share your experience with others!", isNext: false,lottie: "assets/lottie/done.json",),
                ],
              )

          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            alignment: Alignment.topCenter,
            color: Color(0xffdadada),
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xff0890BB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))
                        ),
                        fixedSize: Size(150, 50)
                    ),
                    onPressed: () async {
                      currPage == 3 ? //checks if the current page is the last
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> navigatorScreen())) :  //if yes, push/navigate to login screen
                      _pageController.animateToPage(currPage.toInt() + 1, duration: Duration(milliseconds: 500), curve: Curves.easeIn); //if no, animates the pageview to the next page of the onboarding screen
                      if(currPage == 3){
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isOnboard', true);
                        print("SAVED");
                      }


                    },

                    child: Text(
                        currPage == 3 ? "Done" : "Next",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 30),
                    child: DotsIndicator(
                      mainAxisAlignment: MainAxisAlignment.start,
                      dotsCount: 4,
                      position: currPage,
                      decorator: DotsDecorator(
                        size: const Size.square(15.0),
                        activeSize: const Size(30.0, 15.0),
                        activeColor: Color(0xff0890BB),
                        color: Color.fromRGBO(8, 144, 187, 0.3),
                        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      ),
                    ),
                  ),
                ]
            ),
          )
        ],
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: _buildBody(),
    );
  }
}