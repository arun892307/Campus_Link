import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import '../../Constraints.dart';
import '../../Database/database.dart';
import '../loadingscreen.dart';
import 'Group_decription.dart';
import 'Media_File.dart';



class Chat_Info extends StatefulWidget {
  const Chat_Info({super.key, required this.channel, required this.membersCount, required this.url, required this.muted});
  final String channel;
  final int membersCount;
  final String url;
  final bool muted;
  @override
  State<Chat_Info> createState() => _Chat_InfoState();
}


class _Chat_InfoState extends State<Chat_Info> {
   late bool _switched;
   Color color1=Colors.black;
   Color headingColor=Colors.black;
   Color normalColor=Colors.black;
   Color adminColor=Colors.green;
   ScrollController scrollController = ScrollController();
   int showMembers=1;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _switched=!widget.muted;
    });
  }
  @override
  Widget build(BuildContext context) {

    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new,color: color1)
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(size.width*0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width,
                height: size.height*0.3,
                child:  Column(
                  children: [

                    SizedBox(
                      height: size.height*0.01,
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: size.height*0.08,
                          backgroundColor: headingColor,
                          backgroundImage: widget.url != "null" ? NetworkImage(widget.url) : null,
                          child: widget.url=="null" ?
                          Icon(Icons.group,color: headingColor ,size: size.height*0.1,) : null
                      ),
                        Positioned(
                          bottom: -5,
                          right: size.height*0.01,
                          child: IconButton(
                            icon: Icon(Icons.camera_enhance,size:size.height*0.04 ,color: color1,),
                            onPressed: () async {

                              ImagePicker imagePicker=ImagePicker();
                              print(imagePicker);
                              XFile? file=await imagePicker.pickImage(source: ImageSource.gallery);
                              print(file?.path);

                              // Create reference of Firebase Storage

                              Reference reference=FirebaseStorage.instance.ref();

                              // Create Directory into Firebase Storage

                              Reference image_directory=reference.child("User_profile");


                              Reference image_folder=image_directory.child("${usermodel["Email"]}");

                              await image_folder.putFile(File(file!.path)).whenComplete(() async {
                                String download_url=await image_folder.getDownloadURL();
                                print("uploaded");
                                print(download_url);
                                await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                                  "image_URL":download_url,
                                });
                                setState(() {
                                  database().fetchuser();
                                });
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height*0.04,
                    ),
                    AutoSizeText(
                        widget.channel,
                      style: GoogleFonts.openSans(
                        color: headingColor,
                        fontSize: size.height*0.025,
                        fontWeight:FontWeight.w600
                      ),


                        ),
                    SizedBox(
                      height: size.height*0.005,
                    ),
                    AutoSizeText(
                      "Group : ${widget.membersCount} Participants",
                      style: GoogleFonts.openSans(
                          color: normalColor,
                          fontSize: size.height*0.02,
                          fontWeight:FontWeight.w600
                      ),


                    ),

                  ],
                ),
              ),
              SizedBox(
                height: size.height*0.005,
              ),

              SizedBox(
                height: size.height*0.3,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                     "About Group",
                     style: GoogleFonts.openSans(
                     color: headingColor,
                   fontSize: size.height*0.024,
                   fontWeight: FontWeight.w600
                   ),

                   ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        border: Border.all(color: Colors.black,width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      padding: EdgeInsets.all(size.height*0.005),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context,
                            PageTransition(
                                child: GroupDescription(channel: widget.channel),
                                type: PageTransitionType.bottomToTopJoined,
                                duration: const Duration(milliseconds: 200),
                                childCurrent: Chat_Info(muted: widget.muted,channel: widget.channel,membersCount: widget.membersCount,url: widget.url,)

                            ),
                          );
                        },
                        child: SizedBox(
                            height: size.height*0.07,
                            width: double.maxFinite,
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection("Messages").doc(widget.channel).snapshots(),
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ?
                                snapshot.data!.data()!["Description"] == null || snapshot.data!.data()!["Description"] == ""
                                    ?
                                AutoSizeText(
                                  "Add group description",
                                  style: GoogleFonts.openSans(
                                      color: Colors.blue.shade700,
                                      fontSize: size.height*0.02,
                                      fontWeight:FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      decorationStyle: TextDecorationStyle.solid,
                                    decorationThickness: 2.5
                                  ),

                                )
                                    :
                                AutoSizeText(
                                  snapshot.data!.data()!["Description"],
                                  style: GoogleFonts.openSans(
                                      color: Colors.white70,
                                      fontSize: size.height*0.018,
                                      fontWeight:FontWeight.w400,
                                  ),

                                )
                                    :
                                const SizedBox();
                              },)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height*0.005,
                    ),
                    SizedBox(
                      height: size.height*0.01,
                    ),
                    Row(
                      children: [
                        AutoSizeText(
                          "Created by ",
                          style:GoogleFonts.openSans(
                            color: headingColor,
                            fontSize: size.height*0.019,
                            fontWeight: FontWeight.w500
                          ) ,
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("Messages").doc(widget.channel).snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ?
                            AutoSizeText(
                              "${snapshot.data!.data()?["CreatedOn"]["Name"]}, ${snapshot.data!.data()?["CreatedOn"]["Date"].toDate().day}/${snapshot.data!.data()?["CreatedOn"]["Date"].toDate().month}/${snapshot.data!.data()?["CreatedOn"]["Date"].toDate().year}",
                              style:GoogleFonts.exo(
                                  color: normalColor,
                                  fontSize: size.height*0.019,
                                  fontWeight: FontWeight.w500
                              ) ,
                            )
                            :
                                const SizedBox();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height*0.022,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _switched?

                      Icon(Icons.notifications,color: headingColor,size: size.height*0.035,)
                            :
                        Icon(Icons.notifications_off,color: headingColor,size: size.height*0.035,),
                        SizedBox(
                          width: size.width*0.03,
                        ),
                        AutoSizeText(
                          "Mute Notifications ",
                          style:GoogleFonts.exo(
                              color: headingColor,
                              fontSize: size.height*0.019,
                              fontWeight: FontWeight.w500
                          ) ,
                        ),
                        SizedBox(
                          width: size.width*0.26,
                        ),
                        SizedBox(
                          child: Switch(
                            value:!_switched ,
                              onChanged: (value) {
                                setState(() {
                                  _switched=!_switched;
                                });

                                    FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                                      "${usermodel["Email"].toString().split("@")[0]}.Mute Notification": value ? true : false,
                                    }).whenComplete(() => print(".................Added........"));


                              },
                            activeColor: Colors.black26,
                           // trackOutlineWidth: const MaterialStatePropertyAll(2),
                            trackOutlineColor: const MaterialStatePropertyAll(Colors.black),
                            activeTrackColor: Colors.greenAccent,


                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height*0.018,
                    ),
                    InkWell(
                        onTap: (){
                      Navigator.push(
                        context,
                        PageTransition(
                            childCurrent:Chat_Info(channel: widget.channel, membersCount: widget.membersCount, url: widget.url,muted: widget.muted),
                            child:Media_files(channel: widget.channel,),
                            type: PageTransitionType
                                .rightToLeftJoined,
                            duration: const Duration(
                                milliseconds: 300)),
                      );
                    },
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.image,color: headingColor,size: size.height*0.035,),
                            SizedBox(
                              width: size.width*0.03,
                            ),
                            AutoSizeText(
                              "Show Media",
                              style: GoogleFonts.exo(
                                  color: headingColor,
                                  fontSize: size.height*0.019,
                                  fontWeight: FontWeight.w500
                              ),

                            ),
                          ],
                        )
                    )
                  ],
                ),
              ),

              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: size.height*0.079*showMembers + size.width*0.15  +size.width*0.043 +size.height*0.015,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height*0.015,
                    ),
                    AutoSizeText(
                      "${widget.membersCount} Participants",
                      style: GoogleFonts.openSans(
                          color: headingColor,
                          fontSize: size.width*0.05,
                          fontWeight:FontWeight.w600
                      ),


                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: size.height*0.079*showMembers + 50,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("Messages").doc(widget.channel).snapshots(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: size.height*0.079*showMembers,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  controller: scrollController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data?.data()!["Members"].length,
                                  itemBuilder: (context, index) {
                                    return StreamBuilder(
                                        stream: FirebaseFirestore.instance.collection(snapshot.data!.data()![snapshot.data?.data()!["Members"][index].toString().split("@")[0]]["Post"]).doc(snapshot.data?.data()!["Members"][index]).snapshots(),
                                        builder: (context, snapshot2) {
                                          return snapshot2.hasData
                                              ?
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: size.height*0.01),
                                            child: InkWell(
                                              onTap: () {
                                                if (snapshot.data!.data()?["Admins"].contains("${usermodel["Email"]}")) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        backgroundColor: Colors.black87,
                                                        title: const Text(
                                                          "Actions",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                        actions: [
                                                          Column(
                                                            children: [
                                                              snapshot.data!.data()?["${snapshot.data?.data()!["Members"][index]["Email"].split("@")[0]}"]
                                                              ["Mute"] !=
                                                                  true
                                                                  ? Container(
                                                                width: size.width * 0.7,
                                                                height: size.height * 0.05,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(14),
                                                                    color: Colors.black,
                                                                    gradient: const LinearGradient(colors: [
                                                                      Colors.deepPurple,
                                                                      Colors.purpleAccent
                                                                    ])),
                                                                child: ElevatedButton(
                                                                    onPressed: () async {
                                                                      await FirebaseFirestore.instance
                                                                          .collection("Messages")
                                                                          .doc(widget.channel)
                                                                          .update({
                                                                        "${snapshot.data?.data()!["Members"][index]["Email"].split("@")[0].split("@")[0]}.Mute": true
                                                                      }).whenComplete(() {
                                                                        Navigator.pop(context);
                                                                      });
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Colors.transparent,
                                                                    ),
                                                                    child: AutoSizeText("Mute ${snapshot2.data?.data()!["Name"]}",textAlign: TextAlign.center),),
                                                              )
                                                                  : Container(
                                                                width: size.width * 0.7,
                                                                height: size.height * 0.05,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(14),
                                                                    color: Colors.black,
                                                                    gradient: const LinearGradient(colors: [
                                                                      Colors.deepPurple,
                                                                      Colors.purpleAccent
                                                                    ])),
                                                                child: ElevatedButton(
                                                                    onPressed: () async {
                                                                      await FirebaseFirestore.instance
                                                                          .collection("Messages")
                                                                          .doc(widget.channel)
                                                                          .update({
                                                                        "${snapshot.data?.data()!["Members"][index]["Email"].split("@")[0].split("@")[0]}.Mute": false
                                                                      }).whenComplete(() {
                                                                        Navigator.pop(context);
                                                                      });
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Colors.transparent,
                                                                    ),
                                                                    child: AutoSizeText("Unmute ${snapshot2.data?.data()!["Name"]}",textAlign: TextAlign.center)),
                                                              ),
                                                              SizedBox(
                                                                height: size.height * 0.01,
                                                              ),
                                                              snapshot.data!.data()?["Admins"].contains(snapshot.data?.data()!["Members"][index]["Email"])
                                                                  ?
                                                              Container(
                                                                width: size.width * 0.7,
                                                                height: size.height * 0.05,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(14),
                                                                    color: Colors.black,
                                                                    gradient: const LinearGradient(colors: [
                                                                      Colors.deepPurple,
                                                                      Colors.purpleAccent
                                                                    ])),
                                                                child: ElevatedButton(
                                                                    onPressed: () async {
                                                                      await FirebaseFirestore.instance
                                                                          .collection("Messages")
                                                                          .doc(widget.channel)
                                                                          .update({
                                                                        "Admins": FieldValue.arrayRemove([snapshot.data?.data()!["Members"][index]["Email"]])
                                                                      }).whenComplete(() {
                                                                        Navigator.pop(context);
                                                                      });
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Colors.transparent,
                                                                    ),
                                                                    child: AutoSizeText("Remove ${snapshot2.data?.data()!["Name"]} from admins",textAlign: TextAlign.center)),
                                                              )
                                                                  :
                                                              Container(
                                                                width: size.width * 0.7,
                                                                height: size.height * 0.05,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(14),
                                                                    color: Colors.black,
                                                                    gradient: const LinearGradient(colors: [
                                                                      Colors.deepPurple,
                                                                      Colors.purpleAccent
                                                                    ])),
                                                                child: ElevatedButton(
                                                                    onPressed: () async {
                                                                      await FirebaseFirestore.instance
                                                                          .collection("Messages")
                                                                          .doc(widget.channel)
                                                                          .update({
                                                                        "Admins": FieldValue.arrayUnion([snapshot.data?.data()!["Members"][index]["Email"]])
                                                                      }).whenComplete(() {
                                                                        Navigator.pop(context);
                                                                      });
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Colors.transparent,
                                                                    ),
                                                                    child: AutoSizeText("Make ${snapshot2.data?.data()!["Name"]} admin",textAlign: TextAlign.center)),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }

                                              },
                                              child: SizedBox(
                                                height: size.height*0.06,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: size.width*0.67,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: size.width*0.07,
                                                            backgroundColor: Colors.grey,
                                                            backgroundImage: snapshot2.data!.data()!["Profile_URL"]!=null
                                                                ?
                                                            NetworkImage(snapshot2.data?.data()!["Profile_URL"])
                                                                :
                                                            null,
                                                            child: snapshot2.data!.data()!["Profile_URL"]!=null
                                                                ?
                                                            null
                                                                :
                                                            AutoSizeText(
                                                              snapshot2.data?.data()!["Name"].toString().substring(0,1) ?? "X",
                                                              style: GoogleFonts.openSans(
                                                                  fontSize: size.height*0.022,
                                                                  color: normalColor,
                                                                  fontWeight: FontWeight.w600
                                                              ),
                                                            ),


                                                          ),
                                                          SizedBox(
                                                            width: size.width*0.02,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,

                                                            children: [
                                                              SizedBox(
                                                                height: size.height*0.04,
                                                                width: size.width*0.5,
                                                                child: AutoSizeText( snapshot2.data?.data()!["Name"],
                                                                  style: GoogleFonts.openSans(
                                                                      color: normalColor,
                                                                      fontSize: size.height*0.02,
                                                                      fontWeight: FontWeight.w600,
                                                                  ),
                                                                  minFontSize: 13,
                                                                  softWrap: true,
                                                                  maxLines: 2,
                                                                ),
                                                              ),
                                                              AutoSizeText(
                                                                "User_description",
                                                                style: GoogleFonts.openSans(
                                                                    color: Colors.white38,
                                                                    fontSize: size.height*0.01,
                                                                    fontWeight: FontWeight.w500
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    snapshot.data?.data()!["Admins"].contains(snapshot.data?.data()!["Members"][index])
                                                        ?
                                                    Container(
                                                      height: size.height*0.03,
                                                      width: size.width*0.22,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.rectangle,
                                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                                          border: Border.all(
                                                              color: Colors.black38,
                                                              width: 1
                                                          ),
                                                          color: Colors.black54
                                                      ),
                                                      child: Center(
                                                        child: AutoSizeText(
                                                          "Group Admin",
                                                          style: GoogleFonts.openSans(
                                                              color: adminColor,
                                                              fontSize: size.height*0.016,
                                                              fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                        :
                                                    const SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                              :
                                          const SizedBox();
                                        }
                                    );
                                  },),
                              ),
                              snapshot.data?.data()!["Members"].length > showMembers
                                  ?
                                  TextButton(
                                    onPressed: (){
                                      setState(() {
                                        showMembers=snapshot.data?.data()!["Members"].length;
                                      });
                                    },
                                    child: AutoSizeText("View all (${snapshot.data?.data()!["Members"].length - showMembers }) more",
                                    style: GoogleFonts.exo(
                                      color: Colors.black54,
                                      fontSize: size.width*0.035,
                                      fontWeight: FontWeight.w600
                                    ),
                                    ),
                                  )
                                  :
                              TextButton(
                                onPressed: (){
                                  setState(() {
                                    showMembers=1;
                                  });
                                },
                                child: AutoSizeText("View less",
                                  style: GoogleFonts.exo(
                                      color: Colors.black54,
                                      fontSize: size.width*0.035,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              )

                            ],
                          )
                              :
                          const loading(text: "Fetching Data from the Server Please Wait",)
                          ;
                        }
                      ),
                    )
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

}
