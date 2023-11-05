import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ReplyTile extends StatelessWidget {
  const ReplyTile({super.key, required this.scrollController, required this.replyIndex, required this.scrollindex, required this.replyToName, required this.ReplyToText, required this.sender});
  final ItemScrollController scrollController;
  final int replyIndex;
  final int scrollindex;
  final String replyToName;
  final String ReplyToText;
  final bool sender;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        print("..........${replyIndex}");
        scrollController.scrollTo(index: scrollindex, duration: const Duration(seconds: 1));
      },
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(size.height * 0.01),
            margin: EdgeInsets.fromLTRB(size.width*0.02,0,size.width*0.02,size.width*0.02),
            decoration: BoxDecoration(
                gradient: sender ?
                const LinearGradient(colors: [
                  Color.fromRGBO(85, 184, 205, 1),
                  Color.fromRGBO(199, 84, 205, 1),

                ])
                    :
                const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromRGBO(0, 0, 130, 1),
                    Color.fromRGBO(28, 180, 224, 1)
                  ],
                ),
                borderRadius: const BorderRadius.all(Radius.circular(14)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  "Replied To: $replyToName",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: size.width*0.03,
                      color: sender ? Colors.black : Colors.white.withOpacity(0.8)),
                  maxLines: 1,
                ),
                AutoSizeText(
                  ReplyToText.toString().substring(
                      0,
                      ReplyToText.length < 120
                          ? ReplyToText.length
                          : 120),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: size.width*0.035,
                      color: sender ? Colors.black : Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
