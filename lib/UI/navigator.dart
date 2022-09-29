import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtask/UI/pomodoro.dart';
import 'package:mtask/UI/settings.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'addScreen.dart';
import 'analytics.dart';
import 'home.dart';

class navigatorScreen extends StatefulWidget {
  const navigatorScreen({Key? key}) : super(key: key);

  @override
  State<navigatorScreen> createState() => _navigatorScreenState();
}

class _navigatorScreenState extends State<navigatorScreen> {

  PersistentTabController _controller= PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Color(0xff0890BB)
      ),
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: false, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style16, // Choose the nav bar style with this property.
      ),
    );
  }

  //NAV ITEMS SCREENS
  List<Widget> _buildScreens() {
    return [
      const homeScreen(),
      const pomodoroScreen(),
      addScreen(),
      analyticsScreen(),
      settingScreen(),
    ];
  }


  printCon(){
    print("Pressed");
  }

  //NAV ITEM ITEM LISTS
  List<PersistentBottomNavBarItem> _navBarsItems() {


    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(Icons.timer),
        title: ("Pomodoro"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add),
        title: ("Add"),
        activeColorPrimary: Color(0xff0890BB),
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,

        onPressed: printCon(),
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(Icons.bar_chart),
        title: ("Analytics"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: ("Settings"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

}
