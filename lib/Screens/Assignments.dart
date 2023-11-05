import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/upload_assignmentQuestion.dart';
import 'package:campus_link_teachers/Screens/view_assignment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Constraints.dart';
import '../push_notification/Storage_permission.dart';
import 'Chat_tiles/Image_viewer.dart';
import 'Chat_tiles/PdfViewer.dart';

class Assignments_upload extends StatefulWidget {
  const Assignments_upload({Key? key}) : super(key: key);

  @override
  State<Assignments_upload> createState() => _Assignments_uploadState();
}


PageController pageController=PageController();
bool active = false;
int currIndex=0;



class _Assignments_uploadState extends State<Assignments_upload> {


  var checkALLPermissions = CheckPermission();
  Directory? directory;
  List<bool> isdownloaded = [];
  List<bool> downloding = [];
  String path = "";
  double percent=0.0;
  bool permissionGranted = false;
  bool docExists = false;
  bool fileAlreadyExists = false;
  final dio = Dio();
  List<bool>isExpanded=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    docexits();
    checkAndRequestPermissions();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(86, 149, 178, 1),
            const Color.fromRGBO(68, 174, 218, 1),
            Colors.deepPurple.shade300
          ],
        ),
      ),
      child: Scaffold(
        // appBar: AppBar(
        //
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        //   actions: [
        //
        //     SizedBox(
        //       width: size.width,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: [
        //           Container(
        //             height: size.height * 0.048,
        //             width: size.width * 0.46,
        //             decoration: BoxDecoration(
        //                 gradient: const LinearGradient(
        //                   begin: Alignment.topLeft,
        //                   end: Alignment.bottomRight,
        //                   colors: [Colors.blue, Colors.purpleAccent],
        //                 ),
        //                 borderRadius:
        //                 const BorderRadius.all(Radius.circular(20)),
        //                 border: Border.all(color: Colors.black, width: 2)),
        //             child: ElevatedButton(
        //                 style: ElevatedButton.styleFrom(
        //                     shape: const StadiumBorder(),
        //                     backgroundColor: Colors.transparent),
        //                 onPressed: () {
        //                   setState(() {
        //
        //                     pageController.animateToPage(0,
        //                         duration: const Duration(milliseconds: 200),
        //                         curve: Curves.linear);
        //                   });
        //                 },
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     SizedBox(
        //                         width: size.width * 0.08,
        //                         child: const Image(
        //                           image: AssetImage(
        //                               "assets/images/view_assignment.png"),
        //                           fit: BoxFit.contain,
        //                         )),
        //                      AutoSizeText("View Assignment",
        //                        style:  GoogleFonts.exo(
        //                            color: Colors.white,
        //                            fontSize:
        //                            size.width *
        //                                0.033,
        //                            fontWeight: FontWeight.w600
        //                        ),
        //                     ),
        //                   ],
        //                 )),
        //           ),
        //           Container(
        //               height: size.height * 0.048,
        //               width: size.width * 0.46,
        //               decoration: BoxDecoration(
        //                   gradient: const LinearGradient(
        //                     begin: Alignment.topLeft,
        //                     end: Alignment.bottomRight,
        //                     colors: [
        //                       Colors.blue,
        //                       Colors.purpleAccent,
        //                     ],
        //                   ),
        //                   borderRadius:
        //                   const BorderRadius.all(Radius.circular(20)),
        //                   border: Border.all(color: Colors.black, width: 2)),
        //               child: ElevatedButton(
        //                   style: ElevatedButton.styleFrom(
        //                     shape: const StadiumBorder(),
        //                       backgroundColor: Colors.transparent),
        //                   onPressed: () {
        //
        //                     setState(() {
        //
        //                       pageController.animateToPage(1,
        //                           duration: const Duration(milliseconds: 200),
        //                           curve: Curves.linear);
        //                     });
        //
        //                   },
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                     children: [
        //                       SizedBox(
        //                           width: size.width * 0.06,
        //                           child: const Image(
        //                             image: AssetImage(
        //                                 "assets/images/upload-icon.png"),
        //                             fit: BoxFit.contain,
        //                           )),
        //                       SizedBox(width: size.width*0.02),
        //                       AutoSizeText("Upload Assignment",
        //                         style:  GoogleFonts.exo(
        //                             color: Colors.white,
        //                             fontSize: size.width * 0.032,
        //                             fontWeight: FontWeight.w600,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //               ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        extendBody: true,
        backgroundColor: Colors.transparent,
        // body:PageView(
        //   controller: pageController,
        //   children:   const [
        //     ViewAssignment(),
        //     UploadAssignmet(),
        //
        //
        //   ],
        // ),
        body: SizedBox(
            height: size.height,
            width: size.width,
            child: subject_filter.isEmpty ?
            const Center(
              child: Text("Please Apply filter to see the Assignment"),
            )
                :
            docExists
                ?
            SizedBox(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Assignment").doc(
                      "${university_filter.split(" ")[0]} ${college_filter
                          .split(" ")[0]} ${course_filter.split(
                          " ")[0]} ${branch_filter.split(
                          " ")[0]} $year_filter $section_filter $subject_filter")
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                    // if(snapshot.hasData){
                    //   docexits();
                    // }
                    return snapshot.hasData
                    ?
                SizedBox(

                  child: ListView.builder(
                    itemCount: snapshot.data!["Total_Assignment"],
                    itemBuilder: (context, index) {
                      String newpath =
                          "${path}Assignment-${index + 1}.${snapshot
                          .data!["Assignment-${index + 1}"]["Document-type"]}";
                      isdownloaded = List.generate(
                         snapshot .data!["Total_Assignment"],
                              (index) => false);
                      downloding = List.generate(
                          snapshot .data!["Total_Assignment"],
                              (index) => false);
                      File(newpath).exists().then((value) {
                        if (value) {
                              isdownloaded[index] = true;
                          print(isdownloaded[index]);
                        } else {

                            isdownloaded[index] = false;
                        }
                      });

                      return Padding(
                          padding: EdgeInsets.all(size.height*0.021),
                          child: InkWell(
                            onTap: (){
                              if( isdownloaded[index]) {
                                if (snapshot.data!["Assignment-${index +
                                    1}"]["Document-type"] == "pdf") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                            PdfViewer(
                                              document:
                                              "${path}Assignment-${index +
                                                  1}.${snapshot
                                                  .data!["Assignment-${index +
                                                  1}"]["Document-type"]}",
                                              name:
                                              "Assignment-${index + 1}",
                                            ),
                                      ));
                                }
                                else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                            Image_viewer(path: File(
                                                '${path}Assignment-${index +
                                                    1}.${snapshot
                                                    .data!["Assignment-${index +
                                                    1}"]["Document-type"]}'),

                                            ),
                                      ));
                                }
                              }
                            },

                            child: Container(

                              height: size.height*0.21,
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(color: Colors.black,width: 2)
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height*0.1,
                                    width: size.width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))

                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: size.height*0.01,
                                        ),
                                        AutoSizeText(
                                          subject_filter,
                                          style: GoogleFonts.courgette(
                                              color: Colors.black,
                                              fontSize: size.height*0.02,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                        AutoSizeText(
                                          "Assignment : ${index + 1}",
                                          style: GoogleFonts.courgette(
                                              color: Colors.black,
                                              fontSize: size.height*0.02,
                                              fontWeight: FontWeight.w400
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.all( size.height*0.008),
                                      height: size.height*0.104,
                                      width: size.width,
                                      decoration: const BoxDecoration(
                                        color:  Color.fromRGBO(60, 99, 100, 1),
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),

                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                "Assignment : ${index + 1} (${(int.parse(snapshot.data!["Assignment-${index + 1}"]["Size"].toString())/1048576).toStringAsFixed(2)}MB)",
                                                style: GoogleFonts.courgette(
                                                    color: Colors.black,
                                                    fontSize: size.height*0.019,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                              AutoSizeText(
                                                "Deadline :${snapshot
                                                    .data!["Assignment-${index +
                                                    1}"]["Last Date"]}",
                                                style: GoogleFonts.courgette(
                                                    color: Colors.black,
                                                    fontSize: size.height*0.019,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                              AutoSizeText(
                                                "Assign:${(snapshot
                                                    .data!["Assignment-${index +
                                                    1}"]["Assign-Date"].toDate()).toString().split(" ")[0]}",
                                                style: GoogleFonts.courgette(
                                                    color: Colors.black,
                                                    fontSize: size.height*0.02,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                            ],
                                          ),

                                          isdownloaded[index]
                                              ?
                                          // Container(
                                          //   height: size.height * 0.045,
                                          //   width: size.width * 0.2,
                                          //   decoration: BoxDecoration(
                                          //       color: Colors.deepPurple.shade400,
                                          //       borderRadius:
                                          //       const BorderRadius.all(
                                          //           Radius.circular(20)),
                                          //       border: Border.all(
                                          //           color: Colors.black,
                                          //           width: 1)),
                                          //   child: ElevatedButton(
                                          //       onPressed: () {
                                          //         if(snapshot
                                          //             .data!["Assignment-${index +
                                          //             1}"]["Document-type"]=="pdf"){
                                          //           Navigator.push(
                                          //               context,
                                          //               MaterialPageRoute(
                                          //                 builder:
                                          //                     (context) =>
                                          //                     PdfViewer(
                                          //                       document:
                                          //                       "${path}Assignment-${index +
                                          //                           1}.${snapshot
                                          //                           .data!["Assignment-${index +
                                          //                           1}"]["Document-type"]}",
                                          //                       name:
                                          //                       "Assignment-${index + 1}",
                                          //                     ),
                                          //               ));
                                          //         }
                                          //         else{
                                          //           Navigator.push(
                                          //               context,
                                          //               MaterialPageRoute(
                                          //                 builder:
                                          //                     (context) =>
                                          //                     Image_viewer(path: File('${path}Assignment-${index + 1}.${snapshot
                                          //                         .data!["Assignment-${index + 1}"]["Document-type"]}'),
                                          //
                                          //                     ),
                                          //               ));
                                          //         }
                                          //       },
                                          //       style: ElevatedButton.styleFrom(
                                          //           shape:
                                          //           const RoundedRectangleBorder(
                                          //               borderRadius:
                                          //               BorderRadius.all(
                                          //                   Radius
                                          //                       .circular(
                                          //                       20))),
                                          //           backgroundColor:
                                          //           Colors.transparent),
                                          //
                                          //       child: AutoSizeText(
                                          //         "View",
                                          //         style: GoogleFonts.gfsDidot(
                                          //             fontWeight: FontWeight.w600,
                                          //             fontSize:
                                          //             size.height * 0.035),
                                          //       )),
                                          // )
                                          const SizedBox()
                                              :
                                          downloding[index]
                                              ?
                                          Center(
                                            child:
                                            CircularPercentIndicator(
                                              percent:
                                              percent,
                                              radius:
                                              size.width * 0.04,
                                              animation: true,
                                              animateFromLastPercent:
                                              true,
                                              curve: accelerateEasing,
                                              progressColor:
                                              Colors.green,
                                              center: Text(
                                                (percent * 100)
                                                    .toStringAsFixed(
                                                    0),
                                                style: GoogleFonts
                                                    .openSans(
                                                    fontSize: size
                                                        .height *
                                                        0.024),
                                              ),
                                              //footer: const Text("Downloading"),
                                              backgroundColor:
                                              Colors.transparent,
                                            ),
                                          )
                                              :
                                          IconButton( onPressed: () async {
                                            setState(() {
                                              downloding[index]=true;
                                            });
                                            bool downloadecheck = await File(
                                                "${path}Assignment-${index +
                                                    1}.${snapshot
                                                    .data!["Assignment-${index +
                                                    1}"]["Document-type"]}")
                                                .exists();
                                            if (!downloadecheck) {
                                              setState(() {
                                                downloding[index] = true;
                                              });
                                              await dio.download(
                                                snapshot
                                                    .data!["Assignment-${index +
                                                    1}"]["Assignment"],
                                                File(newpath).path,
                                                onReceiveProgress:
                                                    (count, total) {
                                                  if (count ==
                                                      total) {
                                                    setState(() {
                                                      print(
                                                          "completed");
                                                      isdownloaded[
                                                      index] =
                                                      true;
                                                      downloding[
                                                      index] =
                                                      false;
                                                    });
                                                  } else {
                                                    if(mounted)
                                                    {
                                                      setState(() {
                                                        percent =count/total;

                                                      });
                                                    }

                                                  }
                                                },
                                              );
                                            }
                                          }, icon: Icon(Icons.download,
                                            color: Colors.white,
                                            size: size.height*0.03,)),

                                          // Container(
                                          //   height: size.height * 0.045,
                                          //   width: size.width * 0.25,
                                          //   decoration: BoxDecoration(
                                          //       color: Colors.deepPurple.shade400,
                                          //       borderRadius:
                                          //       const BorderRadius.all(
                                          //           Radius.circular(20)),
                                          //       border: Border.all(
                                          //           color: Colors.black,
                                          //           width: 1)),
                                          //   child: ElevatedButton(
                                          //       style: ElevatedButton.styleFrom(
                                          //           shape:
                                          //           const RoundedRectangleBorder(
                                          //               borderRadius:
                                          //               BorderRadius.all(
                                          //                   Radius
                                          //                       .circular(
                                          //                       20))),
                                          //           backgroundColor:
                                          //           Colors.transparent),
                                          //       onPressed: () async {
                                          //         setState(() {
                                          //           downloding[index]=true;
                                          //         });
                                          //         bool downloadecheck = await File(
                                          //             "${path}Assignment-${index +
                                          //                 1}.${snapshot
                                          //                 .data!["Assignment-${index +
                                          //                 1}"]["Document-type"]}")
                                          //             .exists();
                                          //         if (!downloadecheck) {
                                          //           setState(() {
                                          //             downloding[index] = true;
                                          //           });
                                          //           await dio.download(
                                          //             snapshot
                                          //                 .data!["Assignment-${index +
                                          //                 1}"]["Assignment"],
                                          //             File(newpath).path,
                                          //             onReceiveProgress:
                                          //                 (count, total) {
                                          //               if (count ==
                                          //                   total) {
                                          //                 setState(() {
                                          //                   print(
                                          //                       "completed");
                                          //                   isdownloaded[
                                          //                   index] =
                                          //                   true;
                                          //                   downloding[
                                          //                   index] =
                                          //                   false;
                                          //                 });
                                          //               } else {
                                          //                 if(mounted)
                                          //                 {
                                          //                   setState(() {
                                          //                     percent =count/total;
                                          //
                                          //                   });
                                          //                 }
                                          //
                                          //               }
                                          //             },
                                          //           );
                                          //         }
                                          //       },
                                          //       child: AutoSizeText(
                                          //         "Download",
                                          //         style: GoogleFonts.gfsDidot(
                                          //             fontWeight: FontWeight.w600,
                                          //             fontSize:
                                          //             size.height * 0.04),
                                          //       )),
                                          // ),

                                          Container(
                                            height: size.height * 0.045,
                                            width: size.width * 0.27,
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(20)),
                                                border: Border.all(
                                                    color: Colors.black, width: 1)
                                            ),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(20))),
                                                    backgroundColor: Colors
                                                        .transparent
                                                ),
                                                onPressed: () {
                                                  if (snapshot.data!
                                                      .data()?["Assignment-${index +
                                                      1}"]["Submitted-by"] != null) {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewAssignment(
                                                                  selectedindex: index +
                                                                      1),));
                                                  }
                                                }, child: const Text("Submission")),
                                          )


                                        ],
                                      )
                                  )


                                ],
                              ),
                            ),
                          )
                      );
                    },),
                )
                    :
                const SizedBox();
              }
              ),
            )
                :
            SizedBox(
              child: Center(
                child: AutoSizeText(
                  "No Data Found Yet",
                  style: GoogleFonts.openSans(
                      color: Colors.white70,
                      fontSize: size.height*0.04
                  ),
                ),
              ),
            )


        )
        ,

        floatingActionButton: Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue, Colors.purpleAccent],
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: Colors.black, width: 1)
          ),
          width: size.width * 0.36,
          height: size.height * 0.05,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/images/upload-icon.png",),
                // const Icon(
                //   Icons.upload,
                //   color: Colors.white70,
                // ),
                SizedBox(width: size.width*0.02,),
                AutoSizeText("Upload File",style: GoogleFonts.tiltNeon(
                    color: Colors.black,
                    //const Color.fromRGBO(150, 150, 150, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: size.width*0.035),
                ),
            ],
            ),
            onPressed: () {
              subject_filter.isEmpty
                  ?
              showDialog(
                context: context,
                builder: (ctx) =>
                    AlertDialog(

                      title: const Text("Do You Want to Upload Assignment"),
                      content: const Text("Please Apply Filter First"),
                      actions: <Widget>[
                        TextButton(

                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("okay"),
                        ),
                      ],
                    ),
              )
                  :
              Navigator.push(context, PageTransition(
                child: const AssigmentQuestion(),
                type: PageTransitionType.bottomToTopJoined,
                duration: const Duration(milliseconds: 300),
                childCurrent: const Assignments_upload(),

              ));
            },
          ),
        ),
      ),
    );
  }

  Future<void> checkAndRequestPermissions() async {
    directory = await getExternalStorageDirectory();

    var permission = await checkALLPermissions.isStoragePermission();
    if(!permission){
      if(await Permission.manageExternalStorage.request().isGranted){
        permission=true;
      }else{
        await Permission.manageExternalStorage.request().then((value) {
          bool check=value.isGranted;
          if(check){permission=true;}});
      }

    }
    if (permission) {
      String? dir = directory?.path.toString().substring(0, 19);
      path =
      "$dir/Campus Link/${university_filter.split(" ")[0]}${college_filter
          .split(" ")[0]}${course_filter.split(" ")[0]}${branch_filter.split(
          " ")[0]}$year_filter$section_filter$subject_filter/Assignment/";
      Directory(path).exists().then((value) async {
        if (!value) {
          await Directory(path)
              .create(recursive: true)
              .whenComplete(() => print(">>>>>created"));
        }
      });
      setState(() {
        permissionGranted = true;
      });
    } else {
      permissionGranted = false;
    }
  }


  Future<void> docexits() async {
    FirebaseFirestore.instance
        .collection("Assignment").doc(
        "${university_filter.split(" ")[0]} ${college_filter.split(
            " ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(
            " ")[0]} $year_filter $section_filter $subject_filter")
        .get().then( (value) {
      if(value.exists){

        print(".......Yes Not Null");
        setState(() {
          isdownloaded = List.generate(
              value.data()?["Total_Assignment"],
                  (index) => false);
          downloding = List.generate(
              value.data()?["Total_Assignment"],
                  (index) => false);

          docExists=true;
        }
        );

      }
      else{
        setState(() {
          docExists=false;
        });
      }

    });
  }


}


