import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constraints.dart';
import 'loadingscreen.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key,});
  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  var count=1;
  List<dynamic> options = [];
  late DocumentSnapshot<Map<String, dynamic>> snapshot;
  late DocumentSnapshot<Map<String, dynamic>> responseSnapshot;
  PageController pageQuestionController = PageController();
  List<String> optionResponse=[];
  Map<String, int> occurance={};
  int weekNumber=0;

  bool loaded=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final now = DateTime.now();
    final firstJan = DateTime(now.year, now.month, 1);
    weekNumber = weeksBetween( firstJan,now);
    fetchFeedback();
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
            title: AutoSizeText('Feedback',
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
                          Text('/${snapshot.data()!["Feedback Questions"].length}',style: TextStyle(fontSize:size.width*0.07,fontWeight:FontWeight.w600,color: Colors.green),),
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
                        itemCount: snapshot.data()!["Feedback Questions"].length ,
                        itemBuilder:(context, index,) {
                          return Padding(
                            padding: EdgeInsets.all(size.width*0.005),
                            child: SizedBox(
                              width: (size.width*0.9-(size.width*0.01*(snapshot.data()!["Feedback Questions"].length-1)))/snapshot.data()!["Feedback Questions"].length,

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
                      height: size.height*0.75,
                      child: PageView.builder(
                        controller: pageQuestionController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data()?["Feedback Questions"].length,
                        itemBuilder: (context, index1) {
                          options.clear();

                          options= List.generate(snapshot.data()?["Feedback Questions"][index1]['Options'].length, (index2) => snapshot.data()?["Feedback Questions"][index1]['Options'][index2]);
                          return  Padding(
                            padding:  EdgeInsets.all(size.width*0.04),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: size.width*1,
                                  child: AutoSizeText(
                                    "${index1+1}.\t ${snapshot.data()!["Feedback Questions"][index1]['Question']}",
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
                                    itemCount: snapshot.data()?["Feedback Questions"][index1]['Options'].length,
                                    itemBuilder:(context, index) {
                                      print("dfhdsfhd dfshs dfh ///////////${occurance[options[index]]}");
                                      return Padding(
                                        padding:  EdgeInsets.symmetric(vertical: size.height*0.008,horizontal: size.width*0.04),
                                        child: Container(
                                          width: size.width*0.95,
                                          decoration: BoxDecoration(

                                            borderRadius: BorderRadius.circular(size.width*0.02),
                                            border: Border.all(
                                              color: Colors.white70,
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
                                                      "${occurance[options[index]]==null ? 0 : occurance[options[index]]!} / ${optionResponse.length}",style: GoogleFonts.poppins(
                                                      color: Colors.white70,
                                                    ),

                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: size.height*0.01,),
                                                LinearProgressIndicator(
                                                  minHeight: size.height*0.015,
                                                  backgroundColor: Colors.black,
                                                  color: Colors.green,
                                                  value: occurance[options[index]]==null ? 0 : occurance[options[index]]!/optionResponse.length,
                                                  //borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                  count== snapshot.data()!["Feedback Questions"].length
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
                            count< snapshot.data()!["Feedback Questions"].length?count++:null;
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
  fetchFeedback() async {

    await FirebaseFirestore.instance.collection("Feedback").doc("Feedback").get().then((value) =>
    snapshot =value
    ).whenComplete((){
      fetchResponse();
    });

  }
  int weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil();
  }
  fetchResponse() async {

    await FirebaseFirestore
        .instance
        .collection("Teachers Feedback")
        .doc(usermodel['Email'])
        .collection(
      "${university_filter.toString().split(" ")[0]} ${college_filter.toString().split(" ")[0]} ${course_filter.toString().split(" ")[0]} ${branch_filter.toString().split(" ")[0]} ${year_filter.toString().split(" ")[0]} ${section_filter.toString().split(" ")[0]} ${subject_filter.toString().split(" ")[0]}"
    )
        .doc("${DateTime.now().month}-$weekNumber").get().then((value) {
          responseSnapshot=value;
    }).whenComplete((){
      calculateResponse(count);

    });
  }

 calculateResponse(int questionno){
   optionResponse.clear();
    for(int i=0; i< responseSnapshot.data()?["Feedback"].length;i++){
      optionResponse.add(responseSnapshot.data()!["Feedback"][i]['Question $questionno']);
    }
   print("isduhg inusghi hadsgh sdlgn${optionResponse}");
    occurance.clear();
    for(int i=0; i < optionResponse.length;i++){
      occurance[optionResponse[i]] = occurance[optionResponse[i]]==null ? 1 : occurance[optionResponse[i]]! + 1;
    }
    setState(() {
      loaded=true;
    });
  }
}
