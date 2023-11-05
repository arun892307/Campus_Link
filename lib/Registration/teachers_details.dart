import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Login.dart';
class TeacherDetails extends StatefulWidget {
  const TeacherDetails({Key? key}) : super(key: key);

  @override
  State<TeacherDetails> createState() => _TeacherDetailsState();
}

class _TeacherDetailsState extends State<TeacherDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teachers Details",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize:26
          ),),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut().then((value){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignInScreen()));
            });
          },
          child: const Text("LOGOUT",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900
          ),),
        ),
      )
    );
  }
}
