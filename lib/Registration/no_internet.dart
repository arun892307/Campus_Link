import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class No_internet extends StatefulWidget {
  const No_internet({Key? key}) : super(key: key);

  @override
  State<No_internet> createState() => _No_internetState();
}

class _No_internetState extends State<No_internet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
            height: MediaQuery.of(context).size.height*0.55,
            width: MediaQuery.of(context).size.width*0.8,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                  image: DecorationImage(
                      image: AssetImage("assets/icon/11645-no-internet-animation.gif"),
                      fit: BoxFit.fill
                  )
              )
            ),
            Text("Please check your Internet",style: GoogleFonts.exo(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.w800
            ),)
          ],
        ),
      ),
    );
  }
}
