import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../Constraints.dart';
import '../../Database/database.dart';
import 'chat.dart';
import '../loadingscreen.dart';

class SendMedia extends StatefulWidget {
  const SendMedia({super.key, required this.imagePath, required this.channel, required this.messageLength, required this.replyBoxHeight, required this.replyToName, required this.replyToText, required this.replyIndex, required this.video});
  final XFile imagePath;
  final String channel;
  final int messageLength;
  final double replyBoxHeight;
  final String replyToName;
  final String replyToText;
  final int replyIndex;
  final bool video;
  @override
  State<SendMedia> createState() => _SendMediaState();
}

class _SendMediaState extends State<SendMedia> {
  TextEditingController messageController = TextEditingController();
  late VideoPlayerController videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController=  VideoPlayerController.file(File(widget.imagePath.path),);
    videoPlayerController.initialize().then((value){setState(() {
      print("Initialized");
    });});
    videoPlayerController.setLooping(true);
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return widget.video ?
    Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          color: Colors.black,
          height: 500,
          width: 500,
          child: videoPlayerController.value.isInitialized
              ?
          AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: VideoPlayer(videoPlayerController),
          )
              :
          const loading(text: "Please wait...\nLoading video"),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(

            onPressed: () {
              setState(() {

                if(videoPlayerController.value.duration == videoPlayerController.value.position){
                  videoPlayerController.initialize();
                }
                videoPlayerController.value.isPlaying
                    ? videoPlayerController.pause()
                    : videoPlayerController.play();
              });
            },
            icon: Icon(
              videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: size.width,
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03,vertical: size.height*0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedContainer(
                      height: widget.replyBoxHeight,
                      width: size.width * 0.78,
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(12),
                          topLeft:Radius.circular(12),
                          bottomRight:Radius.circular(30),
                          bottomLeft:Radius.circular(30),

                        ),
                      ),
                      duration: const Duration(milliseconds: 100),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            width: size.width * 0.8,
                            margin: EdgeInsets.only(
                              bottom: size.height * 0.07,
                              top: size.height * 0.01,
                              right: size.height * 0.01,
                              left: size.height * 0.01,
                            ),
                            padding: EdgeInsets.all(
                                size.height * 0.008),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(12))),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.replyToName,
                                  style: GoogleFonts.exo(
                                      fontWeight:
                                      FontWeight.w600,
                                      fontSize: 14),
                                ),
                                Text(
                                  widget.replyToText,
                                  style: GoogleFonts.exo(
                                      fontWeight:
                                      FontWeight.w500,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {

                                });
                              },
                              icon: const Icon(Icons.clear))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.062,
                      width: size.width * 0.78,
                      child: TextField(
                        controller: messageController,
                        enableSuggestions: true,
                        maxLines: 5,
                        minLines: 1,
                        autocorrect: true,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () async {
                                // ImagePicker imagePicker=ImagePicker();
                                // print(imagePicker);
                                // XFile? file=await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                              },
                              icon: Icon(Icons.image,color: Colors.black,size: size.height*0.04,)),
                          suffixIconColor: Colors.black,
                          fillColor: Colors.white70,
                          filled: true,
                          hintText: "Message",
                          hintStyle: GoogleFonts.exo(
                            color: Colors.black54,
                            fontSize: 19, //height:size.height*0.0034
                          ),
                          contentPadding: EdgeInsets.only(
                              left: size.width * 0),
                          enabledBorder:
                          const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(
                                      30.0)),
                              borderSide: BorderSide(
                                  color: Colors.black54,
                                  width: 1)),
                          focusedBorder:
                          const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(
                                      30.0)),
                              borderSide: BorderSide(
                                  color: Colors.black54,
                                  width: 1)),
                          prefixIcon: Icon(
                            Icons.emoji_emotions_outlined,
                            size: size.height * 0.042,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ]),
              TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const loading(text: "Please Wait Uploading media file on server"),
                      type: PageTransitionType.bottomToTopJoined,
                      duration: const Duration(milliseconds: 200),
                      alignment: Alignment.bottomCenter,
                      childCurrent: SendMedia(
                        replyToName: widget.replyToName,
                        video: widget.video,
                        channel: widget.channel,
                        imagePath: widget.imagePath,
                        messageLength: widget.messageLength,
                        replyBoxHeight: widget.replyBoxHeight,
                        replyIndex: widget.replyIndex,
                        replyToText: widget.replyToText,
                      ),
                    ),
                  );
                  DateTime stamp= DateTime.now();
                  Reference reference=FirebaseStorage.instance.ref();

                  // Create Directory into Firebase Storage

                  Reference imageDirectory=reference.child("Message_Images");


                  Reference imageFolder=imageDirectory.child(widget.channel);

                  Reference channel=imageFolder.child("$stamp");


                  TaskSnapshot snap= await channel.putFile(File(widget.imagePath.path));
                  String URL=await snap.ref.getDownloadURL();
                  String path = await VideoThumbnail.thumbnailFile(video: URL,imageFormat: ImageFormat.PNG,quality: 1,thumbnailPath: (await getApplicationDocumentsDirectory()).path) ?? "";
                  reference=FirebaseStorage.instance.ref();

                  imageDirectory=reference.child("Message_Images");


                  imageFolder=imageDirectory.child("${usermodel[widget.channel]}");

                  channel=imageDirectory.child("$stamp");

                  snap= await channel.putFile(File(path));
                  String thumbURL=await snap.ref.getDownloadURL();
                  await FirebaseFirestore.instance
                      .collection("Messages")
                      .doc(widget.channel)
                      .update(
                    {
                      "Messages": FieldValue.arrayUnion([
                        {
                          "Name": usermodel["Name"]
                              .toString(),
                          "UID": usermodel["Email"]
                              .toString(),
                          "text": messageController.text
                              .trim()
                              .toString(),
                          "Stamp": stamp,
                          "Reply": widget.replyBoxHeight != 0
                              ? true
                              : false,
                          "Reply_Index": widget.messageLength -
                              widget.replyIndex -
                              1,
                          "Media" : true,
                          "Media_Type": "Video",
                          "Video_Url" :URL,
                          "Video_Thumbnail": thumbURL
                        }
                      ]),
                      "Media_Files":FieldValue.arrayUnion([{
                        "Video":true,
                        "Video_Thumbnail": thumbURL,
                        "Video_Url": URL,
                        "Name" : "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}"
                      }]),
                    },
                  ).whenComplete(
                        () async {
                      await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").update({
                        "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}_Delevered" : FieldValue.arrayUnion([{
                          "Email" : usermodel["Email"],
                          "Stamp" : stamp
                        }]),
                        "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}_Seen" : FieldValue.arrayUnion([{
                          "Email" : usermodel["Email"],
                          "Stamp" : stamp
                        }]),
                        "${usermodel["Email"].toString().split('@')[0]}_${stamp.toString().split(".")[0]}_Seened": FieldValue.arrayUnion([usermodel["Email"]]),
                      });
                      setState(() {
                        messageController.clear();
                      });
                      final doc = await FirebaseFirestore.instance
                          .collection("Messages")
                          .doc(widget.channel)
                          .get()
                          .whenComplete(() {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(channel: widget.channel),
                          ),
                        );
                      });
                      List<dynamic> members = doc.data()?["Members"];
                      for (var member in members) {
                        String email=member["Email"];
                        List<dynamic> tokens = doc.data()?[email.toString().split("@")[0]]["Token"];
                        if(email!=usermodel["Email"]){
                          for(var token in tokens){
                            database().sendPushMessage(
                                token,
                                messageController.text.trim(),
                                widget.channel.toString().split(" ")[6],
                                true,
                                widget.channel,
                                stamp
                            );
                          }
                        }
                      }
                    },

                  );

                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: size.height * 0.032,
                  child: Icon(
                    Icons.send,
                    size: size.height * 0.032,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        :
    Container(
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(image: FileImage(File(widget.imagePath.path)),fit: BoxFit.contain)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: CircleAvatar(
          radius: size.width*0.05,
          backgroundColor: Colors.black.withOpacity(0.5),
          child: IconButton(
            onPressed: (){Navigator.pop(context);},
            icon: const Icon(Icons.clear),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: size.width,
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03,vertical: size.height*0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedContainer(
                        height: widget.replyBoxHeight,
                        width: size.width * 0.78,
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.only(
                            topRight:Radius.circular(12),
                            topLeft:Radius.circular(12),
                            bottomRight:Radius.circular(30),
                            bottomLeft:Radius.circular(30),

                          ),
                        ),
                        duration: const Duration(milliseconds: 100),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: size.width * 0.8,
                              margin: EdgeInsets.only(
                                bottom: size.height * 0.07,
                                top: size.height * 0.01,
                                right: size.height * 0.01,
                                left: size.height * 0.01,
                              ),
                              padding: EdgeInsets.all(
                                  size.height * 0.008),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(12))),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.replyToName,
                                    style: GoogleFonts.exo(
                                        fontWeight:
                                        FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    widget.replyToText,
                                    style: GoogleFonts.exo(
                                        fontWeight:
                                        FontWeight.w500,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {

                                  });
                                },
                                icon: const Icon(Icons.clear))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.062,
                        width: size.width * 0.78,
                        child: TextField(
                          controller: messageController,
                          enableSuggestions: true,
                          maxLines: 5,
                          minLines: 1,
                          autocorrect: true,
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.black, fontSize: 18),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  // ImagePicker imagePicker=ImagePicker();
                                  // print(imagePicker);
                                  // XFile? file=await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                                },
                                icon: Icon(Icons.image,color: Colors.black,size: size.height*0.04,)),
                            suffixIconColor: Colors.black,
                            fillColor: Colors.white70,
                            filled: true,
                            hintText: "Message",
                            hintStyle: GoogleFonts.exo(
                              color: Colors.black54,
                              fontSize: 19, //height:size.height*0.0034
                            ),
                            contentPadding: EdgeInsets.only(
                                left: size.width * 0),
                            enabledBorder:
                            const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(
                                    Radius.circular(
                                        30.0)),
                                borderSide: BorderSide(
                                    color: Colors.black54,
                                    width: 1)),
                            focusedBorder:
                            const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(
                                    Radius.circular(
                                        30.0)),
                                borderSide: BorderSide(
                                    color: Colors.black54,
                                    width: 1)),
                            prefixIcon: Icon(
                              Icons.emoji_emotions_outlined,
                              size: size.height * 0.042,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ]),
                TextButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: const loading(text: "Please Wait Uploading media file on server"),
                        type: PageTransitionType.bottomToTopJoined,
                        duration: const Duration(milliseconds: 200),
                        alignment: Alignment.bottomCenter,
                        childCurrent: SendMedia(
                          replyToName: widget.replyToName,
                          video: widget.video,
                          channel: widget.channel,
                          imagePath: widget.imagePath,
                          messageLength: widget.messageLength,
                          replyBoxHeight: widget.replyBoxHeight,
                          replyIndex: widget.replyIndex,
                          replyToText: widget.replyToText,
                        ),
                      ),
                    );
                    Reference reference=FirebaseStorage.instance.ref();

                    // Create Directory into Firebase Storage

                    Reference imageDirectory=reference.child("Message_Images");


                    Reference imageFolder=imageDirectory.child(widget.channel);
                    DateTime stamp=DateTime.now();
                    Reference channel=imageFolder.child("$stamp");


                    TaskSnapshot snap= await channel.putFile(File(widget.imagePath.path));
                    String URL=await snap.ref.getDownloadURL();

                    Directory cache=await getApplicationDocumentsDirectory();
                    Directory target= Directory("${cache.path}/thumbnail");
                    await target.exists()
                        ?
                    null
                        :
                    target=await target.create();

                    XFile? compressed;
                    print("........$target,    ${widget.imagePath.path}");
                    File absolute= File(widget.imagePath.path);
                    await FlutterImageCompress.compressAndGetFile(
                      absolute.absolute.path,
                      "${target.path}/test.jpg",
                      quality: 1,
                      //format: CompressFormat.png
                    ).then((value) => compressed=value);
                    if (kDebugMode) {
                      print(compressed);
                    }

                    channel=imageFolder.child("Thumbnail");
                    channel=channel.child("$stamp");


                    snap= await channel.putFile(File(compressed!.path));
                    print(target);
                    String CURL=await snap.ref.getDownloadURL();
                    await FirebaseFirestore.instance
                        .collection("Messages")
                        .doc(widget.channel)
                        .update(
                      {
                        "Messages": FieldValue.arrayUnion([
                          {
                            "Name": usermodel["Name"].toString(),
                            "UID": usermodel["Email"].toString(),
                            "text": messageController.text.trim().toString(),
                            "Stamp": stamp,
                            "Reply": widget.replyBoxHeight != 0
                                ? true
                                : false,
                            "Reply_Index": widget.messageLength - widget.replyIndex - 1,
                            "Media": true,
                            "Media_Type" : "Image",
                            "Image_Url" : URL,
                            "Image_Thumbnail" : CURL
                          }
                        ]),
                        "Media_Files":FieldValue.arrayUnion([{
                          "Video":false,
                          "Image_Url": URL,
                          "Image_Thumbnail" : CURL,
                          "Name" : "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}"
                        }]),
                      },
                    ).whenComplete(
                          () async {
                        await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").update({
                          "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}_Delevered" : FieldValue.arrayUnion([{
                            "Email" : usermodel["Email"],
                            "Stamp" : stamp
                          }]),
                          "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}_Seen" : FieldValue.arrayUnion([{
                            "Email" : usermodel["Email"],
                            "Stamp" : stamp
                          }]),
                          "${usermodel["Email"].toString().split('@')[0]}_${stamp.toString().split(".")[0]}_Seened": FieldValue.arrayUnion([usermodel["Email"]]),
                        });
                        setState(() {
                          messageController.clear();
                        });
                        final doc = await FirebaseFirestore.instance
                            .collection("Messages")
                            .doc(widget.channel)
                            .get()
                            .whenComplete(() {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(channel: widget.channel),
                            ),
                          );
                        });
                        List<dynamic> members = doc.data()?["Members"];
                        for (var member in members) {
                          String email=member["Email"];
                          List<dynamic> tokens = doc.data()?[email.toString().split("@")[0]]["Token"];
                          if(email!=usermodel["Email"]){
                            for(var token in tokens){
                              database().sendPushMessage(
                                  token,
                                  messageController.text.trim(),
                                  widget.channel.toString().split(" ")[6],
                                  true,
                                  widget.channel,
                                  stamp
                              );
                            }
                          }
                        }
                      },

                    );

                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: size.height * 0.032,
                    child: Icon(
                      Icons.send,
                      size: size.height * 0.032,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
