
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _Notes();
}

class _Notes extends State<Notes> {
  int ind=0;
  bool a=true;
  bool isExpanded = false;
  bool ispdfExpanded=false;

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    List<String> Subject = ['DBMS','ML','DAA'];

    BorderRadiusGeometry radiusGeomentry=BorderRadius.circular(21);
    // void toggleContainer() {
    //   setState(() {
    //     isExpanded = !isExpanded;
    //   });
    // }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height*0.03,

        title: Center(child: Text('Notes',style: GoogleFonts.exo(fontSize:size.width*0.04,color: Colors.yellow),)),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        color: Colors.transparent,
        child: Column(

          children: [
            Container(
              height: size.height*0.175,


              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection:Axis.horizontal ,
                  itemBuilder: (context,index){
                return Padding(
                  padding:  EdgeInsets.all(size.height*0.02),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        ind=index;
                      });

                    },
                    child: Column(
                      children: [
                        Container(
                            decoration:BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ind==index?Colors.blue:Colors.green,
                                width: size.width*0.009
                              ),
                            ),
                          child: CircleAvatar(
                            child: AutoSizeText(Subject[index].substring(0,1),style: GoogleFonts.exo(fontSize:size.height*0.05,color:Colors.black),),
                            backgroundColor:Colors.black54,
                            radius: size.width*0.09,
                          ),
                        ),
                        AutoSizeText(Subject[index],textAlign:TextAlign.center,style: GoogleFonts.exo(fontSize:size.height*0.03,color:Colors.black, ),),
                      ],
                    ),
                  ),
                );

            },
            itemCount:Subject.length
              ),
            ),
            Divider(
              indent: 10,
              endIndent: 10,
              color: Colors.black54,
              thickness: size.height*0.007,
              height: size.height*0.005,

            ),
            SizedBox(height: size.height*0.01,),
            Container(
              width: size.width*0.98,
              decoration: BoxDecoration(
                color:Colors.blue,
                borderRadius: radiusGeomentry,
              ),
              child: Column(

                children: [
                  SizedBox(
                    height: size.height*0.25,
                    width: size.width*0.98,
                    child: Padding(
                      padding:  EdgeInsets.only(top:size.height*0.01,left:size.height*0.01,right:size.height*0.01),
                      child: ClipRRect(

                          borderRadius:BorderRadius.only(topLeft: Radius.circular(size.width*0.05),topRight: Radius.circular(size.width*0.05)),
                          child: Image.asset("assets/images/pdf.png",fit: BoxFit.cover,)),
                    ),
                  ),
                  AnimatedContainer(
                    height: isExpanded ? size.height*0.3 :size.height*0.15,
                    width:size.width*0.98,
                    duration: Duration(milliseconds: 1),
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: radiusGeomentry

                    ),
                    child: Column(
                      children: [
                        ListTile(
                          shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(bottomLeft: Radius.circular(size.width*0.12),bottomRight: Radius.circular(size.width*0.12)),),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(Subject[ind],style: GoogleFonts.exo(fontSize: size.height*0.038,color: Colors.black,fontWeight: FontWeight.w500),),
                                FloatingActionButton(
                                    onPressed: () {
                                   setState(() {
                                     ispdfExpanded=!ispdfExpanded;
                                   });
                                    },
                                    child:ispdfExpanded?Image.asset("assests/images/download-button.png",height: size.height*0.03,):Image.asset("assests/images/pdf.png",height: size.height*0.03,),

                                    )
                            ],
                          ),

                          subtitle: AutoSizeText('DEADLIiNE',style: GoogleFonts.exo(fontSize: size.height*0.015,color: Colors.black,fontWeight: FontWeight.w400),),
                          trailing:  FloatingActionButton(
                            onPressed: (){

                              setState(() {
                                isExpanded = !isExpanded;

                              });

                            },
                            child:Image.asset("assests/images/speech-bubble.png",height: size.height*0.05,),
                          ),

                        ),
                       isExpanded? Padding(
                         padding: EdgeInsets.only(top: size.height*0.048),
                         child: Container(
                            width: size.width*0.98,
                            child: ListTile(
                              title: AutoSizeText('Take Quiz',style: GoogleFonts.exo(fontSize: size.height*0.038,color: Colors.black,fontWeight: FontWeight.w500),),
                              subtitle: AutoSizeText('Details goes here',style: GoogleFonts.exo(fontSize: size.height*0.015,color: Colors.black,fontWeight: FontWeight.w400),),
                              trailing: FloatingActionButton(
                                child:Image.asset("assests/images/brain.png",height: size.height*0.05,),
                                onPressed: (){
                                  setState(() {

                                  });
                                },
                              ),
                            ),
                          ),
                       ):SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),


          ],

        ),
      ) ,

    );
  }

}


















