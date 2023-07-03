import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Registration/Verify Email.dart';
import '../Registration/signUp.dart';
import 'Navigator.dart';




class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    void initState() {
      // TODO: implement initState
      super.initState();
      Timer.periodic(const Duration(milliseconds: 0), (timer) {
        if(mounted){
          setState(() {

          });
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SignUpScreen();
        } else if (snapshot.connectionState == ConnectionState.active && !snapshot.hasData) {
          return const SignUpScreen();
        } else if (snapshot.connectionState == ConnectionState.active && snapshot.hasData)
        {
          if(FirebaseAuth.instance.currentUser!.emailVerified){
            return const Nevi();
          }
          else{
            FirebaseAuth.instance.currentUser!.sendEmailVerification();
            return const Verify();
          }
        }
        else{
          return const SignUpScreen();}
      },

    );
  }
}
