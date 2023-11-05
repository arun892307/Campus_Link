import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StampTile extends StatelessWidget {
  const StampTile({super.key, required this.stamp, required this.sender, required this.readed});
  final DateTime stamp;
  final bool sender;
  final bool readed;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return  Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AutoSizeText(
          "${stamp.hour}:${stamp.minute < 10 ? "0" : ""}${stamp.minute} ${stamp.hour < 12 ? "am" : "pm"}",
          style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.8),
              fontSize: size.width * 0.022,
              fontWeight: FontWeight.w400),
          textAlign: TextAlign.right,
        ),
        const SizedBox(
          width: 8,
        ),
        sender
            ?
        Icon(
          Icons.check,
          color:
          readed
              ?
          Colors.green
              :
          Colors.black.withOpacity(0.8),
          size: size.width * 0.05,
        )
            :
        const SizedBox(),
      ],
    );
  }
}
