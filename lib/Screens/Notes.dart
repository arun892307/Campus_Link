

import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:campus_link_teachers/Screens/quiz.dart';
import 'package:campus_link_teachers/Screens/quizquestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../Constraints.dart';
import '../push_notification/Storage_permission.dart';
import 'Chat_tiles/PdfViewer.dart';
import 'QuizScore.dart';
import 'Quiz_response.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  var checkALLPermissions = CheckPermission();
  bool permissionGranted=false;
  bool docExists=false;
  Directory? directory;
  bool fileAlreadyExists=false;
  late int totalStudents;

  int ind=0;
  bool a=true;

  final dio=Dio();
   double percent=0.0;
   String filePath="";

   List<bool>isExpanded=[];
   List<bool>isDownloaded=[];
   List<bool>isDownloading=[];

   DateTime currDate=DateTime.now();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    countStudents();
    checkExists();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    BorderRadiusGeometry radiusGeomentry=BorderRadius.circular(size.width*0.09);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: subject_filter!=""
        ?
      docExists
      ?
      SizedBox(
        height:size.height*0.8,
        width:size.width*0.98,
        child: StreamBuilder
          (
          stream: FirebaseFirestore.instance.collection("Notes").doc("${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
          {


            return  snapshot.hasData
                ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: ListView.builder(
                  itemCount: snapshot.data["Total_Notes"],
                  itemBuilder: (context, index) {
                    Timestamp deadline=snapshot.data["Notes-${index+1}"]["Deadline"];
                    //print("....................${snapshot.data["Notes-${index+1}"]["Deadline"]}");
                    bool quizCreated = snapshot.data["Notes-${index+1}"]["Quiz_Created"];
                    String? dir = directory?.path.toString().substring(0, 19);
                    String path = "$dir/Campus Link/$university_filter $college_filter $course_filter $branch_filter $year_filter $section_filter $subject_filter/Notes/";

                    File newPath = File("$path${snapshot.data["Notes-${index +
                        1}"]["File_Name"]}");
                    newPath.exists().then((value) async {
                      if (!value) {
                        setState(() {
                          isDownloaded[index] = false;
                        });
                      }
                      else {
                        setState(() {
                          isDownloaded[index] = true;
                        });
                      }
                    },);
                      return Padding(
                        padding: EdgeInsets.all(size.width * 0.032),
                        child: Container(
                          width: size.width * 0.85,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(56, 33, 101,1),
                            borderRadius: radiusGeomentry,
                          ),
                          child: Column(

                            children: [
                              SizedBox(
                                height: size.height * 0.18,
                                width: size.width * 0.93,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: size.height * 0.01,
                                        left: size.height * 0.01,
                                        right: size.height * 0.01),
                                    child: InkWell(
                                      onTap: () {
                                        if (isDownloaded[index]) {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              child: PdfViewer(
                                                  document: newPath.path,
                                                  name: snapshot
                                                      .data["Notes-${index +
                                                      1}"]["File_Name"]),
                                              type: PageTransitionType
                                                  .bottomToTopJoined,
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              alignment: Alignment.bottomCenter,
                                              childCurrent: const Notes(),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    size.width * 0.05),
                                                topRight: Radius.circular(
                                                    size.width * 0.05)),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                "${snapshot.data["Notes-${index +
                                                    1}"]["thumbnailURL"]}",
                                              ), fit: BoxFit.cover,
                                            )
                                        ),),
                                    )
                                ),
                              ),
                              AnimatedContainer(
                                height: isExpanded[index]
                                    ? size.height * 0.22
                                    : size.height * 0.12,
                                width: size.width * 0.98,
                                duration: const Duration(milliseconds: 1),
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(56, 33, 101,1),
                                    borderRadius: radiusGeomentry

                                ),
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.018,
                                      ),
                                      ListTile(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(
                                                  size.width * 0.1),
                                              bottomRight: Radius.circular(
                                                  size.width * 0.12)),),
                                        title: Container(
                                            height: size.height * 0.07,
                                            width: size.width * 0.45,
                                            //ssscolor: Colors.redAccent,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                AutoSizeText(
                                                  snapshot.data["Notes-${index +
                                                      1}"]["File_Name"] != null
                                                      ?
                                                  snapshot.data["Notes-${index +
                                                      1}"]["File_Name"].toString()
                                                      :
                                                  "",
                                                  style: GoogleFonts.exo(
                                                      fontSize: size.height *
                                                          0.02,
                                                      color: Colors.white70,
                                                      fontWeight: FontWeight
                                                          .w500),
                                                    maxLines: 1,

                                                ),
                                                SizedBox(
                                                  height: size.height * 0.01,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    AutoSizeText(
                                                      snapshot.data["Notes-${index +
                                                          1}"]["File_Size"] != null
                                                          ?
                                                      "Size:${(int.parse(snapshot
                                                          .data["Notes-${index +
                                                          1}"]["File_Size"]
                                                          .toString()) / 1048576)
                                                          .toStringAsFixed(2)} MB"
                                                          :
                                                      "",
                                                      style: GoogleFonts.exo(
                                                          fontSize: size.height *
                                                              0.016,
                                                          color: Colors.white70,
                                                          fontWeight: FontWeight
                                                              .w500),),
                                                    AutoSizeText(
                                                      snapshot.data["Notes-${index +
                                                          1}"]["Stamp"] != null
                                                          ?
                                                      "Date: ${(snapshot
                                                          .data["Notes-${index +
                                                          1}"]["Stamp"].toDate())
                                                          .toString()
                                                          .split(" ")[0]}"
                                                          :
                                                      "",
                                                      style: GoogleFonts.exo(
                                                          fontSize: size.height *
                                                              0.016,
                                                          color: Colors.white70,
                                                          fontWeight: FontWeight
                                                              .w500),),
                                                  ],
                                                )
                                              ],
                                            )
                                        ),
                                        leading: Container(
                                            height: size.width * 0.07,
                                            width: size.width * 0.07,
                                            decoration: const BoxDecoration(
                                              color: Colors.transparent,
                                              shape: BoxShape.circle,
                                              /*image:DecorationImage(
                                              image: fileAlreadyExists
                                                  ?
                                              const AssetImage("assets/icon/pdf.png"):
                                              const AssetImage("assets/icon/download-button.png"),
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center, )*/
                                            ),
                                            child: isDownloaded[index]
                                                ?
                                            Image.asset("assets/icon/pdf.png")
                                                :
                                            isDownloading[index]
                                                ?
                                            Center(
                                              child: CircularPercentIndicator(
                                                percent: percent,
                                                radius: size.width * 0.035,
                                                animation: true,
                                                animateFromLastPercent: true,
                                                curve: accelerateEasing,
                                                progressColor: Colors.green,
                                                center: Text((percent * 100)
                                                    .toDouble()
                                                    .toStringAsFixed(0),
                                                  style: GoogleFonts.openSans(
                                                      fontSize: size.height *
                                                          0.02),),
                                                //footer: const Text("Downloading"),
                                                backgroundColor: Colors
                                                    .transparent,
                                                animationDuration:200 ,
                                              ),
                                            )
                                                :
                                            Center(
                                              child: InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      isDownloading[index] = true;
                                                    });

                                                    String path = "$dir/Campus Link/$university_filter $college_filter $course_filter $branch_filter $year_filter $section_filter $subject_filter/Notes/";

                                                    File newPath = File(
                                                        "$path${snapshot
                                                            .data["Notes-${index +
                                                            1}"]["File_Name"]}");
                                                    await newPath.exists().then((
                                                        value) async {
                                                      if (!value) {
                                                        print(".Start");
                                                        await dio.download(snapshot
                                                            .data["Notes-${index +
                                                            1}"]["Pdf_URL"],
                                                          newPath.path,
                                                          onReceiveProgress: (count,
                                                              total) {
                                                            if (count == total) {
                                                              setState(() {
                                                                filePath =
                                                                    newPath.path;
                                                                isDownloaded[index] =
                                                                true;
                                                                isDownloading[index] =
                                                                false;
                                                              });
                                                            }
                                                            else {
                                                              setState(() {
                                                                isDownloading[index] =
                                                                true;
                                                                percent =
                                                                (count / total);
                                                              });
                                                            }
                                                          },);
                                                      }
                                                      else {
                                                        print("..Already Exsist");
                                                      }
                                                    });
                                                  },
                                                  child: Icon(Icons.download,
                                                      color: Colors.black87,
                                                      size: size.width * 0.07)),
                                            )

                                        ),

                                        // subtitle: AutoSizeText('DEADLIiNE',style: GoogleFonts.exo(fontSize: size.height*0.015,color: Colors.black,fontWeight: FontWeight.w400),),
                                        trailing: FloatingActionButton(
                                            backgroundColor:Colors.lightBlueAccent,
                                            elevation: 0,
                                            onPressed: () {
                                              setState(() {

                                                isExpanded[index] = !isExpanded[index];

                                              });
                                            },
                                            child:
                                            Image.asset(
                                              "assets/icon/speech-bubble.png",
                                              width: size.height * 0.045,
                                              height: size.height * 0.045,)
                                        ),

                                      ),
                                      isExpanded[index]
                                          ?
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: size.height * 0.022),
                                          child: quizCreated
                                              ?
                                         Column(
                                           children: [
                                             Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                               children: [
                                                 //SizedBox(width: size.width*0.065,),
                                                 AutoSizeText("Deadline : ${deadline.toDate().toString().substring(0,16)}",style: GoogleFonts.poppins(
                                                     color: Colors.white70,
                                                     fontSize: size.height*0.012
                                                 ),),
                                                  AutoSizeText("Submission : ${snapshot.data["Notes-${index+1}"]["Submitted by"]!=null?snapshot.data["Notes-${index+1}"]["Submitted by"].length:0} / $totalStudents",style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: size.height*0.012
                                ),),
                                               ],
                                             ),
                                             SizedBox(height: size.width*0.028,),
                                             Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                               children: [
                                                 Container(
                                                   height: size.height * 0.046,
                                                   width: size.width * 0.34,
                                                   decoration: BoxDecoration(
                                                       gradient: const LinearGradient(
                                                         begin: Alignment.topLeft,
                                                         end: Alignment.bottomRight,
                                                         colors: [
                                                           Colors.blue,
                                                           Colors.purpleAccent,
                                                         ],
                                                       ),
                                                       borderRadius: BorderRadius.all(
                                                           Radius.circular(
                                                               size.width * 0.035)),
                                                       border: Border.all(
                                                           color: Colors.black, width: 2)
                                                   ),
                                                   child: ElevatedButton(
                                                       style: ElevatedButton.styleFrom(
                                                           backgroundColor: Colors
                                                               .transparent,
                                                           shape: RoundedRectangleBorder(
                                                               borderRadius: BorderRadius
                                                                   .all(
                                                                   Radius.circular(size
                                                                       .width * 0.035)))
                                                       ),

                                                       onPressed: () {
                                                         Navigator.pushReplacement(context,
                                                             PageTransition(
                                                                 child: responseScreen(
                                                                   quizId: index + 1,),
                                                                 type: PageTransitionType
                                                                     .bottomToTopJoined,
                                                                 childCurrent: const Notes(),
                                                                 duration: const Duration(
                                                                     milliseconds: 300)
                                                             )
                                                         );
                                                       },
                                                       child: AutoSizeText(
                                                         "See Response",
                                                         style: GoogleFonts.openSans(
                                                             fontSize: size.height * 0.022,
                                                             color: Colors.white
                                                         ),


                                                       )),
                                                 ),
                                                 Container(
                                                   height: size.height * 0.046,
                                                   width: size.width * 0.34,
                                                   decoration: BoxDecoration(
                                                       gradient: const LinearGradient(
                                                         begin: Alignment.topLeft,
                                                         end: Alignment.bottomRight,
                                                         colors: [
                                                           Colors.blue,
                                                           Colors.purpleAccent,
                                                         ],
                                                       ),
                                                       borderRadius: BorderRadius.all(
                                                           Radius.circular(
                                                               size.width * 0.035)),
                                                       border: Border.all(
                                                           color: Colors.black, width: 2)
                                                   ),
                                                   child: ElevatedButton(
                                                       style: ElevatedButton.styleFrom(
                                                           backgroundColor: Colors
                                                               .transparent,
                                                           shape: RoundedRectangleBorder(
                                                               borderRadius: BorderRadius
                                                                   .all(
                                                                   Radius.circular(size
                                                                       .width * 0.035)))
                                                       ),

                                                       onPressed: () {
                                                         Navigator.pushReplacement(context,
                                                             PageTransition(
                                                                 child: Quizscore(
                                                                   quizId: index + 1,),
                                                                 type: PageTransitionType
                                                                     .bottomToTopJoined,
                                                                 childCurrent: const Notes(),
                                                                 duration: const Duration(
                                                                     milliseconds: 300)
                                                             )
                                                         );
                                                       },
                                                       child: AutoSizeText(
                                                         "Leaderboard",
                                                         style: GoogleFonts.openSans(
                                                             fontSize: size.height * 0.022,
                                                             color: Colors.white
                                                         ),


                                                       )),
                                                 ),
                                               ],
                                             ),


                                           ],
                                         )
                                              :
                                          Container(
                                            height: size.height * 0.05,
                                            width: size.width * 0.45,
                                            decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.blue,
                                                    Colors.purpleAccent,
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        size.width * 0.035)),
                                                border: Border.all(
                                                    color: Colors.black, width: 2)
                                            ),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors
                                                        .transparent,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(size
                                                                .width * 0.035)))
                                                ),

                                                onPressed: () {
                                                  Navigator.pushReplacement(context,
                                                      PageTransition(
                                                          child: QuizQustion(
                                                            quizNumber: index + 1,),
                                                          type: PageTransitionType
                                                              .bottomToTopJoined,
                                                          childCurrent: const Notes(),
                                                          duration: const Duration(
                                                              milliseconds: 300)
                                                      )
                                                  );
                                                },
                                                child: AutoSizeText(
                                                  "Create Quiz",
                                                  style: GoogleFonts.openSans(
                                                      fontSize: size.height * 0.022,
                                                      color: Colors.white
                                                  ),


                                                )),
                                          )
                                      ) :
                                      const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                  }),
              ))
                :
            const SizedBox(
              child: Center(child: Text("No Data Found")),
            );
          },),
      )
      :
      Center(
        child: AutoSizeText("No data Found Yet",
          style: GoogleFonts.poppins(
              color: Colors.black26,
              fontSize: size.height*0.03
          ),),
      )
      :
          Center(
            child: AutoSizeText("Please Apply Filter First",
            style: GoogleFonts.poppins(
              color: Colors.black26,
              fontSize: size.height*0.03
            ),),
          ),


      floatingActionButton: subject_filter!=""
        ?
      Padding(
        padding: EdgeInsets.only(
            bottom: size.height * 0.015, right: size.height * 0.015),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: size.height * 0.06,
              width: size.width * 0.38,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue,
                      Colors.purpleAccent,
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.black, width: 2)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
                ),
                onPressed: () {

                  Navigator.push(context,
                      PageTransition(
                          child:const Quiz(),
                          type: PageTransitionType.bottomToTopJoined,
                          childCurrent: const Notes(),
                          duration: const Duration(milliseconds: 300)
                      )
                  );

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.upload_sharp,color: Colors.black),
                    AutoSizeText(
                      "Upload Notes",
                      style: TextStyle(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          :
          const SizedBox()
    );

  }
  Future<void> checkAndRequestPermissions() async {
    directory=await getExternalStorageDirectory();
    var permission = await checkALLPermissions.isStoragePermission();
    if (permission) {
      String? dir=directory?.path.toString().substring(0,19);
      String path="$dir/Campus Link/$university_filter $college_filter $course_filter $branch_filter $year_filter $section_filter $subject_filter/Notes/";
      Directory(path).exists().then((value) async {
        if(!value)
          {
            await Directory(path).create(recursive: true);
          }
      });
      setState(() {
        permissionGranted=true;
      });
    }
  }

  Future<void>checkExists()
  async {
    await FirebaseFirestore.instance.collection("Notes").doc("${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter")
        .get().then((value) {
          if(value.exists)
            {
              setState(() {

                isExpanded=List.generate(value.data()?["Total_Notes"], (index) =>  false);
                isDownloaded=List.generate(value.data()?["Total_Notes"], (index) =>  false);
                isDownloading=List.generate(value.data()?["Total_Notes"], (index) =>  false);
                docExists=true;
              });
              checkAndRequestPermissions();
            }

    });
  }

  Future<void> countStudents()
  async {
    await FirebaseFirestore.instance.collection("Students")
        .where("University",isEqualTo: university_filter)
        .where("College",isEqualTo: college_filter)
        .where("Branch",isEqualTo: branch_filter)
        .where("Course",isEqualTo: course_filter)
        .where("Year",isEqualTo: year_filter)
        .where("Section",isEqualTo: section_filter)
        .where("Subject",arrayContains: subject_filter)
        .get().then((value) {
       totalStudents=value.docs.length;
    });
  }

}

