import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class loading extends StatelessWidget {
  const loading({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: Colors.black38,
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitSpinningLines(color: Colors.white,size: size.width*0.3,itemCount: 6),
            SizedBox(
              height: size.height*0.04,
            ),
            Container(
              width: size.width*0.98,
              padding: EdgeInsets.all(size.width*0.03),
              decoration:
              BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                     Colors.black.withOpacity(0.8),
                     Colors.black.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AutoSizeText(text,style: GoogleFonts.gfsDidot(
                color: Colors.white,
                fontSize: size.width*0.045
              ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            SpinKitThreeBounce(color: Colors.white,size: size.width*0.03,)
          ],
        ),
      ),
    );
  }
}
