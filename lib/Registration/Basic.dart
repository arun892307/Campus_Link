import 'package:campus_link_teachers/Constraints.dart';
import 'package:campus_link_teachers/Database/database.dart';
import 'package:campus_link_teachers/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:searchfield/searchfield.dart';

class basicDetails extends StatefulWidget {
  const basicDetails({Key? key}) : super(key: key);

  @override
  State<basicDetails> createState() => _basicDetailsState();
}

class _basicDetailsState extends State<basicDetails> {


  late TextEditingController universityController = TextEditingController();
  List<dynamic> university = [];
  final FocusNode univf = FocusNode();

  late TextEditingController clgController = TextEditingController();
  List<dynamic> clg = [];
  final FocusNode clgf = FocusNode();

  late TextEditingController courseController = TextEditingController();
  List<dynamic> course = [];
  final FocusNode coursef = FocusNode();

  late TextEditingController branchController = TextEditingController();
  List<dynamic> branch = [];
  final FocusNode branchf = FocusNode();

  late TextEditingController yearController = TextEditingController();
  List<dynamic> year = ['1', '2', '3', '4', '5'];
  final FocusNode yearf = FocusNode();

  late TextEditingController secController = TextEditingController();
  List<dynamic> sec = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  final FocusNode secf = FocusNode();

  late TextEditingController subjectController = TextEditingController();
  List<dynamic> subject = [];
  final FocusNode subjectf = FocusNode();

