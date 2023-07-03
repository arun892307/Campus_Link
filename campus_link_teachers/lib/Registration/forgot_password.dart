import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:page_transition/page_transition.dart';
import '../Constraints.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _email=TextEditingController();
  final auth =FirebaseAuth.instance;
  final _textStyle = GoogleFonts.alegreya(fontSize: 28, fontWeight: FontWeight.w900,color: Colors.amber,
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
                    .height * 0.08,
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
                                label: const Text("Enter email"),
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
              ],
                  )
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.02,
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
                      String test=await forgot(_email.text.trim());
                      if(!mounted) return;
                      if(test=="1"){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: const SignInScreen(),
                                type: PageTransitionType.scale,
                                duration: const Duration(milliseconds: 400),
                                alignment: Alignment.bottomCenter),
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
                  child: const Text("Reset Password", style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
                ),
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.03,
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Go to Sign In Page ?", style: TextStyle(
              color: Colors.amberAccent,
            fontWeight: FontWeight.w400)
              ,),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
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
        ),

            ],
          ),
        ),

    ));
  }



  Future<String> forgot(String email) async {
    try {
      await  auth.sendPasswordResetEmail(email: email);
      return "1";
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.toString().split(']')[1].trim();
    }
  }
}
