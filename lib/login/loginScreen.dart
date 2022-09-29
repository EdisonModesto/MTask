import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:mtask/UI/home.dart';
import 'package:mtask/login/signupScreen.dart';
import 'package:mtask/main.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {

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
                    "Login",
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
                                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                          email: _emailCtrl.text,
                                          password: _passCtrl.text
                                      );
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        Fluttertoast.showToast(msg: "No user found for that email");
                                        print('No user found for that email.');
                                      } else if (e.code == 'wrong-password') {
                                        Fluttertoast.showToast(msg: "Wrong password provided for that user");
                                        print('Wrong password provided for that user.');
                                      }
                                    }
                                    checkAuth();
                                  }

                                },
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(MediaQuery.of(context).size.width, 50),
                                    backgroundColor: const Color(0xff0890BB)
                                ),
                                child: const Text(
                                    "Login"
                                ),
                              )
                          ),
                          TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>signupScreen()));
                            },
                            child: Text(
                              "Don't have an account yet? Sign up."
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
