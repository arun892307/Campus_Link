import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../Constraints.dart';
import '../Screens/Main_page.dart';
import 'forgot_password.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool hide =true;
  final _key = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _textStyle = GoogleFonts.alegreya(fontSize: 28, fontWeight: FontWeight.w900,color: Colors.amber,
    shadows: <Shadow>[
      const Shadow(
        offset: Offset(1, 1),
        color: Colors.black,
      ),
    ],
  );
  String errorString="";

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

                        textStyle: _textStyle
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
                              controller: _email,
                              obscureText: false,
                              enableSuggestions: true,
                              autocorrect: true,
                              cursorColor: Colors.amber,
                              style: TextStyle(color: Colors.white.withOpacity(0.9)),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        _email.clear();
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
                              controller: _password,
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
                                  String test=await signin(_email.text.trim(), _password.text.trim());
                                  if(!mounted) return;
                                  if(test=="1"){
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: const MainPage(),
                                            type: PageTransitionType.rightToLeftJoined,
                                            duration: const Duration(milliseconds: 400),
                                            alignment: Alignment.bottomCenter,
                                          childCurrent: const SignInScreen(),
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
                                        description: test,
                                        leading: const Icon(
                                          Icons.error_outline_outlined,
                                          color: Colors.red,
                                          size: 55,
                                        )
                                    );
                                  }
                                }

                              },



                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.amber,
                                shadowColor: Colors.amberAccent,
                                elevation: 30

                            ),
                              child: const Text("LOG IN", style: TextStyle(
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,PageTransition(child: const ForgotPassword(), type: PageTransitionType.rightToLeft,duration:const Duration(milliseconds: 350)));
                        },
                        child: const Text("Forgot Password ?", style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                    ),

                signUpOption(),

              ],
            ),
          ),
        )
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?", style: TextStyle(fontWeight: FontWeight.w400,
          color: Colors.amberAccent,)
          ,),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Sign Up", style: TextStyle(
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
      await  FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return "1";
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.toString().split(']')[1].trim();
    }
  }
}
