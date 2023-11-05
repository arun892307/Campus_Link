import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../Constraints.dart';
import 'Login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String errorString="";
  bool hide =true;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
        body: Container(

          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color.fromRGBO(86, 149, 178, 1),
                const Color.fromRGBO(68, 174, 218, 1),
                Colors.deepPurple.shade300
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.04, 0,
                MediaQuery.of(context).size.width * 0.04, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.07,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Regcon,
                    border: Border.all(color: Colors.black),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 60,
                          blurStyle: BlurStyle.outer,
                          color: Colors.black54,
                          offset: Offset(1, 1)
                        )
                      ],
                    image: const DecorationImage(
                        image: AssetImage("assets/icon/icon.png")),
                  ),
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * 0.3,
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.06,
                ),
                AnimatedTextKit(
                  animatedTexts: [

                    WavyAnimatedText('Welcome To Campus Link',

                        textStyle: GoogleFonts.libreBaskerville(
                          fontSize: size.width*0.06,
                          fontWeight: FontWeight.w800,
                          color: Colors.white54,
                          shadows: <Shadow>[
                            const Shadow(
                              offset: Offset(1, 1),
                              color: Colors.black,
                            ),
                          ],
                        ),
                    ),

                  ],
                  repeatForever: true,
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.07,
                ),

                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: Colors.black,),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 20,
                              blurStyle: BlurStyle.outer,
                              color: Colors.black54,
                              offset: Offset(1, 1)
                          )
                        ],
                      ),
                      child: TextField(
                          controller: nameController,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    nameController.clear();
                                  });
                                },
                                icon: const Icon(
                                  Icons.clear_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Colors.white,
                              ),
                              label: const Text("Your Name"),
                              labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.black26.withOpacity(0.7),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none)
                              )
                          ),
                          keyboardType: TextInputType.emailAddress),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.03,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: Colors.black,),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 20,
                              blurStyle: BlurStyle.outer,
                              color: Colors.black54,
                              offset: Offset(1, 1)
                          )
                        ],
                      ),
                      child: TextField(
                          controller: employeeIdController,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    employeeIdController.clear();
                                  });
                                },
                                icon: const Icon(
                                  Icons.clear_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Colors.white,
                              ),
                              label: const Text("Your Employee Id"),
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.black26.withOpacity(0.7),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none)
                              )
                          ),
                          keyboardType: TextInputType.emailAddress),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.03,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: Colors.black,),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 20,
                              blurStyle: BlurStyle.outer,
                              color: Colors.black54,
                              offset: Offset(1, 1)
                          )
                        ],
                      ),
                      child: TextField(
                          controller: email,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    email.clear();
                                  });
                                },
                                icon: const Icon(
                                  Icons.clear_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.mail_outline_outlined,
                                color: Colors.white,
                              ),
                              label: const Text("Enter Email"),
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.black26.withOpacity(0.7),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none)
                              )
                          ),
                          keyboardType: TextInputType.emailAddress),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.03,
                    ),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: Colors.black,),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 20,
                              blurStyle: BlurStyle.outer,
                              color: Colors.black54,
                              offset: Offset(1, 1)
                          )
                        ],
                      ),
                      child: TextField(
                          controller: password,
                          obscureText: hide,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                              suffixIcon: hide
                                  ?
                              IconButton(onPressed: (){
                                setState(() {
                                  hide=!hide;
                                });
                              }, icon: const Icon(
                                Icons.visibility_off_outlined,
                                color: Colors.white,
                              ))
                                  :
                              IconButton(onPressed: (){
                                setState(() {
                                  hide=!hide;
                                });
                              }, icon: const Icon(
                                Icons.visibility_outlined,
                                color: Colors.white,
                              )),

                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.white,
                              ),
                              label: const Text("Enter Password"),
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.black26.withOpacity(0.7),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none)
                              )
                          ),
                          keyboardType: TextInputType.visiblePassword),
                    ),
                    SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.03
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.07,
                      decoration: BoxDecoration(
                          gradient:const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue, Colors.purpleAccent],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black54,width: 2)
                      ),
                      child: ElevatedButton(
                        onPressed: () async{
                            if(nameController.text.trim().isNotEmpty){
                              String temp = await signin(email.text.trim(), password.text.trim());
                              if(temp=='1'){
                                InAppNotifications.instance
                                  ..titleFontSize = 14.0
                                  ..descriptionFontSize = 14.0
                                  ..textColor = Colors.black
                                  ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                                  ..shadow = true
                                  ..animationStyle = InAppNotificationsAnimationStyle.scale;
                                InAppNotifications.show(
                                    title: 'Successfull',
                                    duration: const Duration(seconds: 2),
                                    description: 'Your account is created successfuly',
                                    leading: const Icon(
                                      Icons.error_outline_outlined,
                                      color: Colors.red,
                                      size: 55,
                                    )
                                );
                                await FirebaseFirestore.instance.collection("Teachers").doc(email.text.trim()).set({
                                  "Email" : email.text.trim(),
                                  "Name" : nameController.text.trim(),
                                  "Employee Id" : employeeIdController.text.trim(),
                                  "bg" : "bg-1.jpg"
                                });
                                await FirebaseFirestore.instance.collection("Teacher_record").doc("Email").update({
                                  "Email": FieldValue.arrayUnion([usermodel["Email"]])
                                });
                                await FirebaseFirestore.instance.collection("Teachers").doc(email.text.trim()).collection("Teachings").doc("Teachings").set({}).whenComplete(() => Navigator.pop(context));

                              }


                              else{
                                InAppNotifications.instance
                                  ..titleFontSize = 14.0
                                  ..descriptionFontSize = 14.0
                                  ..textColor = Colors.black
                                  ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                                  ..shadow = true
                                  ..animationStyle = InAppNotificationsAnimationStyle.scale;
                                InAppNotifications.show(
                                    title: 'Failed',
                                    duration: const Duration(seconds: 2),
                                    description: temp,
                                    leading: const Icon(
                                      Icons.error_outline_outlined,
                                      color: Colors.red,
                                      size: 55,
                                    )
                                );
                              }
                            }
                            else{
                              InAppNotifications.instance
                                ..titleFontSize = 14.0
                                ..descriptionFontSize = 14.0
                                ..textColor = Colors.black
                                ..backgroundColor =
                                const Color.fromRGBO(150, 150, 150, 1)
                                ..shadow = true
                                ..animationStyle =
                                    InAppNotificationsAnimationStyle.scale;
                              InAppNotifications.show(
                                  title: 'Failed',
                                  duration: const Duration(seconds: 2),
                                  description: "Name can not be empty",
                                  leading: const Icon(
                                    Icons.error_outline_outlined,
                                    color: Colors.red,
                                    size: 55,
                                  ));
                            }

                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.black54,
                          elevation: 30

                        ),
                        child: const Text("Sign Up", style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),),
                      ),
                    ),
                  ],
                ),
                signInOption(),

              ],
            ),
          ),
        )
    );
  }
  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?", style: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black,)
          ,),
        TextButton(

          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageTransition(
                child: const SignInScreen(),
                type: PageTransitionType.leftToRightJoined,
                duration: const Duration(milliseconds: 350),
                childCurrent: const SignUpScreen(),
              ),
            );
          },
          child: const Text("Sign In", style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 30,
                offset: Offset(3, 3),
                color: Colors.black54
              )
            ]
          )

          ),
        )
      ],
    );
  }
  Future<String> signin(String email, String password) async {
    try {
      await  FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return "1";
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.toString().split(']')[1].trim();
    }
  }
}
