import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'Image_Tile.dart';
import 'Name_Tile.dart';
import 'Pdf_tile.dart';
import 'Reply_Tile.dart';
import 'Text_Tile.dart';
import 'User_circle_Avatar.dart';
import 'Video_Tile.dart';

class MsgTile extends StatelessWidget {
  const MsgTile(
      {super.key,
      required this.imageMsg,
      required this.reply,
      required this.name,
      required this.text,
      required this.sender,
      required this.scrollindex,
      required this.replyIndex,
      required this.replyToName,
      required this.ReplyToText,
      required this.scrollController,
      required this.channel,
      required this.imageURL,
      required this.videoURL,
      required this.videoThumbnailURL,
      required this.videoMsg,

      required this.stamp,
      required this.comressedURL, required this.image, required this.pdfMsg, required this.pdfImageUrl, required this.pdfUrl, required this.pdfName, required this.pdfSize, required this.email, required this.snapshot});
  final bool imageMsg;
  final String comressedURL;
  final bool reply;
  final String name;
  final String text;
  final bool sender;
  final int scrollindex;
  final int replyIndex;
  final String replyToName;
  final String ReplyToText;
  final ItemScrollController scrollController;
  final String channel;
  final String imageURL;
  final String videoURL;
  final String videoThumbnailURL;
  final bool videoMsg;
  final String email;
  final DateTime stamp;
  final String image;
  final bool pdfMsg;
  final String pdfImageUrl;
  final String pdfUrl;
  final String pdfName;
  final int pdfSize;
  final AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int len=max(text.length, name.length);
    double width= (imageMsg || reply || videoMsg || pdfMsg)
        ?
    size.width * 0.7
        :
    len>25
        ?
    size.width * 0.0235 * 25
        :
    sender
        ?
        text.length <= 3
    ?
        size.width * 0.033 * 9
            :
        size.width * 0.0235 * len
        :
    name.length>=text.length
        ?
    size.width * 0.033 * len
        :
    size.width * 0.0235 * len
        ;
    if(width < size.width*0.3){
      width=size.width*0.3;
    }
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.01, vertical: size.height * 0.01),
      decoration: BoxDecoration(

          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),

          ),

          gradient: !sender?

          const LinearGradient(colors: [
              Color.fromRGBO(85, 184, 205, 1),
            Color.fromRGBO(199, 84, 205, 1),

          ])



              :



          const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(0, 0, 130, 1),
            Color.fromRGBO(28, 180, 224, 1)
          ],
          ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height*0.01,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: size.height*0.01,),
              UserAvatar(image: image,name: name),

              SizedBox(
                  width: width - size.width*0.18,
                  child: NameTile(sender:sender,name: name, channel: channel, email: email,snapshot: snapshot,)
              ),

            ],
          ),
          SizedBox(height: size.height*0.01,),
          reply
              ?
          ReplyTile(
            sender: sender,
              scrollController: scrollController,
              replyIndex: replyIndex,
              scrollindex: scrollindex,
              replyToName: replyToName,
              ReplyToText: ReplyToText,
          )
              :
          const SizedBox(),

          text.isNotEmpty
              ?
          TextTile(sender: sender,text: text)
              :
          const SizedBox(),

          imageMsg
              ?
          ImageTile(
            channel: channel,
            imageURL: imageURL,
            compressedURL: comressedURL,
            stamp: stamp,
          )
              :
          const SizedBox(),

          videoMsg
              ?
          Center(
            child: VideoTile(
              channel: channel,
              videoURL: videoURL,
              videoThumbnailURL: videoThumbnailURL,
              stamp: stamp,
            ),
          )
              :
          const SizedBox(),

          pdfMsg
              ?
          PdfTile(pdfUrl: pdfUrl, pdfImageUrl: pdfImageUrl,name: pdfName,size: pdfSize,stamp: stamp,)
              :
          const SizedBox()
          ,
        ],
      ),
    );
  }
}
