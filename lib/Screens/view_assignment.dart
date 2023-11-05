import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constraints.dart';
import 'Chat_tiles/PdfViewer.dart';


class ViewAssignment extends StatefulWidget {
  ViewAssignment({super.key, required this.selectedindex });

  int selectedindex;


  @override
  State<ViewAssignment> createState() => _ViewAssignmentState();
}

class _ViewAssignmentState extends State<ViewAssignment> {
  bool docExists=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkExists();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Container(
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text("Assignment "),
          ),
          backgroundColor: Colors.transparent,
          body:
          docExists
              ?
          SizedBox(
              height: size.height,
              child: StreamBuilder(
                stream:FirebaseFirestore.instance
                    .collection("Assignment").doc("${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter")
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return snapshot.hasData
                      ?
                  SizedBox(
                    child: ListView.builder(
                        itemCount: snapshot.data.data()["Assignment-${widget.selectedindex}"]["Submitted-by"].length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding:  EdgeInsets.all(size.height*0.014),
                              child:  InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => PdfViewer(
                                      document: "${snapshot.data.data()["Assignment-${widget.selectedindex}"]["submitted-Assignment"]["Document-type"]}", name: "Assignment-${widget.selectedindex}",),
                                  ),
                                  );

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
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),

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
                                              "Assignment : ${widget.selectedindex}",
                                              style: GoogleFonts.courgette(
                                                  color: Colors.black,
                                                  fontSize: size.height*0.02,
                                                  fontWeight: FontWeight.w400
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                          height: size.height*0.104,
                                          width: size.width,
                                          decoration: const BoxDecoration(
                                            color:  Color.fromRGBO(60, 99, 100, 1),
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),

                                          ),
                                          child:Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText("Assignment:${widget.selectedindex}(${(int.parse(snapshot.data!["Assignment-${index + 1}"]["Size"].toString())/1048576).toStringAsFixed(2)}MB)",
                                                    style: GoogleFonts.courgette(
                                                        color: Colors.black,
                                                        fontSize: size.height*0.02,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                  AutoSizeText("Name:${snapshot.data.data()["Assignment-${widget.selectedindex}"]["Submitted-by"][index].toString().split("-")[1]}",
                                                    style: GoogleFonts.courgette(
                                                        color: Colors.black,
                                                        fontSize: size.height*0.02,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                  AutoSizeText("Roll-No:${snapshot.data.data()["Assignment-${widget.selectedindex}"]["Submitted-by"][index].toString().split("-")[2]}",
                                                    style: GoogleFonts.courgette(
                                                        color: Colors.black,
                                                        fontSize: size.height*0.02,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  )

                                                ],
                                              ),
                                              Container(
                                                height: size.height*0.045,
                                                width: size.width*0.2,
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                    border: Border.all(color: Colors.black, width: 1)
                                                ),
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                        backgroundColor: Colors.transparent
                                                    ),
                                                    onPressed: () {


                                                    },
                                                    child:  AutoSizeText("Reject",
                                                      style: GoogleFonts.gfsDidot(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: size.height*0.04
                                                      ),
                                                    )
                                                ),
                                              ),

                                              Container(
                                                height: size.height*0.045,
                                                width: size.width*0.2,
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                    border: Border.all(color: Colors.black, width: 1)
                                                ),
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                        backgroundColor: Colors.transparent
                                                    ),
                                                    onPressed: () {


                                                    },
                                                    child: AutoSizeText("Accept",
                                                      style: GoogleFonts.gfsDidot(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: size.height*0.05
                                                      ),
                                                    )),
                                              ),

                                            ],
                                          )
                                      )


                                    ],
                                  ),
                                ),
                              )
                          );
                        }
                    ),
                  )
                      :
                  const Center(child: Text("No Data Found"));

                },
              )

          ):
          const Center(
            child: SizedBox(
              child: AutoSizeText("NO Data Found"),
            ),
          )

      ),
    );
  }


  Future<void>checkExists()
  async {
    await FirebaseFirestore.instance.collection("Assignment").doc("${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter")
        .get().then((value) {
      if(value.exists)
      {
        setState(() {
          docExists=true;
        });
        // checkAndRequestPermissions();
      }

    });
  }

}
