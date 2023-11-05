import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupDescription extends StatefulWidget {
  const GroupDescription({super.key, required this.channel});
  final String channel;
  @override
  State<GroupDescription> createState() => _GroupDescriptionState();
}

class _GroupDescriptionState extends State<GroupDescription> {
  final TextEditingController textEditingController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(53, 53, 53, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        elevation: 0,
        title: const AutoSizeText("Group description"),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.height*0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: textEditingController,
              cursorColor: Colors.white70,
              decoration: InputDecoration(
                focusColor: Colors.white70,
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70,width: 2),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70,width: 2),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70,width: 2),
                ),
                hintText: "Add group description",
                hintStyle: GoogleFonts.exo(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                )
              ),
              style: GoogleFonts.exo(
                color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(
              height: size.height*0.02,
            ),
            AutoSizeText("The group description is visible to participants of the group.",
            style: GoogleFonts.exo(
              color: Colors.white30,
                fontSize: 12,
                fontWeight: FontWeight.w500
            ),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: size.height * 0.05,
        padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 20,
                  backgroundColor: Colors.black54),
              onPressed: () async {
                await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                  "Description": textEditingController.text.trim(),
                }).whenComplete(() {Navigator.pop(context);});

              },
              child: Text(
                "Apply",
                style: GoogleFonts.exo(color: Colors.white70),
              ),
            )
          ],
        ),
      ),
    );
  }
}
