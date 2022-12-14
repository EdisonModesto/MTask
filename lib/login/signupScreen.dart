import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';

class signupScreen extends StatefulWidget {
  const signupScreen({Key? key}) : super(key: key);

  @override
  State<signupScreen> createState() => _signupScreenState();
}

class _signupScreenState extends State<signupScreen> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _passCtrl = TextEditingController();


  checkAuth(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> MyApp()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Lottie.asset(
                      "assets/lottie/loginLogo.json",
                      height: 135,
                      repeat: false
                    ),
                  ),
                  Text(
                    "Sign Up",
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email should not be empty';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                  fontSize: 14
                              ),
                              controller: _emailCtrl,
                              decoration: const InputDecoration(
                                label: Text("Email"),
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
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password should not be empty';
                                }
                                return null;
                              },
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: const TextStyle(
                                  fontSize: 14
                              ),
                              controller: _passCtrl,
                              decoration: const InputDecoration(
                                label: Text("Password"),
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
                          Container(
                              height: 55,
                              child: ElevatedButton(
                                onPressed: ()async{
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                        email: _emailCtrl.text,
                                        password: _passCtrl.text,
                                      );
                                      final FirebaseAuth auth = FirebaseAuth.instance;
                                      final User? user = auth.currentUser;
                                      final uid = user?.uid;
                                      final users = FirebaseFirestore.instance.collection('Users').doc(uid.toString());
                                      final json = {
                                        'email' : _emailCtrl.text,
                                        'joinedDate' : DateTime.now().toString(),
                                        'totalDone' : 0,
                                        'urgentDone' : 0,
                                        'normalDone' : 0,
                                        'farDone' : 0,
                                        'workMin' : 30,
                                        'restMin' : 10,
                                        'urgentInterval' : 3,
                                        'normalInterval' : 6,
                                        'farInterval' : 7,
                                        'mode' : 0
                                      };
                                      await users.set(json);

                                      FirebaseFirestore.instance.collection('Users').doc(uid).collection("tasks").doc("").set({
                                        'userId':'task1'
                                      });



                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'weak-password') {
                                        print('The password provided is too weak.');
                                        Fluttertoast.showToast(msg: "The password provided is too weak");
                                      } else if (e.code == 'email-already-in-use') {
                                        print('The account already exists for that email.');
                                        Fluttertoast.showToast(msg: "The account already exists for that email.");
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                    checkAuth();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(MediaQuery.of(context).size.width, 50),
                                    backgroundColor: const Color(0xff0890BB)
                                ),
                                child: const Text(
                                    "Sign Up"
                                ),
                              )
                          ),
                          TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text(
                                "Have an account? Login."
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
