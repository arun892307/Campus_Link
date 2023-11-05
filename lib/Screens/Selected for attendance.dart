import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constraints.dart';
import 'Attendance.dart';

class SelectedStudents extends StatefulWidget {
  const SelectedStudents({Key? key}) : super(key: key);

  @override
  State<SelectedStudents> createState() => _SelectedStudentsState();
}

class _SelectedStudentsState extends State<SelectedStudents> {
  List<String> marked_email=[];
  GeoPoint reset_pos= const GeoPoint(0, 0);

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(
            height: size.height*0.68,
            child: StreamBuilder(
              stream: FirebaseFirestore
                  .instance
                  .collection("Students")
                  .where("University", isEqualTo: university_filter)
                  .where("College",isEqualTo: college_filter)
                  .where("Course",isEqualTo: course_filter)
                  .where("Branch",isEqualTo: branch_filter)
                  .where("Year",isEqualTo: year_filter)
                  .where("Section",isEqualTo: section_filter)
                  .where("Subject",arrayContains: subject_filter)
                  .where("Active",isEqualTo: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.hasData
                    ?

                ListView.builder(

                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return distance_filter(snapshot.data.docs[index]["Location"].latitude, snapshot.data.docs[index]["Location"].longitude,snapshot.data.docs[index]["Email"])
                        ?
                    Container(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,right: MediaQuery.of(context).size.width*0.03),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          //color: const Color.fromRGBO(12, 12, 12, 1).withOpacity(0.6),
                          gradient: const LinearGradient(colors: [
                            Colors.black87,
                            Colors.black45
                          ]),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              blurStyle: BlurStyle.outer,
                              color: Colors.white.withOpacity(0.6),
                              offset: const Offset(0, 0),
                            )
                          ]
                      ),
                      margin: const EdgeInsets.all(5),
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:  [
                              Text(snapshot.data.docs[index]["Name"],style: GoogleFonts.exo(color: Colors.white)),
                              SizedBox(
                                height: size.height*0.01,
                              ),
                              Text(snapshot.data.docs[index]["Rollnumber"],style: GoogleFonts.exo(color: Colors.white)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.03,
                              ),
                              IconButton(
                                  onPressed: () async{
                                    await FirebaseFirestore.instance.collection("Students").doc(snapshot.data.docs[index]["Email"]).update(
                                      {"Active" : false
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.clear_outlined,color: Colors.red,))
                            ],
                          )
                        ],
                      ),
                    )
                        :
                      Container();
                  },
                )

                    :
                const Center(
                  child: CircularProgressIndicator(color: Colors.yellow,),
                );
              }
              ,),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.5),
              elevation: 0,
              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: const BorderSide(
                color: Colors.white,
                width: 1
              )
            ),
              onPressed: () async {
              await FirebaseFirestore
                  .instance
                  .collection("Students")
                  .where("University", isEqualTo: university_filter)
                  .where("College",isEqualTo: college_filter)
                  .where("Course",isEqualTo: course_filter)
                  .where("Branch",isEqualTo: branch_filter)
                  .where("Year",isEqualTo: year_filter)
                  .where("Section",isEqualTo: section_filter)
                  .where("Subject",arrayContains: subject_filter)
                  .get()
                  .then(
                      (value) => value
                          .docs.
                      forEach((element) async { await FirebaseFirestore
                          .instance
                          .collection("Students")
                          .doc(element.data()["Email"]).update({
                        "$subject_filter-total-lectures": FieldValue.increment(1)
                      });
                      }));
              setState(() {
                marked_email.toSet().toList();
              });
              marked_email.forEach((element) async {

                await FirebaseFirestore
                    .instance
                    .collection("Students")
                    .doc(element)
                    .update({
                  "Active":false,
                  "Attendance":false,
                  "Location": reset_pos
                });

                final docref = await FirebaseFirestore.instance.collection("Students").doc(element).collection("Attendance")
                    .doc("$subject_filter-${DateTime.now().month}").get();

                docref.data()==null
                    ?
                await FirebaseFirestore
                    .instance
                    .collection("Students")
                    .doc(element)
                    .collection("Attendance").
                doc("$subject_filter-${DateTime.now().month}")
                    .set({
                  "${DateTime.now().day}" : FieldValue.arrayUnion([DateTime.timestamp()])
                })

                    :
                await FirebaseFirestore
                    .instance
                    .collection("Students")
                    .doc(element)
                    .collection("Attendance").
                doc("$subject_filter-${DateTime.now().month}")
                    .update({
                  "${DateTime.now().day}" : FieldValue.arrayUnion([DateTime.timestamp()]),
                  "count_attendance": FieldValue.increment(1)
                });


                marked_email.remove(element);
              });
              },
              child: AutoSizeText("Mark Attendance",
                style: GoogleFonts.exo(
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
          ),
        ],
      ),
    );
  }

  bool distance_filter(double lat,double long,String Email){
    bool out=true;
    Geolocator.distanceBetween(tecloc.latitude, tecloc.longitude, lat, long) < range
        ?
    marked_email.add(Email)
        :
    out=false;

    return out;
  }

  Future<void> active_false(String Email) async {
    await FirebaseFirestore
        .instance
        .collection("Students")
        .doc(Email)
        .update({
      "Active" : false
    });
  }
}
