import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:mtask/UI/addScreen.dart';
import 'package:mtask/UI/analytics.dart';
import 'package:mtask/UI/home.dart';
import 'package:mtask/UI/navigator.dart';
import 'package:mtask/UI/pomodoro.dart';
import 'package:mtask/UI/settings.dart';
import 'package:mtask/login/loginScreen.dart';
import 'package:mtask/onboarding/onboarding.dart';
import 'package:mtask/providers/counter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=> counterProvider()),
        ],
      child: const  MyApp()),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'MTask',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'MTask'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{

  PersistentTabController _controller= PersistentTabController(initialIndex: 0);
  late final AnimationController _controllerLottie;
  bool isOnboard = false;

  void getPrefs()async{
    final prefs = await SharedPreferences.getInstance();
    setState((){
      isOnboard = prefs.getBool('isOnboard')!;
    });
  }

  void initFirebase()async{
    getPrefs();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    //check auth state
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>loginScreen()));
      } else {
        print('User is signed in!');
      }
    });

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    print(users);
  }


  @override
  void initState(){
    getPrefs();
    initFirebase();

    _controllerLottie = AnimationController(vsync: this);
    _controllerLottie.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _controllerLottie.reset();
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const navigatorScreen()),);

      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: 300,
            height: 300,
            child: Lottie.asset(
              "assets/lottie/mtask.json",

                repeat: false,
                controller: _controllerLottie,
                onLoaded: (composition){
                  _controllerLottie.duration = composition.duration;
                  _controllerLottie.forward().whenComplete(() => (){

                  });
                }


            ),
          ),
        ),
      ),
    );

    //isOnboard? navigatorScreen() : OnboardScreen();
  }
}
