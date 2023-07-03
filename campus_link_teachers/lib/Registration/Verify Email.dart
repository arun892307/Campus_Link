import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final textStyle = GoogleFonts.alegreya(fontSize: 17, fontWeight: FontWeight.w900,color: Colors.black);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg-image.png"),
                fit: BoxFit.cover
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              AnimatedTextKit(
                isRepeatingAnimation: true,
                animatedTexts: [
                  WavyAnimatedText('Verification Link is sent to your email. Please verify',
                      textStyle: textStyle,
                      textAlign: TextAlign.center
                  ),

                ],
                repeatForever: true,
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.4,
              ),
              const CircularProgressIndicator(color: Colors.green),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.1,
              ),
              ElevatedButton(
                  onPressed: () async{
                    FirebaseAuth.instance.signOut();
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(100, 100, 100, 1)
                ),
                  child: Text('Verified',style: textStyle,),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.05,
                child: AnimatedTextKit(
                  isRepeatingAnimation: true,
                  animatedTexts: [
                    RotateAnimatedText("Synchronizing with the server. Please wait",
                      textAlign: TextAlign.center,
                      textStyle: textStyle
                    )

                  ],
                  repeatForever: true,
                ),
              ),
            ],
          )
        )
    );
  }

}
