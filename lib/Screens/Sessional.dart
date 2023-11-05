import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchfield/searchfield.dart';

import '../Constraints.dart';

class Sessional extends StatefulWidget {
  const Sessional({Key? key}) : super(key: key);

  @override
  State<Sessional> createState() => _SessionalState();
}

class _SessionalState extends State<Sessional> {

  int  _height = 0;
  int flage =0;

  final _st=GoogleFonts.exo(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black
  );

  List<TextEditingController>marks_controller=[];
  TextEditingController sessionalController=TextEditingController();

  final List<String>_sessional=["Sessional-1","Sessional-2","Sessional-3"];
  TextEditingController max_marks_controller= TextEditingController();
  var sessinal_number;

  List<String>all_email=["abc@gmail.com"];

  List<double>height_list=[0.11,0.11,0.11];

 @override
  void initState() {
    // TODO: implement initState
   fetch_all_email();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return subject_filter.isEmpty
        ?
        Center(
          child: AutoSizeText(
            "Please Apply Filter",
            style: _st,
          ),
        )
        :
        upload_marks
            ?
      Scaffold(
        primary: false,
      backgroundColor: Colors.transparent,
      body: all_email.length>1
        ?
          SingleChildScrollView(
            primary: false,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: size.height*0.06,
                    width: size.width*0.52,
                   decoration: BoxDecoration(
                     gradient: LinearGradient(
                       begin: Alignment.topLeft,
                       end: Alignment.bottomRight,
                       colors: [Colors.blue, Colors.purpleAccent.shade100],
                     ),
                     borderRadius: const BorderRadius.all(Radius.circular(15),),
                   ),
                    child: SearchField(

                      controller: sessionalController,
                      suggestionItemDecoration: SuggestionDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue, Colors.purpleAccent.shade100],
                        ),
                      ),
                      key: const Key("Search key"),
                      suggestions:
                      _sessional.map((e) => SearchFieldListItem(e)).toList(),
                      searchStyle: _st,
                      suggestionStyle: _st,
                      marginColor: Colors.black,

                      suggestionsDecoration: SuggestionDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue, Colors.purpleAccent],
                          ),
                          //shape: BoxShape.rectangle,
                          padding: const EdgeInsets.all(10),
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(0)),
                      searchInputDecoration: InputDecoration(
                          hintText: "Select Sessional",
                          contentPadding: EdgeInsets.only(left: size.width*0.08),
                          fillColor:Colors.transparent,


                          filled: true,
                          hintStyle: _st,
                          suffixIcon: Icon(Icons.arrow_drop_down,color: Colors.black,size: size.height*0.04,),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 3,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusColor: Colors.transparent,
                          disabledBorder: OutlineInputBorder(
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
                          )),
                      onSuggestionTap: (value) {
                        FocusScope.of(context).unfocus();

                        setState(() {
                           sessinal_number=sessionalController.text.toString().trim().split("-")[1];
                        });


                      },
                      enabled: true,
                      hint: "Select Sessinal",
                      itemHeight: 50,
                      maxSuggestionsInViewPort: 3,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: size.width*0.35,
                    height: size.height*0.06,

                    decoration:  BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue, Colors.purpleAccent.shade100],
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                            color: Colors.black,
                            width: 3
                        )
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: max_marks_controller,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Max Marks",

                        hintStyle: _st,
                        contentPadding: EdgeInsets.only(left: size.width*0.02),
                        helperStyle: _st,
                      ),
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      style: _st,
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream:  FirebaseFirestore.instance
                  .collection("Students")
                  .where("University", isEqualTo: university_filter)
                  .where("College", isEqualTo: college_filter)
                  .where("Course", isEqualTo: course_filter)
                  .where("Branch", isEqualTo: branch_filter)
                  .where("Year", isEqualTo: year_filter)
                  .where("Section", isEqualTo: section_filter)
                  .where("Subject", arrayContains: subject_filter)
                  .where("Email",whereIn: all_email)
                  .where("Name",isNull: false)
                  .orderBy("Name")
                  .snapshots(),
              builder: (context, snapshot) {
               print(snapshot.hasData);
               return snapshot.hasData?
                 SizedBox(
                   height: size.height*1,
                   width: size.width,
                   child: ListView.builder(
                     itemCount: snapshot.data?.docs.length,
                     itemBuilder: (context, index) {
                          if(marks_controller.isEmpty)
                            {
                         for (int i = 0; i < snapshot.data!.docs.length; i++) {
                           marks_controller.add(TextEditingController());
                         }
                       }
                     return Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Container(
                         height: size.height*0.29,
                         width: size.width*0.85,
                         decoration:  BoxDecoration(
                             gradient: const LinearGradient(
                               colors: [
                                 Color.fromRGBO(200, 62, 118, 1),
                                 Color.fromRGBO(70, 50, 110, 1),
                               ],
                             ),
                           borderRadius: const BorderRadius.all(Radius.circular(30)),
                             border: Border.all(
                                 color: Colors.black,
                                 width: 3
                             )
                         ),
                         child: Center(
                           child: Padding(
                             padding:  EdgeInsets.all(size.height*0.03),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Row(
                                   children: [
                                     AutoSizeText(
                                       "Name :    ",
                                       style:_st,
                                     ),
                                     AutoSizeText(
                                       snapshot.data?.docs[index]["Name"],
                                       style: _st,
                                     )
                                   ],
                                 ),
                                 SizedBox(
                                   height: size.height*0.01,
                                 ),
                                 Row(
                                   children: [
                                     AutoSizeText(
                                       "Roll Number   :    ",
                                       style:_st,
                                     ),
                                     AutoSizeText(
                                       snapshot.data?.docs[index]["Rollnumber"],
                                       style: _st,
                                     )
                                   ],
                                 ),
                                 SizedBox(
                                   height: size.height*0.01,
                                 ),
                                 Row(
                                   children: [
                                     AutoSizeText(
                                       "Subject   :    ",
                                       style:_st,
                                     ),
                                     AutoSizeText(
                                       subject_filter,
                                       style: _st,
                                       maxLines: 1,
                                     )
                                   ],
                                 ),
                                 SizedBox(
                                   height: size.height*0.017,
                                 ),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     AutoSizeText(
                                       "Marks   :    ",
                                       style:_st,
                                     ),
                                    Container(
                                        height: size.height*0.048,
                                        width: size.width*0.16,
                                        decoration:  BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2
                                          )
                                        ),
                                       child: Center(
                                         child: TextField(
                                           controller: marks_controller[index],
                                           textAlign: TextAlign.center,
                                           decoration: InputDecoration(
                                             hintText: "0",
                                             contentPadding: EdgeInsets.only(left: size.height*0.01,bottom: size.height*0.014),
                                             helperStyle: _st,
                                           ),
                                           maxLines: 1,
                                           keyboardType: TextInputType.number,
                                          style: _st,
                                         ),
                                       ),
                                    ),
                                     InkWell(
                                       onTap: () async {
                                         setState(() {
                                           //print("Digit is$sessinal_number");
                                           //print("Max marks is${max_marks_controller.text}");
                                           marks_controller.add(TextEditingController());
                                         });

                                         if(max_marks_controller.text.isNotEmpty && sessionalController.text.isNotEmpty)
                                           {
                                            await FirebaseFirestore.instance.collection("Students").
                                            doc(snapshot.data?.docs[index]["Email"]).update({
                                               "S-$sessinal_number-$subject_filter":marks_controller[index].text.trim(),
                                             }).then((value) async {
                                              setState(() {
                                                marks_controller.removeAt(index);
                                                all_email.remove(snapshot.data?.docs[index]["Email"]);
                                              });
                                              await FirebaseFirestore.
                                              instance.collection("Students")
                                                  .doc(snapshot.data?.docs[index]["Email"]).update({
                                                 "S-$sessinal_number-max_marks":max_marks_controller.text,
                                               });
                                             }
                                             ).onError((error, stackTrace) {
                                             });
                                           }
                                         else{
                                         }
                                       },
                                       child: Container(
                                           height: size.height*0.05,
                                           width: size.width*.23,
                                           decoration:  BoxDecoration(
                                               color: Colors.transparent,
                                               borderRadius: const BorderRadius.all(Radius.circular(15)),
                                               border: Border.all(
                                                   color: Colors.black,
                                                   width: 2
                                               )
                                           ),
                                        child: Center(
                                          child: AutoSizeText("Submit",
                                            style: _st,
                                            maxLines: 1,),
                                        ),
                                       ),
                                     ),
                                     IconButton(onPressed: (){
                                       setState(() {
                                         //marks_controller.removeAt(index);
                                         all_email.remove(snapshot.data?.docs[index]["Email"]);
                                       });
                                     },
                                         icon: Icon(Icons.delete,color: Colors.black,size: size.height*0.045,))

                                   ],
                                 ),

                               ],
                             ),
                           ),
                         ),
                       ),
                     );
                   },),
                 )
                  :
              const Center(child: CircularProgressIndicator(
                color: Colors.black,
                backgroundColor: Colors.transparent,
              ));

            },)
          ],
        ),
      )
          :
           Center(child: AutoSizeText(
            "Marks uploaded",
             style: _st,
          ))
    )
            :
        Scaffold(
          backgroundColor: Colors.transparent,
          body: StreamBuilder(
            stream:FirebaseFirestore.instance
                .collection("Students")
                .where("University", isEqualTo: university_filter)
                .where("College", isEqualTo: college_filter)
                .where("Course", isEqualTo: course_filter)
                .where("Branch", isEqualTo: branch_filter)
                .where("Year", isEqualTo: year_filter)
                .where("Section", isEqualTo: section_filter)
                .where("Subject", arrayContains: subject_filter)
                .where("Name",isNull: false)
                .orderBy("Name")
                .snapshots() ,
            builder: (context, snapshot) {
            return  snapshot.hasData
                ?
              ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data?.size,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(size.height*0.007),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if(height_list[index]==0.11) {
                          height_list[index] = 0.28;
                        }
                        else{
                          height_list[index]=0.11;
                        }
                    });
                          },
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: size.height*height_list[index],
                        decoration:  const BoxDecoration(

                          borderRadius: BorderRadius.all(Radius.circular(20),),
                          color: Colors.indigo
                        ),
                        child: Card(
                        color: Colors.transparent,
                          elevation: 50,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.height*0.011,
                                ),
                                height_list[index]==0.11
                                ?
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,

                                    children: [
                                      SizedBox(width: size.width*0.023,),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: size.height*0.033,
                                        // backgroundColor: Colors.teal.shade300,
                                        child: AutoSizeText(
                                          snapshot.data!.docs[index]["Name"].toString().trim().substring(0,1),
                                          style: GoogleFonts.exo(
                                              fontSize: size.height * 0.05,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: size.width*0.023,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            snapshot.data?.docs[index]["Name"],
                                            style: GoogleFonts.exo(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          AutoSizeText(
                                            snapshot.data?.docs[index]["Rollnumber"],
                                            style: GoogleFonts.exo(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      )
                                    ],
                                )
                                    :
                                    Column(
                                      children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.start,


                                            children: [
                                              SizedBox(width: size.width*0.023,),
                                              CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 30,
                                                  // backgroundColor: Colors.teal.shade300,
                                                  child:  AutoSizeText(
                                                    snapshot.data!.docs[index]["Name"].toString().trim().substring(0,1),
                                                    style: GoogleFonts.exo(
                                                        fontSize: size.height * 0.05,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black
                                                    ),
                                                  )
                                              ),
                                              SizedBox(width: size.width*0.023,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  AutoSizeText(
                                                    snapshot.data?.docs[index]["Name"],
                                                    style: GoogleFonts.exo(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                  AutoSizeText(
                                                    snapshot.data?.docs[index]["Rollnumber"],
                                                    style: GoogleFonts.exo(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w600),
                                                  )
                                                ],
                                              )
                                            ]),
                                        SizedBox(height: size.height*0.026),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AutoSizeText(
                                              "Subject      ",
                                              style: GoogleFonts.exo(
                                                  fontSize: size.height * 0.03,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                            AutoSizeText(
                                              "S-1  ",
                                              style: GoogleFonts.exo(
                                                  fontSize: size.height * 0.03,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                            AutoSizeText(
                                              "S-2  ",
                                              style: GoogleFonts.exo(
                                                  fontSize: size.height * 0.03,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                              ),
                                            ),
                                            AutoSizeText(
                                              "S-3  ",
                                              style: GoogleFonts.exo(
                                                  fontSize: size.height * 0.03,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height*0.02,),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              height: size.height*0.05,
                                              width: size.width*0.3,
                                              child: Center(
                                                child: AutoSizeText(
                                                  subject_filter,
                                                  style: GoogleFonts.exo(
                                                      fontSize: size.height * 0.03,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black),
                                                  borderRadius: BorderRadius.circular(5)

                                              ),
                                              height: size.height*0.04,
                                              width: size.width*0.12,
                                              child: Center(
                                                child: AutoSizeText(
                                                  snapshot.data?.docs[index]["S-1-$subject_filter"],
                                                  style: GoogleFonts.exo(
                                                      fontSize: size.height * 0.03,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black),
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              height: size.height*0.04,
                                              width: size.width*0.12,
                                              child: Center(
                                                child: AutoSizeText(
                                                  "0",
                                                  style: GoogleFonts.exo(
                                                      fontSize: size.height * 0.03,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black),
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              height: size.height*0.04,
                                              width: size.width*0.12,
                                              child: Center(
                                                child: AutoSizeText(
                                                  "0",
                                                  style: GoogleFonts.exo(
                                                      fontSize: size.height * 0.03,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    )

                              ],
                            ),
                          )
                        )
                    ),
                  ),
                );
              },
            )
                :
            Center(
              child: AutoSizeText(
                "Please Apply Filter",
                style: _st,
              ),
            );
          },)
        );
  }
  Future<void> fetch_all_email() async {
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('Students');

    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    for(var i in querySnapshot.docs)
    {
      setState(() {
        all_email.add(i["Email"]);

      });
    }
print(all_email);


  }
}
