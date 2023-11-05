import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constraints.dart';
import 'loadingscreen.dart';

class responseScreen extends StatefulWidget {
   responseScreen({super.key,required this.quizId});
  int quizId;
  @override
  State<responseScreen> createState() => _responseScreenState();
}

class _responseScreenState extends State<responseScreen> {
  var count=1;
  List<dynamic> options = [];
  late DocumentSnapshot<Map<String, dynamic>> snapshot;
  late DocumentSnapshot<Map<String, dynamic>> responseSnapshot;
  PageController pageQuestionController = PageController();
  List<String> optionResponse=[];
  Map<String, int> occurance={};
  List<String>optionAlphabet=["A","B","C","D"];
  int weekNumber=0;
  Map<String,List<String>>nameRollNumber={};
  List<bool>showDetails=[];
  bool loaded=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchResponse();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(17, 22, 44, 1),
        ),
        child:

        subject_filter != ""
            ?
        loaded
            ?
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: false,
          appBar: AppBar(
            titleSpacing: 0,
            leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white70,)),
            title: AutoSizeText('Quiz Response',
              style: GoogleFonts.poppins(
                  fontSize: size.width*0.055,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600
              ),),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:size.height*0.02),

              SizedBox(
                height: size.height*0.85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.width*0.03),
                      child: Row(
                        children: [
                          Text('Question ',style: TextStyle(fontSize:size.width*0.1,fontWeight:FontWeight.w600,color: Colors.white70),),
                          Text('$count',style: TextStyle(fontSize:size.width*0.1,fontWeight:FontWeight.w600,color: Colors.red),),
                          Text('/${snapshot.data()?["Notes-${widget.quizId}"]["Total_Question"]}',style: TextStyle(fontSize:size.width*0.07,fontWeight:FontWeight.w600,color: Colors.green),),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height*0.02,),
                    SizedBox(
                      height: size.height*0.005,
                      width: size.width*0.90,
                      child: ListView.builder(
                        scrollDirection:Axis.horizontal ,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data()?["Notes-${widget.quizId}"]["Total_Question"] ,
                        itemBuilder:(context, index,) {
                          return Padding(
                            padding: EdgeInsets.all(size.width*0.005),
                            child: SizedBox(
                              width: (size.width*0.9-(size.width*0.01*(snapshot.data()?["Notes-${widget.quizId}"]["Total_Question"]-1)))/snapshot.data()?["Notes-${widget.quizId}"]["Total_Question"],

                              child: Divider(
                                color: (index+1)<count? Colors.green:(index+1)==count?Colors.red:Colors.white70,
                                thickness: size.height*0.005,
                                height: size.height*0.005,


                              ),
                            ),
                          );
                        },),
                    ),
                    SizedBox(
                      height:size.height*0.75,
                      child: PageView.builder(
                        controller: pageQuestionController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data()?["Notes-${widget.quizId}"]["Total_Question"],
                        itemBuilder: (context, index1) {
                          options= List.generate(snapshot.data()?["Notes-${widget.quizId}"]["Question-${index1+1}"]["Options"].length, (index2) => snapshot.data()?["Notes-${widget.quizId}"]["Question-${index1+1}"]["Options"][index2]);
                          return  Padding(
                            padding:  EdgeInsets.all(size.width*0.04),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: size.width*1,
                                  child: AutoSizeText(
                                    "${index1+1}.\t ${snapshot.data()?["Notes-${widget.quizId}"]["Question-${index1+1}"]["Question"]}",
                                    style: GoogleFonts.poppins(
                                      fontSize: size.width*0.06,
                                      color: Colors.white70,
                                    ),
                                  ),),
                                SizedBox(
                                  height: size.height*0.03,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: options.length,
                                    itemBuilder:(context, index) {
                                     // print("dfhdsfhd dfshs dfh ///////////${occurance[options[index]]}");
                                      showDetails.clear();
                                        showDetails=[false,false,false,false];
                                      return Padding(
                                        padding:  EdgeInsets.symmetric(vertical: size.height*0.008,horizontal: size.width*0.04),
                                        child: Container(
                                          width: size.width*0.95,
                                          decoration: BoxDecoration(

                                            borderRadius: BorderRadius.circular(size.width*0.02),
                                            border: Border.all(
                                              color: snapshot.data()?["Notes-${widget.quizId}"]["Question-${index1+1}"]["Answer"]==optionAlphabet[index]?Colors.green:Colors.red,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(size.width*0.05),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: size.width*0.64,
                                                      child: AutoSizeText(
                                                        options[index],style: GoogleFonts.poppins(
                                                        color: Colors.white70,
                                                      ),

                                                      ),
                                                    ),
                                                    AutoSizeText(
                                                      "${occurance[optionAlphabet[index]]==null ? 0 : occurance[optionAlphabet[index]]!} / ${snapshot.data()?["Notes-${widget.quizId}"]["Submitted by"].length}",style: GoogleFonts.poppins(
                                                      color: Colors.white70,
                                                    ),

                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: size.height*0.01,),
                                                LinearProgressIndicator(
                                                  minHeight: size.height*0.01,
                                                  backgroundColor: Colors.black,
                                                  color: Colors.green,
                                                  value: occurance[optionAlphabet[index]]==null? 0 : occurance[optionAlphabet[index]]!/snapshot.data()?["Notes-${widget.quizId}"]["Submitted by"].length,
                                                  //borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                ),
                                                SizedBox(height: size.height*0.012,),
                                                SizedBox(
                                                  height: size.height*0.018,
                                                  child:Center(
                                                    child: InkWell(
                                                      onTap: () {
                                                       if( nameRollNumber[optionAlphabet[index]]!=null && nameRollNumber[optionAlphabet[index]]!.length>0)
                                                         {
                                                           showDialog(
                                                             context: context,
                                                             builder: (context) {
                                                               return Center(
                                                                   child:Container(
                                                                     height: size.height*0.5,
                                                                     width: size.width*0.85,
                                                                     decoration: BoxDecoration(
                                                                         borderRadius: BorderRadius.all(Radius.circular(size.height*0.02)),
                                                                         border: Border.all(
                                                                           color: Colors.white,
                                                                           width: 2,
                                                                         ),
                                                                         gradient: const LinearGradient(
                                                                             colors: [
                                                                               Colors.black,
                                                                               Colors.black54,
                                                                               Colors.black
                                                                             ]
                                                                         )
                                                                     ),
                                                                     child: SingleChildScrollView(
                                                                       scrollDirection: Axis.vertical,
                                                                       child: Column(
                                                                         children: [
                                                                           SizedBox(
                                                                             height: size.height*0.5,
                                                                             width: size.width*0.72,
                                                                             child: ListView.builder(
                                                                               itemCount: nameRollNumber[optionAlphabet[index]]==null?0:nameRollNumber[optionAlphabet[index]]?.length,
                                                                               itemBuilder: (context, index2) {
                                                                                 return Padding(
                                                                                   padding: const EdgeInsets.all(8.0),
                                                                                   child: Container(
                                                                                     height: size.height*0.083,
                                                                                     width: size.width*0.93,
                                                                                     decoration: BoxDecoration(
                                                                                         borderRadius: BorderRadius.all(Radius.circular(size.width*0.05),
                                                                                         ),
                                                                                         border: Border.all(
                                                                                             color: Colors.white
                                                                                         )
                                                                                     ),
                                                                                     child: Column(
                                                                                       mainAxisAlignment: MainAxisAlignment.start,
                                                                                       crossAxisAlignment: CrossAxisAlignment.center,
                                                                                       children: [
                                                                                         SizedBox(
                                                                                           height: size.height*0.012,
                                                                                         ),
                                                                                         AutoSizeText(
                                                                                           nameRollNumber[optionAlphabet[index]]!=null
                                                                                               ?
                                                                                           nameRollNumber[optionAlphabet[index]]![index2].toString().split("-")[0]
                                                                                               :
                                                                                           "No data Found",
                                                                                           style: GoogleFonts.poppins(
                                                                                               fontSize: size.height*0.022,
                                                                                               color: Colors.white70
                                                                                           ),
                                                                                         ),
                                                                                         AutoSizeText(
                                                                                           nameRollNumber[optionAlphabet[index]]!=null
                                                                                               ?
                                                                                           nameRollNumber[optionAlphabet[index]]![index2].toString().split("-")[1]
                                                                                               :
                                                                                           "",
                                                                                           style: GoogleFonts.poppins(
                                                                                               fontSize: size.height*0.022,
                                                                                               color: Colors.white70
                                                                                           ),
                                                                                         ),
                                                                                       ],
                                                                                     ),
                                                                                   ),
                                                                                 );
                                                                               },),
                                                                           )
                                                                         ],
                                                                       ),
                                                                     ),
                                                                   )
                                                               );
                                                             },
                                                           );
                                                         }

                                                      },
                                                      child: AutoSizeText(
                                                        "Show Details",
                                                        style: GoogleFonts.poppins(
                                                            fontSize: size.height*0.015,
                                                            color: Colors.blue
                                                        ),
                                                      ),
                                                    ),
                                                  ) ,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );

                                    },),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.04),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        count> 1?count--:null;
                        calculateResponse(count);
                        pageQuestionController.animateToPage(count-1, duration: const Duration(milliseconds: 100), curve: Curves.linear);
                      });

                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(size.width*0.01,size.height*0.045),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                    child:Row(
                      children: [
                        const Icon(Icons.arrow_back),
                        SizedBox(width: size.width*0.02,),
                        Text("Previous",style: GoogleFonts.exo(fontSize: size.width*0.06,color: Colors.white),),
                      ],
                    ),


                  ),
                  count== snapshot.data()?["Notes-${widget.quizId}"]["Total_Question"]
                      ?
                  Container(
                    height: size.height*0.04,
                    width: size.width*0.35,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue, Colors.purpleAccent],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child:Text("Close",style: GoogleFonts.exo(fontSize: size.width*0.06,color: Colors.black),),


                    ),
                  )
                      :
                  Container(
                    height: size.height*0.04,
                    width: size.width*0.3,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue, Colors.purpleAccent],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          loaded=false;
                          count< snapshot.data()?["Notes-${widget.quizId}"]["Total_Question"]?count++:null;
                          calculateResponse(count);
                          pageQuestionController.animateToPage(count-1, duration: const Duration(milliseconds: 100), curve: Curves.linear);
                        });

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child:Text("Next",style: GoogleFonts.exo(fontSize: size.width*0.06,color: Colors.black),),


                    ),
                  ),
                ]
            ),
          ),
        )
            :
        const loading(text: "Loading Question please wait....")
            :
        const loading(text: "Please apply filter first....")
    );
  }
  fetchResponse() async {

    await FirebaseFirestore.instance.collection("Notes").doc("${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter").get().then((value) =>
      snapshot =value
    ).whenComplete(() {
      calculateResponse(1);
      setState(() {
        loaded=true;
      });
    });
  }



  calculateResponse(int questionno){
    optionResponse.clear();
    occurance.clear();
    nameRollNumber.clear();
    print("........mmmmmmmmmm${snapshot.data()?["Notes-${widget.quizId}"]["Submitted by"]}");
    for(var i in snapshot.data()?["Notes-${widget.quizId}"]["Submitted by"]){
       var question=snapshot.data()?["Notes-${widget.quizId}"]["Question-$questionno"]["Question"];
       if(snapshot.data()?["Notes-${widget.quizId}"]["Response"][i][question]!=null)
         {

           occurance[snapshot.data()?["Notes-${widget.quizId}"]["Response"][i][question]] = occurance[snapshot.data()?["Notes-${widget.quizId}"]["Response"][i][question]]==null ? 1 : occurance[snapshot.data()?["Notes-${widget.quizId}"]["Response"][i][question]]!+1;
           nameRollNumber[snapshot.data()?["Notes-${widget.quizId}"]["Response"][i][question]]=nameRollNumber[snapshot.data()?["Notes-${widget.quizId}"]["Response"][i][question]]==null ? ["${(i.toString().split("-")[1])}-${i.toString().split("-")[2]}"] :nameRollNumber[snapshot.data()?["Notes-${widget.quizId}"]["Response"][i][question]]!+["${(i.toString().split("-")[1])}-${i.toString().split("-")[2]}"] ;
         }

    }


    setState(() {
      loaded=true;
    });
  }
}
