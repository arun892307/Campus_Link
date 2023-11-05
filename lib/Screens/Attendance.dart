import 'dart:async';
import 'package:campus_link_teachers/Database/database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'Navigator.dart';
import 'loadingscreen.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);
  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {

  bool active = false;
  GeoPoint reset_pos = const GeoPoint(0, 0);
  List<String> marked_email = [];
  List<String> all_email = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: subject_filter.isEmpty
            ? Center(
          child: Text(
            "Please apply filter to take attendance",
            style: GoogleFonts.exo(
                color: Colors.black45,
                fontWeight: FontWeight.w700,
                fontSize: 20),
          ),
        )
            : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: size.height*0.015,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Students")
                        .where("University", isEqualTo: university_filter)
                        .where("College", isEqualTo: college_filter)
                        .where("Course", isEqualTo: course_filter)
                        .where("Branch", isEqualTo: branch_filter)
                        .where("Year", isEqualTo: year_filter)
                        .where("Section", isEqualTo: section_filter)
                        .where("Subject", arrayContains: subject_filter)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ?
                      Container(
                        decoration: BoxDecoration(
                            gradient: !active
                                ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue,
                                Colors.purpleAccent
                              ],
                            )
                                : const LinearGradient(colors: [
                              Colors.black87,
                              Colors.black45
                            ]),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: Colors.black, width: 2)),
                        padding: EdgeInsets.all(size.width * 0.01),
                        height:
                        MediaQuery.of(context).size.height * 0.05,
                        width:
                        MediaQuery.of(context).size.width * 0.45,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              active = false;
                            });
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                  height: size.height * 0.09,
                                  width: size.width * 0.12,
                                  child: const Image(
                                    image: AssetImage(
                                        "assets/images/all_students.png"),
                                    fit: BoxFit.contain,
                                  )),
                              AutoSizeText(
                                  "All Students (${snapshot.data?.docs.length})",
                                  style: GoogleFonts.exo(
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      )
                          :
                      const SizedBox();
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Students")
                        .where("University", isEqualTo: university_filter)
                        .where("College", isEqualTo: college_filter)
                        .where("Course", isEqualTo: course_filter)
                        .where("Branch", isEqualTo: branch_filter)
                        .where("Year", isEqualTo: year_filter)
                        .where("Section", isEqualTo: section_filter)
                        .where("Subject", arrayContains: subject_filter)
                        .where("Active",isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ?
                      Container(
                        decoration: BoxDecoration(
                            gradient: active
                                ? const LinearGradient(colors: [
                              Colors.blue,
                              Colors.purpleAccent
                            ])
                                : const LinearGradient(colors: [
                              Colors.black87,
                              Colors.black45
                            ]),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: Colors.black, width: 2)),
                        padding: EdgeInsets.all(size.width * 0.01),
                        height: size.height * 0.05,
                        width: size.width * 0.48,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () async {
                            setState(() {
                              active = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                EdgeInsets.all(size.width * 0.01),
                                //height: size.height*0.8,
                                width: size.width * 0.08,
                                child: const Image(
                                  image: AssetImage(
                                      "assets/images/appeared_student.png"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.37,
                                child: AutoSizeText(
                                    "Appeared Students (${snapshot.data?.docs.length})",
                                    style: GoogleFonts.exo(
                                        color: Colors.white),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ),
                      )
                          :
                      const SizedBox();
                    },
                  )

                ],
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Students")
                    .where("University", isEqualTo: university_filter)
                    .where("College", isEqualTo: college_filter)
                    .where("Course", isEqualTo: course_filter)
                    .where("Branch", isEqualTo: branch_filter)
                    .where("Year", isEqualTo: year_filter)
                    .where("Section", isEqualTo: section_filter)
                    .where("Subject", arrayContains: subject_filter)
                    .where("Active",whereIn: [true,false])
                    .where("Name",isNull: false)
                    .orderBy("Name")
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                  return snapshot.hasData
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height*0.01),
                      SizedBox(
                          height: size.height * 0.75,
                          child: !active
                              ?
                          ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              snapshot.data?.docs[index]["Active"]
                                  ?
                              distance_filter(
                                  snapshot.data?.docs[index]["Location"].latitude,
                                  snapshot.data?.docs[index]["Location"].longitude,
                                  snapshot.data?.docs[index]["Email"])
                                  :
                              marked_email.remove(snapshot.data?.docs[index]["Email"]);
                              all_email.add(snapshot.data?.docs[index]["Email"]);
                              return Container(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.03,
                                    right: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.03),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    //color: const Color.fromRGBO(12, 12, 12, 1).withOpacity(0.6),
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1.5),
                                    gradient: const LinearGradient(
                                        colors: [
                                          Colors.black87,
                                          Colors.black45
                                        ]),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 6,
                                        blurStyle: BlurStyle.outer,
                                        color: Colors.white
                                            .withOpacity(0.6),
                                        offset: const Offset(0, 0),
                                      )
                                    ]),
                                margin: const EdgeInsets.all(5),
                                height: MediaQuery.of(context)
                                    .size
                                    .height *
                                    0.07,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapshot.data.docs[index]["Name"],
                                          style: GoogleFonts.exo(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        Text(
                                            snapshot.data.docs[index]
                                            ["Rollnumber"],
                                            style: GoogleFonts.exo(
                                                color: Colors.white)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await FirebaseFirestore
                                                .instance
                                                .collection("Students")
                                                .doc(snapshot.data.docs[index]["Email"])
                                                .update(
                                              {
                                                "Active": true,
                                                "Location": GeoPoint(
                                                    tecloc.latitude,
                                                    tecloc.longitude)
                                              },
                                            );
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.check,
                                              color: marked_email.contains(snapshot.data.docs[index]["Email"])
                                                  ? const Color
                                                  .fromRGBO(
                                                  150,
                                                  150,
                                                  150,
                                                  1)
                                                  : Colors.green,
                                              size: 28),
                                        ),
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.03,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                              :
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Students")
                                .where("University", isEqualTo: university_filter)
                                .where("College", isEqualTo: college_filter)
                                .where("Course", isEqualTo: course_filter)
                                .where("Branch", isEqualTo: branch_filter)
                                .where("Year", isEqualTo: year_filter)
                                .where("Section", isEqualTo: section_filter)
                                .where("Subject", arrayContains: subject_filter)
                                .where("Active", isEqualTo: true)
                                .where("Name",isNull: false)
                                .orderBy("Name")
                                .snapshots(),
                            builder: (context, snapshot) {
                              return  snapshot.hasData
                                  ?
                              Column(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.66,
                                    child: ListView.builder(
                                      itemCount: snapshot
                                          .data!.docs.length,
                                      itemBuilder:
                                          (context, index) {
                                        return distance_filter(
                                            snapshot.data?.docs[index]["Location"].latitude,
                                            snapshot.data?.docs[index]["Location"].longitude,
                                            snapshot.data?.docs[index]["Email"])
                                            ? Container(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context).size.width * 0.03,
                                              right: MediaQuery.of(context).size.width * 0.03),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(12),
                                              //color: const Color.fromRGBO(12, 12, 12, 1).withOpacity(0.6),
                                              gradient: const LinearGradient(
                                                  colors: [
                                                    Colors.black87,
                                                    Colors.black45
                                                  ]),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius:
                                                  6,
                                                  blurStyle:
                                                  BlurStyle
                                                      .outer,
                                                  color: Colors
                                                      .white
                                                      .withOpacity(
                                                      0.6),
                                                  offset:
                                                  const Offset(
                                                      0,
                                                      0),
                                                )
                                              ]),
                                          margin:
                                          const EdgeInsets
                                              .all(5),
                                          height: MediaQuery.of(
                                              context)
                                              .size
                                              .height *
                                              0.07,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  Text(
                                                      snapshot.data?.docs[index]
                                                      [
                                                      "Name"],
                                                      style:
                                                      GoogleFonts.exo(color: Colors.white)),
                                                  SizedBox(
                                                    height: size.height *
                                                        0.01,
                                                  ),
                                                  Text(
                                                      snapshot.data?.docs[index]
                                                      [
                                                      "Rollnumber"],
                                                      style:
                                                      GoogleFonts.exo(color: Colors.white)),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .end,
                                                children: [
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width *
                                                        0.03,
                                                  ),
                                                  IconButton(
                                                      onPressed:
                                                          () async {
                                                        await FirebaseFirestore.instance.collection("Students").doc(snapshot.data?.docs[index]["Email"]).update(
                                                          {
                                                            "Active": false
                                                          },
                                                        );
                                                        setState(() {
                                                          marked_email.remove(snapshot.data?.docs[index]["Email"]);
                                                        });
                                                      },
                                                      icon:
                                                      const Icon(
                                                        Icons.clear_outlined,
                                                        color:
                                                        Colors.red,
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                            colors: [
                                              Colors.blue,
                                              Colors.purpleAccent
                                            ]
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                                        border: Border.all(
                                            color: Colors.black,
                                            width: 1.5
                                        )
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: const loading(text: "Please Wait Uploading Students attendance on server"),
                                            type: PageTransitionType.bottomToTopJoined,
                                            duration: const Duration(milliseconds: 200),
                                            alignment: Alignment.bottomCenter,
                                            childCurrent: const Attendance(),
                                          ),
                                        );
                                        await FirebaseFirestore
                                            .instance
                                            .collection("Students")
                                            .where("University", isEqualTo: university_filter)
                                            .where("College", isEqualTo: college_filter)
                                            .where("Course", isEqualTo: course_filter)
                                            .where("Branch", isEqualTo: branch_filter)
                                            .where("Year", isEqualTo: year_filter)
                                            .where("Section", isEqualTo: section_filter)
                                            .where("Subject", arrayContains: subject_filter)
                                            .where("Active", isEqualTo: true)
                                            .get()
                                            .then((value) =>
                                            value.docs.forEach((element) async {
                                              await FirebaseFirestore
                                                  .instance
                                                  .collection("Students")
                                                  .doc(element
                                                  .data()["Email"]).update({
                                                "$subject_filter-total-lectures": FieldValue.increment(1)
                                              });
                                            }));
                                        setState(() {
                                          marked_email = marked_email.toSet().toList();
                                          all_email=all_email.toSet().toList();
                                        });
                                        for(var element in all_email){
                                          if(marked_email.contains(element)){
                                            await FirebaseFirestore
                                                .instance
                                                .collection("Students")
                                                .doc(element)
                                                .update(
                                                {
                                                  "Active": false,
                                                  "Location": reset_pos
                                                });
                                            var token;
                                            await FirebaseFirestore.instance.collection("Students").doc(element).get().then((value) => token=value.data()?["Token"]);

                                            final docref = await FirebaseFirestore.instance
                                                .collection("Students")
                                                .doc(element)
                                                .collection("Attendance")
                                                .doc("$subject_filter-${DateTime.now().month}")
                                                .get();

                                            docref.data() == null
                                                ?
                                            await FirebaseFirestore
                                                .instance
                                                .collection("Students")
                                                .doc(element)
                                                .collection("Attendance")
                                                .doc("$subject_filter-${DateTime.now().month}")
                                                .set({
                                              "${DateTime.now().day}": FieldValue.arrayUnion([{
                                                "Time":DateTime.timestamp(),
                                                "Status" : "Present"
                                              }]),
                                              "count_attendance": FieldValue.increment(1)
                                            })
                                                :
                                            await FirebaseFirestore
                                                .instance
                                                .collection("Students")
                                                .doc(element)
                                                .collection("Attendance")
                                                .doc("$subject_filter-${DateTime.now().month}")
                                                .update(
                                                {
                                                  "${DateTime.now().day}": FieldValue.arrayUnion([{
                                                    "Time":DateTime.timestamp(),
                                                    "Status" : "Present"
                                                  }]),
                                                  "count_attendance": FieldValue.increment(1)
                                                });
                                            database().sendPushMessage(token, "Attendance marked", subject_filter,false,"",DateTime.now());
                                            marked_email.remove(element);
                                          }
                                          else{
                                            await FirebaseFirestore
                                                .instance
                                                .collection("Students")
                                                .doc(element)
                                                .update(
                                                {
                                                  "Active": false,
                                                  "Location": reset_pos
                                                });
                                            var token;
                                            await FirebaseFirestore.instance.collection("Students").doc(element).get().then((value) => token=value.data()?["Token"]);

                                            final docref = await FirebaseFirestore.instance
                                                .collection("Students")
                                                .doc(element)
                                                .collection("Attendance")
                                                .doc("$subject_filter-${DateTime.now().month}")
                                                .get();

                                            docref.data() == null
                                                ?
                                            await FirebaseFirestore
                                                .instance
                                                .collection("Students")
                                                .doc(element)
                                                .collection("Attendance")
                                                .doc("$subject_filter-${DateTime.now().month}")
                                                .set(
                                                {
                                                  "${DateTime.now().day}": FieldValue.arrayUnion([{
                                                    "Time":DateTime.timestamp(),
                                                    "Status" : "Absent"
                                                  }]),
                                                  "count_attendance": FieldValue.increment(1)
                                                })
                                                :
                                            await FirebaseFirestore
                                                .instance
                                                .collection("Students")
                                                .doc(element)
                                                .collection("Attendance")
                                                .doc("$subject_filter-${DateTime.now().month}")
                                                .update(
                                                {
                                                  "${DateTime.now().day}": FieldValue.arrayUnion([{
                                                    "Time":DateTime.timestamp(),
                                                    "Status" : "Absent"
                                                  }]),
                                                  "count_attendance": FieldValue.increment(1)
                                                });
                                            database().sendPushMessage(token, "Attendance Missed", subject_filter,false,"",DateTime.now());
                                            marked_email.remove(element);
                                          }
                                        }

                                        Navigator.pop(context);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Nevi(),));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AutoSizeText(
                                          "Mark Attendance ✔",
                                          style: GoogleFonts.exo(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                                  :
                              const Center(
                                child: CircularProgressIndicator(color: Colors.black),
                              );
                            },
                          )
                      ),
                    ],
                  )
                      : const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                },
              ),
            ],
          ),
        ));
  }


  bool distance_filter(double lat, double long, String Email)  {
    bool out = true;
    print("$tecloc");
    final temp=Geolocator.distanceBetween(double.parse(tecloc.latitude.toStringAsPrecision(21)),double.parse(tecloc.longitude.toStringAsPrecision(21)), lat, long) ;
    print(temp);
    temp < range +10
        ? marked_email.add(Email)
        : out = false;
    marked_email = marked_email.toSet().toList();
    print(marked_email);
    if(!out){
      active_false(Email);
    }
    return out;
  }

  Future<void> active_false(String Email) async {
    await FirebaseFirestore.instance
        .collection("Students")
        .doc(Email)
        .update({"Active": false});
  }

}
