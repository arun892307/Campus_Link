import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.image, required this.name});
  final String image;
  final String name;
  @override

  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Row(
      children: [

        CircleAvatar(
          radius: size.width * 0.054,
          backgroundImage:
          image != "null" ? NetworkImage(image,scale: 8) : null,
          // backgroundColor: Colors.teal.shade300,
          child: image == "null"
              ? AutoSizeText(
            name.substring(0, 1),
            style: GoogleFonts.exo(
                fontSize: size.height * 0.03,
                fontWeight: FontWeight.w600),
          )
              : null,
        ),
        SizedBox(width: size.width*0.02,),
      ],
    );
  }
}
