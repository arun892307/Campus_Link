import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:campus_link_teachers/Screens/subject_attendace.dart';
import 'package:campus_link_teachers/push_notification/Storage_permission.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

class Download_attendance extends StatefulWidget {
  const Download_attendance({Key? key}) : super(key: key);

  @override
  State<Download_attendance> createState() => _Download_attendanceState();
}

class _Download_attendanceState extends State<Download_attendance> {
  bool isPermission = false;
  var checkALLPermissions = CheckPermission();
  checkPermission() async {
    var permission = await checkALLPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

  var getpathFile = DirectoryPath();
  bool fileExists = false;
  late String filePath;
  String fileName = "";

  var files;

  List<dynamic>curr_filder=[];
  final ScrollController _controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    curr_filder.clear();
    fetch_university();
    //checkPermission();
  }

  Future<void> checkFileExist(String path) async {
    bool fileExistCheck = await Directory(path).exists();
    if(fileExistCheck!=true){
      await Directory(path).create(recursive: true);
    }
    print(".......${path}");
  }
  Color headingcolor = Colors.cyan;
  Color optioncolor = Colors.white;
  PageController Page_controller = PageController();
  List<dynamic>? university_list = [];
  List<dynamic>? clg_list = [];
  List<dynamic>? course_list = [];
  List<dynamic>? branch_list = [];
  List<dynamic>? year_list = [];
  List<dynamic>? section_list = [];
  List<dynamic>? subject_list = [];
  var currentuni = "";
  var currentclg = "";
  var currentcourse = "";
  var currentbranch = "";
  var currentyear = "";
  var currentsection = "";
  var currentsubject = "";
  var current_page = 0;
  int uni_index = -1;
  int clgIndex = -1;
  int courseIndex = -1;
  int branchIndex = -1;
  int yearIndex = -1;
  int sectionIndex = -1;
  int subjectIndex = -1;
  @override
  Widget build(BuildContext context) {
    Color headingcolor=Colors.black;
    Color optioncolor=Colors.black;
    Color dotcolor=Colors.black;
    Size size = MediaQuery.of(context).size;
    return university_list!.isEmpty
        ?

    const Center(child: CircularProgressIndicator())
        :
    Container(
      decoration: BoxDecoration(
        // image: DecorationImage(image: AssetImage("assets/images/bg-image.png"),fit: BoxFit.fill
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
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.black26,
          centerTitle: false,
          title: AutoSizeText(
            "Download Attendance",
            style: GoogleFonts.gfsDidot(fontSize: size.width*0.06, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            height: size.height*0.95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height*0.01,
                ),
                SizedBox(
                  height: size.height * 0.88,
                  width: size.width,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Teachers")
                        .doc(usermodel["Email"])
                        .collection("Teachings")
                        .doc("Teachings")
                        .snapshots(),
                    builder: (context, snapshot) {
                      university_list = snapshot.data?.data()?["University"];

                      if (!snapshot.hasData || university_list!.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: dotcolor,
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: size.height * 0.8,
                          child: SingleChildScrollView(
                            controller: _controller,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                                  child: AutoSizeText(
                                    "University",
                                    style: GoogleFonts.exo(
                                        fontSize: 18,
                                        color: headingcolor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: size.height * 0.08 * university_list!.length,
                                  width: size.width,
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: university_list?.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return ListTile(
                                              splashColor: Colors.transparent,

                                              onTap: () => setState(
                                                    () {
                                                  uni_index=index;
                                                  currentuni = university_list?[index];
                                                  clg_list = snapshot.data?.data()?["College-$uni_index"];
                                                  _controller.animateTo(
                                                    _controller.position.maxScrollExtent,
                                                    duration: const Duration(milliseconds: 100),
                                                    curve: Curves.linear,
                                                  );

                                                  course_list = [];
                                                  branch_list = [];
                                                  year_list = [];
                                                  section_list = [];
                                                  subject_list = [];

                                                  currentclg = "";
                                                  currentcourse = "";
                                                  currentbranch = "";
                                                  currentyear = "";
                                                  currentsection = "";
                                                  currentsubject = "";
                                                },
                                              ),
                                              title: Text(university_list?[index]),
                                              titleTextStyle: GoogleFonts.exo(
                                                  color: optioncolor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500
                                              ),
                                              leading: Radio(
                                                activeColor: dotcolor,
                                                value: university_list?[index],
                                                groupValue: currentuni,
                                                onChanged: (value) {
                                                  setState(
                                                        () {

                                                    },
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ), // University
                                Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.02),
                                  child: AutoSizeText(
                                    "Colleges",
                                    style: GoogleFonts.exo(
                                        fontSize: 18,
                                        color: headingcolor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                AnimatedContainer(
                                  height: size.height * 0.08 * clg_list!.length,
                                  width: size.width,
                                  color: Colors.transparent,
                                  duration: const Duration(milliseconds: 300),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: clg_list?.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return ListTile(
                                              onTap: () => setState(
                                                    () {
                                                  clgIndex=index;
                                                  currentclg = clg_list?[index];
                                                  course_list = snapshot.data?.data()?["Course-$uni_index$clgIndex"];
                                                  _controller.animateTo(
                                                      _controller
                                                          .position.maxScrollExtent,
                                                      duration: const Duration(
                                                          milliseconds: 100),
                                                      curve: Curves.linear);

                                                  branch_list = [];
                                                  year_list = [];
                                                  section_list = [];
                                                  subject_list = [];
                                                  currentcourse = "";
                                                  currentbranch = "";
                                                  currentyear = "";
                                                  currentsection = "";
                                                  currentsubject = "";
                                                },
                                              ),
                                              title: Text(clg_list?[index]),
                                              titleTextStyle: GoogleFonts.exo(
                                                  color: optioncolor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500
                                              ),
                                              leading: Radio(
                                                activeColor: dotcolor,
                                                value: clg_list?[index],
                                                groupValue: currentclg,
                                                onChanged: (value) {
                                                  setState(
                                                        () {
                                                    },
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ), // College
                                Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.02),
                                  child: AutoSizeText(
                                    "Course",
                                    style: GoogleFonts.exo(
                                        fontSize: 18,
                                        color: headingcolor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: size.height * 0.08 * course_list!.length,
                                  width: size.width,
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: course_list?.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return ListTile(
                                              onTap: () {
                                                setState(
                                                      () {
                                                    courseIndex = index;
                                                    branch_list = snapshot.data?.data()?["Branch-$uni_index$clgIndex$courseIndex"];
                                                    currentcourse = course_list![index];
                                                    _controller.animateTo(
                                                      _controller.position.maxScrollExtent,
                                                      duration: const Duration(milliseconds: 100),
                                                      curve: Curves.linear,

                                                    );
                                                    year_list = [];
                                                    section_list = [];
                                                    subject_list = [];
                                                    currentbranch = "";
                                                    currentyear = "";
                                                    currentsection = "";
                                                    currentsubject = "";

                                                  },
                                                );
                                              },
                                              title: Text(course_list?[index]),

                                              titleTextStyle: GoogleFonts.exo(
                                                  color: optioncolor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500
                                              ),
                                              leading: Radio(
                                                activeColor: dotcolor,
                                                value: course_list?[index],
                                                groupValue: currentcourse,
                                                onChanged: (value) {
                                                  setState(
                                                        () {

                                                    },
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.02),
                                  child: AutoSizeText(
                                    "Branch",
                                    style: GoogleFonts.exo(
                                        fontSize: 18,
                                        color: headingcolor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: size.height * 0.08 * branch_list!.length,
                                  width: size.width,
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: branch_list?.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return ListTile(
                                              onTap: () {
                                                setState(() {
                                                  branchIndex = index;
                                                  year_list = snapshot.data!.data()!["Year-$uni_index$clgIndex$courseIndex$branchIndex"];
                                                  currentbranch = branch_list![index];
                                                  _controller.animateTo(
                                                    _controller.position.maxScrollExtent,
                                                    duration: const Duration(milliseconds: 100),
                                                    curve: Curves.linear,
                                                  );
                                                  section_list = [];
                                                  subject_list = [];
                                                  currentyear = "";
                                                  currentsection = "";
                                                  currentsubject = "";
                                                });
                                              },
                                              title: Text(branch_list?[index]),
                                              titleTextStyle: GoogleFonts.exo(
                                                  color: optioncolor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500
                                              ),
                                              leading: Radio(
                                                activeColor: dotcolor,
                                                value: branch_list?[index],
                                                groupValue: currentbranch,
                                                onChanged: (value) {
                                                  setState(
                                                        () {
                                                    },
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.02),
                                  child: AutoSizeText(
                                    "Year",
                                    style: GoogleFonts.exo(
                                        fontSize: 18,
                                        color: headingcolor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: size.height * 0.08 * year_list!.length,
                                  width: size.width,
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: year_list?.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index) {
                                            return ListTile(
                                              onTap: () {
                                                setState(() {
                                                  yearIndex = index;
                                                  section_list = snapshot.data!.data()!["Section-$uni_index$clgIndex$courseIndex$branchIndex$yearIndex"];
                                                  currentyear = year_list![index];
                                                  _controller.animateTo(
                                                    _controller.position.maxScrollExtent,
                                                    duration: const Duration(milliseconds: 100),
                                                    curve: Curves.linear,
                                                  );
                                                  subject_list = [];
                                                  currentsection="";
                                                  currentsubject = "";
                                                });
                                              },
                                              title: Text(year_list?[index]),
                                              titleTextStyle: GoogleFonts.exo(
                                                  color: optioncolor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500
                                              ),
                                              leading: Radio(
                                                activeColor: dotcolor,
                                                value: year_list?[index],
                                                groupValue: currentyear,
                                                onChanged: (value) {
                                                  setState(
                                                        () {
                                                      yearIndex = index;
                                                      section_list = snapshot.data!.data()!["Section-$yearIndex"];
                                                      currentyear = value;
                                                      _controller.animateTo(
                                                        _controller.position.maxScrollExtent,
                                                        duration: const Duration(milliseconds: 100),
                                                        curve: Curves.linear,
                                                      );
                                                      currentsection = "";
                                                      currentsubject = "";
                                                    },
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.02),
                                  child: AutoSizeText(
                                    "Section",
                                    style: GoogleFonts.exo(
                                        fontSize: 18,
                                        color: headingcolor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: size.height * 0.08 * section_list!.length,
                                  width: size.width,
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: section_list?.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index) {
                                            return ListTile(
                                              onTap: () {
                                                setState(() {
                                                  currentsection = section_list![index];
                                                  sectionIndex = index;
                                                  subject_list = snapshot.data!.data()!["Subject-$uni_index$clgIndex$courseIndex$branchIndex$yearIndex$sectionIndex"];

                                                  _controller.animateTo(
                                                    _controller.position.maxScrollExtent,
                                                    duration: const Duration(milliseconds: 100),
                                                    curve: Curves.linear,
                                                  );
                                                  currentsubject = "";
                                                });
                                              },
                                              title: Text(section_list?[index]),
                                              titleTextStyle: GoogleFonts.exo(
                                                  color: optioncolor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500
                                              ),
                                              leading: Radio(
                                                activeColor: dotcolor,
                                                value: section_list![index],
                                                groupValue: currentsection,
                                                onChanged: (value) {
                                                  setState(
                                                        () {},
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.02),
                                  child: AutoSizeText(
                                    "Subject",
                                    style: GoogleFonts.exo(
                                        fontSize: 18,
                                        color: headingcolor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: size.height * 0.08 * subject_list!.length,
                                  width: size.width,
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: subject_list?.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return ListTile(
                                              onTap: () {
                                                setState(() {
                                                  currentsubject = subject_list![index];
                                                  subjectIndex = index;
                                                  _controller.animateTo(
                                                    _controller.position.maxScrollExtent,
                                                    duration: const Duration(milliseconds: 100),
                                                    curve: Curves.linear,
                                                  );
                                                });
                                              },
                                              title: Text(subject_list?[index]),
                                              titleTextStyle: GoogleFonts.exo(
                                                  color: optioncolor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400
                                              ),
                                              leading: Radio(
                                                activeColor: dotcolor,
                                                value: subject_list?[index],
                                                groupValue: currentsubject,
                                                onChanged: (value) {
                                                  setState(
                                                        () {},
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),//Course
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
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
                    backgroundColor: Colors.black12),
                onPressed: () async {

                  if(currentsubject != ""){
                    Directory? path = await getExternalStorageDirectory();
                    print(path?.path);
                    await checkFileExist("${path?.path}/$currentuni/$currentclg/$currentcourse/$currentbranch/$currentyear/$currentsection/$currentsubject/")
                        .whenComplete(() => Navigator.push(
                        context,
                        PageTransition(
                            childCurrent: const Download_attendance(),
                            child: Subject(
                              uni: currentuni,
                              clg: currentclg,
                              course: currentcourse,
                              branch: currentbranch,
                              section: currentsection,
                              subject: currentsubject,
                              year: currentyear,
                            ),
                            type:
                            PageTransitionType.rightToLeftJoined)));
                  }
                  else{

                  }

                },
                child: Text(
                  "Apply",
                  style: GoogleFonts.exo(color: Colors.black),
                ),
              )
            ],
          ),
        ),
            ),
    );
  }

  Future<void> fetch_university() async {
    final ref = await FirebaseFirestore.instance
        .collection("Teachers")
        .doc("arunsaini892307@gmail.com")
        .collection("Teachings")
        .doc("Teachings")
        .get();
    setState(() {
      university_list = ref.data()?["University"];
    });
  }
}

