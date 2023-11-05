import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';
import '../../Database/database.dart';


// ignore: camel_case_types
class Background_image extends StatefulWidget {
  const Background_image({super.key, required this.groupimage, required this.channel,});
  final String groupimage;
  final String channel;
  @override
  State<Background_image> createState() => _Background_imageState();
}

// ignore: camel_case_types
class _Background_imageState extends State<Background_image> {
  int index1 = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(63, 63, 63, 1),
        title: AutoSizeText("Custom Wallpaper",style: GoogleFonts.libreBaskerville(
          fontSize: size.width*0.06,
          fontWeight: FontWeight.w800,
          color: Colors.white54,
          shadows: <Shadow>[
            const Shadow(
              offset: Offset(1, 1),
              color: Colors.black,
            ),
          ],
        ),),
        leadingWidth: size.width*0.07,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);

            },
            icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white54,)),
        actions: [
          TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("Students")
                    .doc(usermodel["Email"])
                    .update({"bg": "bg-${index1 + 1}.jpg"}).whenComplete(
                        () => print("...Saved"));

                setState(() {
                  database().fetchuser().whenComplete(() {
                    InAppNotifications.instance
                      ..titleFontSize = 14.0
                      ..descriptionFontSize = 14.0
                      ..textColor = Colors.black
                      ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                      ..shadow = true
                      ..animationStyle = InAppNotificationsAnimationStyle.scale;
                    InAppNotifications.show(
                      // title: '',
                      duration: const Duration(seconds: 2),
                      description: "Background Image Changed",
                      // leading: const Icon(
                      //   Icons.error_outline_outlined,
                      //   color: Colors.red,
                      //   size: 55,
                      // )
                    );
                  });
                });
              },
              child: Text("Save",style: GoogleFonts.exo(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),))
        ],
      ),
      body: Column(
        children: [
          Container(
            height: size.height * 0.6,
            width: size.width * 0.6,
            margin: EdgeInsets.all(size.height*0.01),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                  image: AssetImage("assets/images/bg-${index1 + 1}.jpg"),
                  fit: BoxFit.fill),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.black54,
                leadingWidth: size.width*0.03,
                toolbarHeight: size.height*0.07,
                leading: IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.arrow_back_ios_new,size: size.width*0.045,)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: size.height*0.015,
                      backgroundColor: Colors.white70,
                      backgroundImage: NetworkImage(widget.groupimage),
                    ),
                    SizedBox(
                      width: size.width*0.01,
                    ),
                    SizedBox(
                      width: size.width*0.25,
                      height: size.height*0.025,
                      child: Center(
                        child: AutoSizeText(
                          widget.channel,
                          style: GoogleFonts.exo(
                              color: Colors.white,
                              fontSize: size.width*0.005
                          ),
                          minFontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: <Widget> [

                  PopupMenuButton(
                    icon: Icon(Icons.more_vert,size: size.height*0.02,),
                    itemBuilder: (context) {

                      return[];
                    },)
                ],
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: size.height*0.265,
                  ),
                  bubble("Hello", "User1", widget.groupimage, DateTime.now(), false, size, 0, 2),
                  bubble("Hey", "User2", widget.groupimage, DateTime.now(), true, size, 0, 2)
                ],
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  width: size.width*0.4,
                  padding: EdgeInsets.all(size.width*0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height*0.04,
                        width: size.width*0.45,
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            fillColor: Colors.white70,
                            filled: true,
                            hintText: "Message",
                            hintStyle:  GoogleFonts.exo(
                              color: Colors.black54,
                              fontSize: 15,//height:size.height*0.0034
                            ),
                            contentPadding: EdgeInsets.only(left: size.width*0.0),
                            disabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.black87, width: 1)
                            ),
                            prefixIcon: Icon(Icons.emoji_emotions_outlined,size: size.height*0.03,color: Colors.black87,),
                          ),

                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: size.height*0.02,
                        child: Icon(
                          Icons.send,
                          size: size.height*0.025,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.227,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              itemCount: 27,
              itemBuilder: (context, index) {
                return Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  elevation: 9,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        index1 = index;
                      });
                    },
                    child: Container(
                      width: size.width * 0.28,
                      height: size.height * 0.2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/bg-${index + 1}.jpg"),
                              fit: BoxFit.fill)),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
  Widget bubble(String text,String name,String image, DateTime stamp,bool sender,Size size,int index,int length){
    return Align(
      alignment: sender ?
      Alignment.centerRight
          :
      Alignment.centerLeft,
      child: SizedBox(
        height: size.height*0.086,
        width: size.width*0.35,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: sender ?
          MainAxisAlignment.end
              :
          MainAxisAlignment.start
          ,
          children: [

            sender
                ?
            const SizedBox()
                :
            Row(
              children: [
                SizedBox(width: size.width * 0.01),
                CircleAvatar(
                  radius: size.width * 0.03,
                  backgroundImage: image !="null"?

                  NetworkImage(image)
                      :
                  null,
                  // backgroundColor: Colors.teal.shade300,
                  child: image == "null" ?
                  AutoSizeText(
                    name.substring(0, 1),
                    style: GoogleFonts.exo(
                        fontSize: size.height * 0.01,
                        fontWeight: FontWeight.w600),
                  )
                      :
                  null,
                ),
              ],
            ),

            Container(
              width: size.width*0.25,
              margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.01,
                  vertical: size.height * 0.01),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: sender ?
                    const Radius.circular(15)
                        :
                    const Radius.circular(0),
                    topLeft: !sender ?
                    const Radius.circular(15)
                        :
                    const Radius.circular(0),
                    bottomLeft: sender ?
                    const Radius.circular(15)
                        :
                    const Radius.circular(0),
                    bottomRight: !sender ?
                    const Radius.circular(15)
                        :
                    const Radius.circular(0),
                  )
              ),
              padding: EdgeInsets.symmetric(horizontal: size.height*0.014,vertical: size.height*0.001),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size.width * 0.024,
                        fontWeight: FontWeight.w500
                    ),),
                  Text(
                    text,
                    style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.75),
                        fontSize: size.width * 0.025,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${stamp.hour}:${stamp.minute < 10 ? "0" : ""}${stamp.minute} ${stamp.hour < 12 ? "am" : "pm"}",
                        style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: size.width * 0.02,
                            fontWeight: FontWeight.w400
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  )
                ],
              ),
            ),

            !sender
                ?
            const SizedBox()
                :
            Row(
              children: [
                CircleAvatar(
                  radius: size.width * 0.03,
                  backgroundImage: image !="null"?

                  NetworkImage(image)
                      :
                  null,
                  // backgroundColor: Colors.teal.shade300,
                  child: image == "null" ?
                  AutoSizeText(
                    name.substring(0, 1),
                    style: GoogleFonts.exo(
                        fontSize: size.height * 0.01,
                        fontWeight: FontWeight.w600),
                  )
                      :
                  null,
                ),
                SizedBox(width: size.width * 0.01),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
