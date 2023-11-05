import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Connection.dart';
import 'Database/database.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  static const colors= [
    Colors.black,
    Colors.black45,
    Colors.white38,
    Colors.white
  ];
   final colorizeTextStyle = GoogleFonts.allertaStencil(
     fontSize: 55,
     fontWeight: FontWeight.w700
   );

   double op=1;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => Checkconnection()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg-image.png"),
            fit: BoxFit.fill
          ),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:   Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500 ),
              opacity: op,
              child: SizedBox(
                width: MediaQuery.of(context).size.width*0.5,
                child: const Image(image: AssetImage("assets/icon/icon.png")),
              ),
              onEnd: () => op=1,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.05,
            ),
            SizedBox(

              child: AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Campus Link',
                      textStyle: colorizeTextStyle,
                    colors: colors,
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 500)
                  ),
                ],
                isRepeatingAnimation: true,
                onTap: () {
                  print("Tap Event");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