  final FocusNode buttonf = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    fetchUniversity();
    super.initState();
  }

  final textStyle = GoogleFonts.alegreya(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    shadows: <Shadow>[
      const Shadow(
        offset: Offset(1, 1),
        color: Colors.black,
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(86, 149, 178, 1),
            // Color.fromRGBO(86, 149, 178, 1),
            const Color.fromRGBO(68, 174, 218, 1),
            //Color.fromRGBO(118, 78, 232, 1),
            Colors.deepPurple.shade300
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                'Fill Your Basic Details',
                textStyle: GoogleFonts.openSans(
                    color: Colors.white54,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    shadows: <Shadow>[
                      const Shadow(
                        offset: Offset(1, 1),
                        color: Colors.black,
                      ),
                    ]
                ),
              ),
            ],
            repeatForever: true,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: univf,
                  controller: universityController,
                  searchStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  marginColor: Colors.black,
                  suggestionsDecoration: SuggestionDecoration(
                      color: const Color.fromRGBO(40, 130, 146, 1),
                      //shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(0)),
                  searchInputDecoration: InputDecoration(
                    fillColor: Colors.black26.withOpacity(0.7),
                    filled: true,
                      hintText: "University",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusColor: Colors.black,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                  ),
                  onSuggestionTap: (value) {
                    setState(() {
                      fetchCollege(value.searchKey);
                    });
                    FocusScope.of(context).requestFocus(clgf);
                  },
                  enabled: true,
                  hint: "University",
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions:
                  university.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), //University

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: clgf,
                  controller: clgController,
                  searchStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(

                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: const Color.fromRGBO(40, 130, 146, 1),
                      //shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(0)),
                  searchInputDecoration: InputDecoration(
                    fillColor: Colors.black26.withOpacity(0.7),
                    filled: true,
                      hintText: "Colleges",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSuggestionTap: (value) {
                    setState(() {
                      fetchCourse(value.searchKey);
                    });
                    FocusScope.of(context).requestFocus(coursef);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions: clg.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), //College

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: coursef,
                  controller: courseController,
                  searchStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: const Color.fromRGBO(40, 130, 146, 1),
                      //shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(0)),
                  searchInputDecoration: InputDecoration(
                    fillColor: Colors.black26.withOpacity(0.7),
                    filled: true,
                      hintText: "Course",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSuggestionTap: (value) {
                    setState(() {
                      fetchBranch(value.searchKey);
                    });
                    FocusScope.of(context).requestFocus(branchf);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions:
                  course.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), //Course

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: branchf,
                  controller: branchController,
                  searchStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color:Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: const Color.fromRGBO(40, 130, 146, 1),
                      //shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(0)),
                  searchInputDecoration: InputDecoration(
                    fillColor: Colors.black26.withOpacity(0.7),
                      filled: true,
                      hintText: "Branch",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSuggestionTap: (value) {
                    setState(() {
                      fetchSubject(value.searchKey);
                    });
                    FocusScope.of(context).requestFocus(yearf);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions:
                  branch.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), //Branch

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: yearf,
                  controller: yearController,
                  searchStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: const Color.fromRGBO(40, 130, 146, 1),
                      //shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(0)),
                  searchInputDecoration: InputDecoration(
                    fillColor: Colors.black26.withOpacity(0.7),
                    filled: true,
                      hintText: "Year",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSuggestionTap: (value) {
                    setState(() {});
                    FocusScope.of(context).requestFocus(secf);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions: year.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), //Year

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: secf,
                  controller: secController,
                  searchStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(

                      color: const Color.fromRGBO(40, 130, 146, 1),

                      //shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(0)),
                  searchInputDecoration: InputDecoration(
                    fillColor: Colors.black26.withOpacity(0.7),
                    filled: true,
                      hintText: "Section",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSuggestionTap: (value) {
                    setState(() {});
                    FocusScope.of(context).requestFocus(subjectf);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions: sec.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), // section

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: subjectf,
                  controller: subjectController,
                  searchStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: const Color.fromRGBO(40, 130, 146, 1),
                      //shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(0)),
                  searchInputDecoration: InputDecoration(
                    fillColor: Colors.black26.withOpacity(0.7),
                    filled: true,
                      hintText: "Subject",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSuggestionTap: (value) {
                    setState(() {});
                    FocusScope.of(context).requestFocus(buttonf);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions:
                  subject.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), //Subject
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                decoration: BoxDecoration(
                    gradient:(
                    universityController.text.isNotEmpty &&
                        clgController.text.isNotEmpty &&
                        courseController.text.isNotEmpty &&
                        branchController.text.isNotEmpty &&
                        yearController.text.isNotEmpty &&
                        secController.text.isNotEmpty &&
                        subjectController.text.isNotEmpty)
                        ?
                    const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.purpleAccent],
                    )
                :

                 LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey, Colors.grey.shade300,Colors.grey

                  ],
                )
                  ,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black54,width: 2)
                ),
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height*0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      side: const BorderSide(width: 2, color: Colors.black),
                      backgroundColor: Colors.transparent,
                  ),
                  focusNode: buttonf,
                  onPressed: () async {

                    if (universityController.text.isNotEmpty &&
                        clgController.text.isNotEmpty &&
                        courseController.text.isNotEmpty &&
                        branchController.text.isNotEmpty &&
                        yearController.text.isNotEmpty &&
                        secController.text.isNotEmpty &&
                        subjectController.text.isNotEmpty) {
                       try{
                        Navigator.push(context, PageTransition(
                          duration: const Duration(milliseconds: 400),
                          childCurrent: const basicDetails(),
                            child: const loading(text: "Adding subject please wait"),
                            type: PageTransitionType.bottomToTopJoined));
                        Map<String,dynamic> map1 = {
                          "Active": false,
                          "Read_Count": 0,
                          "Last_Active" : DateTime.now(),
                          "Token": FieldValue.arrayUnion([usermodel["Token"]]),
                          "Profile_URL" : usermodel["Profile_URL"],
                          "Name" : usermodel["Name"],
                          "Post" : "Teachers",
                          "Muted" : false,
                          "Type" : "Group"
                        };
                        DateTime stamp=DateTime.now();
                        var data=await FirebaseFirestore.instance.collection("Chat_Channels").doc("Channels").get();
                        data.data()==null
                            ?
                        await FirebaseFirestore.instance.collection("Chat_Channels").doc("Channels").set({
                          "Channels" : FieldValue.arrayUnion([])
                        })
                            :
                            null;

                        await FirebaseFirestore.instance.collection("Chat_Channels").doc("Channels").get().then((value) async {
                          List<dynamic> channel=value.data()!["Channels"];
                          channel.contains(
                              "${universityController.text.trim().split(" ")[0]} "
                              "${clgController.text.trim().split(" ")[0]} "
                              "${courseController.text.trim().split(" ")[0]} "
                              "${branchController.text.trim().split(" ")[0]} "
                              "${yearController.text.trim().split(" ")[0]} "
                              "${secController.text.trim().split(" ")[0]} "
                              "${subjectController.text.trim().split(" ")[0]}"
                          )
                              ?
                          await FirebaseFirestore.instance.collection("Messages").doc(
                              "${universityController.text.trim().split(" ")[0]} "
                                  "${clgController.text.trim().split(" ")[0]} "
                                  "${courseController.text.trim().split(" ")[0]} "
                                  "${branchController.text.trim().split(" ")[0]} "
                                  "${yearController.text.trim().split(" ")[0]} "
                                  "${secController.text.trim().split(" ")[0]} "
                                  "${subjectController.text.trim().split(" ")[0]}"
                          ).update({
                            "Admins" : FieldValue.arrayUnion(["${usermodel["Email"]}"]),
                            "Members" : FieldValue.arrayUnion([
                              usermodel["Email"]
                                  ]),
                            usermodel["Email"].toString().split("@")[0] : map1,
                          })
                              :
                          await FirebaseFirestore.instance.collection("Messages").doc(
                              "${universityController.text.trim().split(" ")[0]} "
                                  "${clgController.text.trim().split(" ")[0]} "
                                  "${courseController.text.trim().split(" ")[0]} "
                                  "${branchController.text.trim().split(" ")[0]} "
                                  "${yearController.text.trim().split(" ")[0]} "
                                  "${secController.text.trim().split(" ")[0]} "
                                  "${subjectController.text.trim().split(" ")[0]}"
                          ).set({
                            "Messages" : [],
                            "Admins" : FieldValue.arrayUnion(["${usermodel["Email"]}"]),
                            "Members" : FieldValue.arrayUnion(["${usermodel["Email"]}",]),
                            usermodel["Email"].toString().split("@")[0] : map1,
                            "image_URL" : "null",
                            "CreatedOn": {"Date" : stamp, "Name": usermodel["Name"]}});
                        });


                        await FirebaseFirestore.instance.collection("Chat_Channels").doc("Channels").update({
                          "Channels": FieldValue.arrayUnion([
                            "${universityController.text.trim().split(" ")[0]} "
                                "${clgController.text.trim().split(" ")[0]} "
                                "${courseController.text.trim().split(" ")[0]} "
                                "${branchController.text.trim().split(" ")[0]} "
                                "${yearController.text.trim().split(" ")[0]} "
                                "${secController.text.trim().split(" ")[0]} "
                                "${subjectController.text.trim().split(" ")[0]}"
                          ])
                        });
                        await FirebaseFirestore.instance.collection("Teachers").doc(usermodel["Email"]).update({
                          "Message_channels" : FieldValue.arrayUnion(["${universityController.text.trim().split(" ")[0]} "
                              "${clgController.text.trim().split(" ")[0]} "
                              "${courseController.text.trim().split(" ")[0]} "
                              "${branchController.text.trim().split(" ")[0]} "
                              "${yearController.text.trim().split(" ")[0]} "
                              "${secController.text.trim().split(" ")[0]} "
                              "${subjectController.text.trim().split(" ")[0]}"
                          ]),
                        });

                        data = await FirebaseFirestore.instance.collection("Teachers Id").doc("${universityController.text.trim().split(" ")[0]} "
                            "${clgController.text.trim().split(" ")[0]} "
                            "${courseController.text.trim().split(" ")[0]} "
                            "${branchController.text.trim().split(" ")[0]} "
                            "${yearController.text.trim().split(" ")[0]} "
                            "${secController.text.trim().split(" ")[0]} "
                            "${subjectController.text.trim().split(" ")[0]}").get();

                        data.data()==null ?
                        await FirebaseFirestore.instance.collection("Teachers Id").doc(
                            "${universityController.text.trim().split(" ")[0]} "
                            "${clgController.text.trim().split(" ")[0]} "
                            "${courseController.text.trim().split(" ")[0]} "
                            "${branchController.text.trim().split(" ")[0]} "
                            "${yearController.text.trim().split(" ")[0]} "
                            "${secController.text.trim().split(" ")[0]} "
                            "${subjectController.text.trim().split(" ")[0]}").set(
                          {
                            "University" : universityController.text.trim().split(" ")[0],
                            "College" : clgController.text.trim().split(" ")[0],
                            "Course" : courseController.text.trim().split(" ")[0],
                            "Branch" : branchController.text.trim().split(" ")[0],
                            "Year" : yearController.text.trim().split(" ")[0],
                            "Section" :  secController.text.trim().split(" ")[0],
                            "Subject" : subjectController.text.trim().split(" ")[0],
                            "Employee Id" : usermodel["Employee Id"],
                            "Email" : usermodel['Email'],
                            "Post" : 'Teachers'
                          }
                        )
                            :
                        await FirebaseFirestore.instance.collection("Teachers Id").doc(
                            "${universityController.text.trim().split(" ")[0]} "
                                "${clgController.text.trim().split(" ")[0]} "
                                "${courseController.text.trim().split(" ")[0]} "
                                "${branchController.text.trim().split(" ")[0]} "
                                "${yearController.text.trim().split(" ")[0]} "
                                "${secController.text.trim().split(" ")[0]} "
                                "${subjectController.text.trim().split(" ")[0]}").update(
                            {
                              "University" : universityController.text.trim().split(" ")[0],
                              "College" : clgController.text.trim().split(" ")[0],
                              "Course" : courseController.text.trim().split(" ")[0],
                              "Branch" : branchController.text.trim().split(" ")[0],
                              "Year" : yearController.text.trim().split(" ")[0],
                              "Section" :  secController.text.trim().split(" ")[0],
                              "Subject" : subjectController.text.trim().split(" ")[0],
                              "Employee Id" : usermodel["Employee Id"],
                              "Email" : usermodel['Email'],
                              "Post" : 'Teachers'
                            }
                        );
                        data=await FirebaseFirestore.instance.collection("University").doc("University").get();

                        data.data()==null
                            ?
                        await FirebaseFirestore.instance.collection("University").doc("University").set(
                            {
                              "University": FieldValue.arrayUnion([universityController.text.trim()])
                            })
                        :
                        await FirebaseFirestore.instance.collection("University").doc("University").update(
                            {
                              "University": FieldValue.arrayUnion([universityController.text.trim()])
                            });
                        
                        data=await FirebaseFirestore.instance.collection("Colleges").doc(universityController.text.trim()).get();

                        data.data()==null
                            ?
                        await FirebaseFirestore.instance.collection("Colleges").doc(universityController.text.trim()).set({
                          "Colleges":[clgController.text.trim()]
                        })
                            :
                        await FirebaseFirestore.instance.collection("Colleges").doc(universityController.text.trim()).update({
                          "Colleges": FieldValue.arrayUnion([clgController.text.trim()])
                        });

                        data=await FirebaseFirestore.instance.collection("Course").doc(clgController.text.trim()).get();
                        data.data()==null
                            ?
                        await FirebaseFirestore.instance.collection("Course").doc(clgController.text.trim()).set({
                          "Course":[courseController.text.trim()]
                        })
                            :
                        await FirebaseFirestore.instance.collection("Course").doc(clgController.text.trim()).update({
                          "Course": FieldValue.arrayUnion([courseController.text.trim()])
                        });

                        data=await FirebaseFirestore.instance.collection("Branch").doc(courseController.text.trim()).get();
                        data.data()==null
                            ?
                        await FirebaseFirestore.instance.collection("Branch").doc(courseController.text.trim()).set({
                          "Branch":[branchController.text.trim()]
                        })
                            :
                        await FirebaseFirestore.instance.collection("Branch").doc(courseController.text.trim()).update({
                          "Branch": FieldValue.arrayUnion([branchController.text.trim()])
                        });

                        data=await FirebaseFirestore.instance.collection("Subject").doc(branchController.text.trim()).get();
                        data.data()==null
                            ?
                        await FirebaseFirestore.instance.collection("Subject").doc(branchController.text.trim()).set({
                          "Subject":[subjectController.text.trim()]
                        })
                            :
                        await FirebaseFirestore.instance.collection("Subject").doc(branchController.text.trim()).update({
                          "Subject": FieldValue.arrayUnion([subjectController.text.trim()])
                        });

                        final ref= FirebaseFirestore
                            .instance
                            .collection("Teachers")
                            .doc(FirebaseAuth.instance.currentUser!.email)
                            .collection("Teachings")
                            .doc("Teachings");
                        await ref
                            .update(
                          {
                            "University": FieldValue.arrayUnion([universityController.text.trim()]),
                          },
                        );

                        data= await ref.get();

                        List<dynamic> university_list= data.data()!["University"];
                        int uni_index =university_list.indexOf(universityController.text.trim());

                        await ref
                            .update(
                          {
                            "College-$uni_index": FieldValue.arrayUnion([clgController.text.trim()]),
                          },
                        );
                        data= await ref.get();
                        List<dynamic> clg_list=data.data()!["College-$uni_index"];
                        int clg_index =clg_list.indexOf(clgController.text.trim());
                        await ref
                            .update(
                          {
                            "Course-$uni_index$clg_index": FieldValue.arrayUnion([courseController.text.trim()]),
                          },
                        );
                        data= await ref.get();
                        List<dynamic> course_list=data.data()!["Course-$uni_index$clg_index"];
                        int course_index =course_list.indexOf(courseController.text.trim());
                        await ref
                            .update(
                          {
                            "Branch-$uni_index$clg_index$course_index": FieldValue.arrayUnion([branchController.text.trim()]),
                          },
                        );
                        data= await ref.get();
                        List<dynamic> branch_list=data.data()!["Branch-$uni_index$clg_index$course_index"];
                        int branch_index =branch_list.indexOf(branchController.text.trim());
                        await ref
                            .update(
                          {
                            "Year-$uni_index$clg_index$course_index$branch_index": FieldValue.arrayUnion([yearController.text.trim()]),
                          },
                        );
                        data= await ref.get();
                        List<dynamic> year_list=data.data()!["Year-$uni_index$clg_index$course_index$branch_index"];
                        int year_index =year_list.indexOf(yearController.text.trim());
                        await ref
                            .update(
                          {
                            "Section-$uni_index$clg_index$course_index$branch_index$year_index": FieldValue.arrayUnion([secController.text.trim()]),
                          },
                        );
                        data= await ref.get();
                        List<dynamic> section_list=data.data()!["Section-$uni_index$clg_index$course_index$branch_index$year_index"];
                        int section_index =section_list.indexOf(secController.text.trim());
                        await ref
                            .update(
                          {
                            "Subject-$uni_index$clg_index$course_index$branch_index$year_index$section_index": FieldValue.arrayUnion([subjectController.text.trim()]),
                          },
                        ).whenComplete((){
                          InAppNotifications.instance
                            ..titleFontSize = 35.0
                            ..descriptionFontSize = 20.0
                            ..textColor = Colors.black
                            ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                            ..shadow = true
                            ..animationStyle = InAppNotificationsAnimationStyle.scale;
                          InAppNotifications.show(
                              title: 'Successful',
                              duration: const Duration(seconds: 2),
                              description: "Subject added",
                              leading: const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 55,
                              ));
                          database().fetchuser().whenComplete((){
                             Navigator.pop(context);
                             Navigator.pop(context);
                          });
                        });
                      }on FirebaseException catch
                       (e) {
                         InAppNotifications.instance
                           ..titleFontSize = 20.0
                           ..descriptionFontSize = 15.0
                           ..textColor = Colors.black
                           ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                           ..shadow = true
                           ..animationStyle = InAppNotificationsAnimationStyle.scale;
                         InAppNotifications.show(
                             title: 'Failed',
                             duration: const Duration(seconds: 2),
                             description: e.toString().split(']')[1].trim(),
                             leading: const Icon(
                               Icons.error_outline_outlined,
                               color: Colors.red,
                               size: 30,
                             ));
                       }
                    }
                    else {
                      InAppNotifications.instance
                        ..titleFontSize = 14.0
                        ..descriptionFontSize = 14.0
                        ..textColor = Colors.black
                        ..backgroundColor =
                        const Color.fromRGBO(150, 150, 150, 1)
                        ..shadow = true
                        ..animationStyle =
                            InAppNotificationsAnimationStyle.scale;
                      InAppNotifications.show(
                          title: 'Failed',
                          duration: const Duration(seconds: 2),
                          description: "Please fill all the details",
                          leading: const Icon(
                            Icons.error_outline_outlined,
                            color: Colors.red,
                            size: 20,
                          ));
                    }
                    // if(_universitycontroller.text.trim().toString().isNotEmpty){
                    //
                    //   List<dynamic> unis=[_universitycontroller.text.trim()];
                    //   await FirebaseFirestore.instance.collection("University").doc("University").update(
                    //       {"University": FieldValue.arrayUnion(unis)
                    //       });
                    //
                    //
                    //   List<dynamic> clgs=["Select Your College", _collegecontroller.text.trim()];
                    //   if(_universitycontroller.text.trim().toString().isNotEmpty){
                    //     await FirebaseFirestore.instance.collection("Colleges").doc(_universitycontroller.text.trim().toString()).set(
                    //         {"Colleges": clgs
                    //         });
                    //
                    //   }
                    //   fetchCollege();
                    //   fetchUniversity();
                    // }
                    // else{
                    //
                    //   if(_collegecontroller.text.trim().toString().isNotEmpty){
                    //     try{
                    //       List<dynamic> clgs=[_collegecontroller.text.trim()];
                    //       await FirebaseFirestore.instance.collection("Colleges").doc(uni).update(
                    //           {"Colleges": FieldValue.arrayUnion(clgs)
                    //           });
                    //     }on FirebaseException catch(e){
                    //       List<dynamic> clgs=["Select Your College",_collegecontroller.text.trim()];
                    //       await FirebaseFirestore.instance.collection("Colleges").doc(uni).set(
                    //           {"Colleges": clgs
                    //           });
                    //     }
                    //   }
                    //   fetchCollege();
                    // }
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700, fontSize:MediaQuery.of(context).size.height*0.026 ,
                        color: Colors.black,
                        ),
                  ),
                ),
              ) // submit button
            ],
          ),
        ),
      ),
    );
  }

  fetchUniversity() async {
    try {
      final feed = await FirebaseFirestore.instance
          .collection('University')
          .doc("University")
          .get();
      setState(() {
        university=feed.data()!["University"];
      });
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  fetchCollege(String univ) async {
    try {
      final feed = await FirebaseFirestore.instance
          .collection('Colleges')
          .doc(univ)
          .get();
      setState(() {
        clg=feed.data()!["Colleges"];
      });
      return true;
    } on FirebaseAuthException catch (e) {
      print("\n\n\n\n $e \n\n\n\n");
    }
  }

  fetchCourse(String clg) async {
    try {
      final feed = await FirebaseFirestore.instance
          .collection('Course')
          .doc(clg)
          .get();

      setState(() {
        course=feed.data()!["Course"];
      });
      return true;
    } on FirebaseAuthException catch (e) {
      print("\n\n\n\n $e \n\n\n\n");
    }
  }

  fetchBranch(String course) async {
    try {
      final feed = await FirebaseFirestore.instance
          .collection('Branch')
          .doc(course)
          .get();

      setState(() {
        branch=feed.data()!["Branch"];
      });

      return true;
    } on FirebaseAuthException catch (e) {
      print("\n\n\n\n $e \n\n\n\n");
    }
  }

  fetchSubject(String Branch) async {
    try {
      final feed = await FirebaseFirestore.instance
          .collection('Subject')
          .doc(Branch)
          .get();

      setState(() {
        subject=feed.data()!["Subject"];
      });

      return true;
    } on FirebaseAuthException catch (e) {
      print("\n\n\n\n $e \n\n\n\n");
    }
  }


}