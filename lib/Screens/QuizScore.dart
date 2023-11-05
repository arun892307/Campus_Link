import 'package:campus_link_teachers/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constraints.dart';

class Quizscore extends StatefulWidget {
   Quizscore({super.key,required this.quizId});
 int quizId;
  @override
  State<Quizscore> createState() => _QuizscoreState();
}

class _QuizscoreState extends State<Quizscore> {

  List<Map<String,dynamic>>result=[];
  late DocumentSnapshot<Map<String, dynamic>> snapshot;
  bool load=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchtData();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title:  Center(
            child: AutoSizeText(
              '${subject_filter} Leaderboard Quiz ${widget.quizId}',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child:load
            ?
          Column(
            children: [

              SizedBox(
                  height: size.height * 0.34,
                  child: Row(children: [
                    SizedBox(
                      width: size.width * 0.07,
                    ),
                    SizedBox(
                        width: size.width * 0.214,
                        child: Column(children: [
                          SizedBox(
                              height: ((size.height * 0.12) + (size.width * 0.214)),
                              child: Stack(children: [
                                Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: size.width * 0.107,
                                      child: CircleAvatar(
                                        radius: size.width * 0.1,
                                        backgroundImage: const NetworkImage(
                                            'https://wallpapercave.com/wp/wp8974363.jpg'),
                                      ),
                                    )),
                                Positioned(
                                    top: ((size.height * 0.12) -
                                        (size.width * 0.03)),
                                    left: ((size.width * 0.107) -
                                        (size.width * 0.03)),
                                    child: CircleAvatar(
                                        radius: size.width * 0.03,
                                        backgroundColor: Colors.black,
                                        child: CircleAvatar(
                                            radius: size.width * 0.026,
                                            child: const SizedBox(
                                                child: AutoSizeText(
                                                  '2',
                                                  textAlign: TextAlign.center,
                                                )))))
                              ])),
                          Center(
                              child: SizedBox(
                                  width: size.width * 0.2,
                                  child: AutoSizeText(
                                    result[1]["Name-Rollnumber"].toString().split("-")[0],
                                    style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    //minFontSize: size.width * 0.03,
                                  ))),
                           AutoSizeText("${result[1]["Score"].toString()} / 10",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 10, 52, 84),
                                  fontWeight: FontWeight.w500))
                        ])),
                    SizedBox(
                      width: size.width * 0.069,
                    ),
                    SizedBox(
                        width: size.width * 0.294,
                        child: Column(children: [
                          SizedBox(
                              height:
                              ((size.height * 0.05) + (size.width * 0.294)),
                              child: Stack(children: [
                                Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: CircleAvatar(
                                        radius: size.width * 0.147,
                                        backgroundColor: Colors.black,
                                        child: CircleAvatar(
                                          radius: size.width * 0.14,
                                          backgroundImage: const NetworkImage(
                                              'https://images.wallpapersden.com/image/download/iron-man-digital-fan-art_bGllZ22UmZqaraWkpJRsa21lrWloZ2U.jpg'),
                                        ))),
                                Positioned(
                                    top: ((size.height * 0.05) -
                                        (size.width * 0.03)),
                                    left: ((size.width * 0.147) -
                                        (size.width * 0.03)),
                                    child: CircleAvatar(
                                        radius: size.width * 0.03,
                                        backgroundColor: Colors.black,
                                        child: CircleAvatar(
                                            radius: size.width * 0.026,
                                            child: const SizedBox(
                                                child: AutoSizeText(
                                                  '1',
                                                  textAlign: TextAlign.center,
                                                )))))
                              ])),
                          Center(
                              child: SizedBox(
                                  width: size.width * 0.24,
                                  child: AutoSizeText(
                                    result[0]["Name-Rollnumber"].toString().split("-")[0],
                                    style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    //minFontSize: size.width * 0.03,
                                  ))),
                           AutoSizeText("${result[0]["Score"].toString()} / 10",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 10, 52, 84),
                                  fontWeight: FontWeight.w500))
                        ])),
                    SizedBox(
                      width: size.width * 0.069,
                    ),
                    SizedBox(
                        width: size.width * 0.214,
                        child: Column(children: [
                          SizedBox(
                            height: ((size.height * 0.12) + (size.width * 0.214)),
                            child: Stack(children: [
                              Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: size.width * 0.107,
                                      child: CircleAvatar(
                                        radius: size.width * 0.1,
                                        backgroundImage: const NetworkImage(
                                            'https://wallpaperaccess.com/full/4791232.jpg'),
                                      ))),
                              Positioned(
                                  top: ((size.height * 0.12) -
                                      (size.width * 0.03)),
                                  left: ((size.width * 0.107) -
                                      (size.width * 0.03)),
                                  child: CircleAvatar(
                                      radius: size.width * 0.03,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                          radius: size.width * 0.026,
                                          child: const SizedBox(
                                              child: AutoSizeText(
                                                '3',
                                                textAlign: TextAlign.center,
                                              )))))
                            ]),
                          ),
                          SizedBox(
                              width: size.width * 0.2,
                              child: AutoSizeText(
                                result[2]["Name-Rollnumber"].toString().split("-")[0],
                                style: TextStyle(
                                    fontSize: size.width * 0.04,
                                    fontWeight: FontWeight.bold),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                //minFontSize: size.width * 0.03,
                              )),
                           AutoSizeText("${result[2]["Score"].toString()} / 10",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 10, 52, 84),
                                  fontWeight: FontWeight.w500))
                        ]))
                  ])),
              SizedBox(
                height: size.height * 0.05,
              ),
              Column(
                  children: [
                    SizedBox(
                        height: size.height * 0.371,
                        child: ListView.builder(
                          itemCount:result.length-3,
                          itemBuilder: (context, index) {

                            return Padding(
                              padding: EdgeInsets.all(size.height * 0.008),
                              child: Container(
                                height: size.height * 0.08,
                                child: Row(
                                  children: [
                                    Container(
                                      width: size.width * 0.1,
                                      child: Center(
                                          child: AutoSizeText(
                                              "${index+3}"
                                          )),
                                    ),
                                    Container(
                                        height: size.height * 0.07,
                                        width: size.width * 0.8,
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(size.width * 0.08)),
                                          color: const Color.fromARGB(255, 228, 243, 247),
                                        ),
                                        child: Row(children: [
                                          Padding(
                                            padding:
                                            EdgeInsets.all(size.height * 0.006),
                                            child: CircleAvatar(
                                                radius: size.width * 0.06,
                                                backgroundColor: Colors.black,
                                                child: CircleAvatar(
                                                  radius: size.width * 0.053,
                                                  backgroundColor: const Color.fromARGB(
                                                      255, 128, 193, 246),
                                                )),
                                          ),
                                          SizedBox(
                                              width: size.width * 0.5,
                                              child: AutoSizeText(
                                                result[index+3]["Name-Rollnumber"].toString().split("-")[0],
                                                style: TextStyle(
                                                    fontSize: size.width * 0.045),
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                              )),
                                           AutoSizeText("${result[index+3]["Score"].toString()} / 10",
                                              style: const TextStyle(
                                                  color:Color.fromARGB(255, 10, 52, 84),
                                                  fontWeight: FontWeight.w500)),
                                        ])),
                                  ],
                                ),
                              ),
                            );
                          },

                        ))
                  ])
              /*StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Notes").doc("${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter").snapshots(),
                builder: (context, snapshot) {
                  bool loaded=false;
                  if(snapshot.hasData)
                  {
                    //calculateResult(snapshot);
                  }
                  return  snapshot.hasData
                      ?
                  Column(
                      children: [
                        SizedBox(
                            height: size.height * 0.371,
                            child: ListView.builder(
                              itemCount:studentNames.length,
                              itemBuilder: (context, index) {

                                return Padding(
                                  padding: EdgeInsets.all(size.height * 0.008),
                                  child: Container(
                                    height: size.height * 0.08,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: size.width * 0.1,
                                          child: Center(child: Text('${index + 1}')),
                                        ),
                                        Container(
                                            height: size.height * 0.07,
                                            width: size.width * 0.8,
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(size.width * 0.08)),
                                              color: Color.fromARGB(255, 228, 243, 247),
                                            ),
                                            child: Row(children: [
                                              Padding(
                                                padding:
                                                EdgeInsets.all(size.height * 0.006),
                                                child: CircleAvatar(
                                                    radius: size.width * 0.06,
                                                    backgroundColor: Colors.black,
                                                    child: CircleAvatar(
                                                      radius: size.width * 0.053,
                                                      backgroundColor: const Color.fromARGB(
                                                          255, 128, 193, 246),
                                                    )),
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.5,
                                                  child: AutoSizeText(
                                                    studentNames[index],
                                                    style: TextStyle(
                                                        fontSize: size.width * 0.045),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                  )),
                                              const Text('Score',
                                                  style: TextStyle(
                                                      color:
                                                      Color.fromARGB(255, 10, 52, 84),
                                                      fontWeight: FontWeight.w500)),
                                            ])),
                                      ],
                                    ),
                                  ),
                                );
                              },

                            ))
                      ])
                      :
                  SizedBox(
                    child: AutoSizeText(
                      "Data is Retrieving Please Wait",
                      style: GoogleFonts.poppins(
                          fontSize: size.height*0.035,
                          color: Colors.white70
                      ),
                    ),
                  );
                },
              ),*/
            ],
          )
              :
              const loading(text: "Please Wait Data is Loading")
        ));
  }

 void fetchtData()
  {
    FirebaseFirestore.instance.collection("Notes").doc("${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter").get().then((value) {
      snapshot=value;
    }).whenComplete(() {
      print(".........................//////${snapshot.data()}");
      calculateResult().whenComplete(() {
        setState(() {
          load=true;
        });
      });
    });

  }
  Future<bool> calculateResult( )
  async {
    result.clear();
   for(var email in  snapshot.data()?["Notes-${widget.quizId}"]["Submitted by"])
     {
       Map<String,dynamic>data={};
       data["Name-Rollnumber"]="${email.toString().split("-")[1]}-${email.toString().split("-")[2]}";
       data["Score"]=snapshot.data()?["Notes-${widget.quizId}"]["Response"][email]["Score"];
       data["Quiz-Time"]=snapshot.data()?["Notes-${widget.quizId}"]["Response"][email]["TimeStamp"];
       result.add(data);
     }

   // Sort the map based on timeStamp and Quiz Sore....
    print("....................Before${result}");
    result.sort((a, b) {
      if(a["Score"]==b["Score"])
        {
          return a["Quiz-Time"].compareTo(b["Quiz-Time"]);
        }
      else{
        return a["Score"].compareTo(b["Score"]);
      }
    },);
    int s=0;
    int e=result.length-1;
    while(s<e)
      {
        var temp =result[s];
        result[s]=result[e];
        result[e]=temp;
        s++;
        e--;
      }
      load=true;
   print("....................After${result}");
   return true;
  }
}
