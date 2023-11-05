import 'dart:io';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import '../../Constraints.dart';
import '../../Database/database.dart';
import '../loadingscreen.dart';
import 'chat.dart';

class DocumentViewer extends StatefulWidget {
  const DocumentViewer(
      {super.key,
      required this.document,
      required this.replyToName,
      required this.replyBoxHeight,
      required this.replyToText, required this.channel, required this.replyIndex, required this.msgLength});
  final FilePickerResult? document;

  final String replyToName;

  final double replyBoxHeight;

  final String replyToText;
  final int replyIndex;
  final String channel;
  final int msgLength;
  @override
  State<DocumentViewer> createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer> {
  List<PdfController> pdfControllers = [];
  late PdfDocument page;
  int pdfIndex = 0;
  List<Uint8List> imageBytes = [];
  bool load = false;
  bool initialized = false;
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var file in widget.document!.files) {
      pdfControllers.add(PdfController(document: PdfDocument.openFile("${file.path}")));
    }
    getBytes();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: size.width*0.13,
        titleSpacing: 0,
        leading: InkWell(
            onTap: () async {
              Navigator.pop(context);
            },
            child: const Icon(
                Icons.arrow_back_ios_new)),
        centerTitle: false,
        title: AutoSizeText(
          widget.document!.files[0].name,
          style: GoogleFonts.exo(
              color: Colors
                  .white,
              fontSize:
              size.width *
                  0.06),
          minFontSize: 8,
          maxLines: 1,
        )
      ),
      body: initialized
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.01,
                ),
                // load
                //     ? SizedBox(
                //         height: size.height * 0.15,
                //         child: ListView.builder(
                //
                //           scrollDirection: Axis.horizontal,
                //           itemCount: imageBytes.length,
                //           itemBuilder: (context, index) {
                //             return InkWell(
                //               onTap: () {
                //                 setState(() {
                //                   pdfIndex=index;
                //                 });
                //               },
                //               child: Container(
                //                 height: size.height * 0.2,
                //                 width: size.width * 0.3,
                //                 decoration: BoxDecoration(
                //                     color: Colors.black,
                //                     image: DecorationImage(
                //                         image: MemoryImage(imageBytes[index]),
                //                         fit: BoxFit.contain)),
                //               ),
                //             );
                //           },
                //         ),
                //       )
                //     : const SizedBox(),
                Expanded(
                  child: PdfView(

                    scrollDirection: Axis.vertical,
                    controller: pdfControllers[pdfIndex],
                  ),
                ),
              ],
            )
          : const loading(
              text: 'Loading Pdf please wait',
            ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: size.width,
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03, vertical: size.height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(alignment: Alignment.bottomCenter, children: [
                AnimatedContainer(
                  height: widget.replyBoxHeight,
                  width: size.width * 0.75,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
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
                        padding: EdgeInsets.all(size.height * 0.008),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.replyToName,
                              style: GoogleFonts.exo(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            Text(
                              widget.replyToText,
                              style: GoogleFonts.exo(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear))
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.062,
                  width: size.width * 0.75,
                  child: TextField(
                    controller: messageController,
                    enableSuggestions: true,
                    maxLines: 5,
                    minLines: 1,
                    autocorrect: true,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                      fillColor: Colors.white70,
                      filled: true,
                      hintText: "Message",
                      hintStyle: GoogleFonts.exo(
                        color: Colors.black54,
                        fontSize: 19, //height:size.height*0.0034
                      ),
                      contentPadding: EdgeInsets.only(left: size.width * 0),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1)),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1)),
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
                  Navigator.push(context, PageTransition(child: const loading(text: "Please Wait...\nUploading Document to server.."), type: PageTransitionType.bottomToTop));
                  DateTime stamp= DateTime.now();
                  Reference reference=FirebaseStorage.instance.ref();


                  Reference imageDirectory=reference.child("Message_Images");


                  Reference imageFolder=imageDirectory.child(widget.channel);

                  Reference channel=imageFolder.child("$stamp");


                  TaskSnapshot snap= await channel.putFile(File("${widget.document?.files[0].path}"));
                  String pdfURL=await snap.ref.getDownloadURL();


                  Directory? directory = await getApplicationSupportDirectory();
                  String additionalPath= "/images";
                  directory = Directory("${directory.path}$additionalPath");
                  File file = await File("${directory.path}/$stamp.png").create(recursive: true);
                  File imagePath = await file.writeAsBytes(imageBytes[0]);



                  //String path = await VideoThumbnail.thumbnailFile(video: URL,imageFormat: ImageFormat.PNG,quality: 1,thumbnailPath: (await getApplicationDocumentsDirectory()).path) ?? "";
                  reference=FirebaseStorage.instance.ref();

                  imageDirectory=reference.child("Message_Images");


                  imageFolder=imageDirectory.child(widget.channel);

                  channel=imageDirectory.child("$stamp");

                  snap= await channel.putFile(File(imagePath.path));
                  String imageURL=await snap.ref.getDownloadURL();
                  additionalPath= "/thumbnail";
                  directory = Directory("${directory.path}$additionalPath");
                  XFile? compressed;
                  await FlutterImageCompress.compressAndGetFile(
                    imagePath.path,
                    "${directory.path}/$stamp.jpg",
                    quality: 1,
                    //format: CompressFormat.png
                  ).then((value) => compressed=value);
                  reference=FirebaseStorage.instance.ref();

                  imageDirectory=reference.child("Message_Images");


                  imageFolder=imageDirectory.child(widget.channel);

                  channel=imageDirectory.child("$stamp");

                  snap= await channel.putFile(File(imagePath.path));
                  String thumbnailURL=await snap.ref.getDownloadURL();
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
                  "Reply_Index": widget.msgLength -widget.replyIndex -1,
                  "Media" : true,
                  "Media_Type": "Pdf",
                  "Pdf_Url" :pdfURL,
                  "Pdf_Url_Thumbnail": thumbnailURL,
                  "Pdf_Url_Image": imageURL,
                    "Doc_Name" : widget.document?.files[0].name,
                    "Doc_Size" : widget.document?.files[0].size,

                  }
                  ]),
                  "Media_Files":FieldValue.arrayUnion([{
                  "Pdf":true,
                  "Pdf_Thumbnail": thumbnailURL,
                  "Pdf_URL": pdfURL,
                  "Pdf_Image": imageURL,
                    "Doc_Size" : widget.document?.files[0].size,
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
                  }).whenComplete(() async {
                    setState(() {
                      messageController.clear();
                    });
                    final doc = await FirebaseFirestore.instance
                        .collection("Messages")
                        .doc(widget.channel)
                        .get()
                        .whenComplete(() {
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

                  });

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
    );
  }

  getBytes() async {
    for (var controller in pdfControllers) {
      PdfDocument doc = await controller.document;
      PdfPage page = await doc.getPage(1);
      PdfPageImage? image = await page.render(
          width: 400,
          height: 400,
          format: PdfPageImageFormat.png,
          backgroundColor: "#FFFFFF");
      imageBytes.add(image!.bytes);
      await page.close();
      print("............running");
    }
    print("..........................\n${imageBytes[0]}");
    setState(() {
      initialized = true;
      load = true;
    });
  }
}
