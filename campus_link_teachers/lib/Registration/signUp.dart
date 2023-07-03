import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../Constraints.dart';
import 'Basic.dart';
import 'Login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String errorString="";
  bool hide =true;
  final _key = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final textStyle = GoogleFonts.alegreya(fontSize: 28, fontWeight: FontWeight.w900,color: Colors.amber,
      shadows: <Shadow>[
        const Shadow(
          offset: Offset(1, 1),
          color: Colors.black,
        ),
      ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(

          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg-image.png"),
                fit: BoxFit.cover
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.04,
                0,
                MediaQuery.of(context).size.width * 0.04,
                0),
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
                      border: Border.all(color: Colors.amber),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 60,
                            blurStyle: BlurStyle.outer,
                            color: Colors.amberAccent,
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

                        textStyle: textStyle
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

                Form(
                    key: _key,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                            border: Border.all(color: Colors.amber,),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 20,
                                  blurStyle: BlurStyle.outer,
                                  color: Colors.amberAccent,
                                  offset: Offset(1, 1)
                              )
                            ],
                          ),
                          child: TextFormField(
                              validator: (value) {
                                if (value!.contains('@')) {
                                  return null;
                                } else {
                                  return 'Please enter a valid email address';
                                }
                              },
                              controller: email,
                              obscureText: false,
                              enableSuggestions: true,
                              autocorrect: true,
                              cursorColor: Colors.amber,
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
                                      color: Colors.amber,
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                    color: Colors.amber,
                                  ),
                                  label: const Text("Enter Email"),
                                  labelStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.9)),
                                  filled: true,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  fillColor: Colors.black26.withOpacity(0.9),
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
                            border: Border.all(color: Colors.amber,),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 20,
                                  blurStyle: BlurStyle.outer,
                                  color: Colors.amberAccent,
                                  offset: Offset(1, 1)
                              )
                            ],
                          ),
                          child: TextFormField(
                              validator: (value) {
                                if (value.toString().length <6) {
                                  return ('Minimum Password length is six');
                                } else {
                                  return null;
                                }
                              },
                              controller: password,
                              obscureText: hide,
                              enableSuggestions: false,
                              autocorrect: false,
                              cursorColor: Colors.amber,
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
                                    color: Colors.amber,
                                  ))
                                      :
                                  IconButton(onPressed: (){
                                    setState(() {
                                      hide=!hide;
                                    });
                                  }, icon: const Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.amber,
                                  )),

                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.amber,
                                  ),
                                  label: const Text("Enter Password"),
                                  labelStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.9)),
                                  filled: true,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  fillColor: Colors.black26.withOpacity(0.9),
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
                          height: MediaQuery.of(context).size.height*0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),),
                          child: ElevatedButton(
                            onPressed: () async{
                              if (_key.currentState!.validate())
                              {
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
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: const basicDetails(),
                                      type: PageTransitionType.rightToLeftJoined,
                                      duration: const Duration(milliseconds: 350),
                                      childCurrent: const SignUpScreen(),
                                    ),
                                  );

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


                            }},
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.amber,
                              shadowColor: Colors.amberAccent,
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
                    )
                ),
                SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.03
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
          color: Colors.amberAccent,)
          ,),
        TextButton(

          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: const SignInScreen(),
                    type: PageTransitionType.rightToLeftJoined,
                    duration: const Duration(milliseconds: 350),
                  childCurrent: const SignUpScreen(),
                ),
            );
          },
          child: const Text("Sign In", style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 30,
                offset: Offset(3, 3),
                color: Colors.amberAccent
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
