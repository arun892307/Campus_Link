import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextTile extends StatelessWidget {
  const TextTile({super.key, required this.text, required this.sender});
  final String text;
  final bool sender;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.fromLTRB(size.width*0.025,size.height*0.0,size.width*0.025,size.height*0.01,),
      child: SelectableText(
        text,
        style: GoogleFonts.poppins(
            color: sender ? Colors.white:Colors.black.withOpacity(0.75),
            fontSize:  size.width * 0.035,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
