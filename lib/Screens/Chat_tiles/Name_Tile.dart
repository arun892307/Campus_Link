import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../Constraints.dart';
import '../loadingscreen.dart';
import 'chat.dart';

class NameTile extends StatelessWidget {
  const NameTile(
      {super.key,
      required this.name,
      required this.sender,
      required this.channel,
      required this.email,
      required this.snapshot});
  final bool sender;
  final String name;
  final String channel;
  final String email;
  final AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        if (!sender) {
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
                      snapshot.data!.data()?["${email.split("@")[0]}"]["Mute"] != true && snapshot.data!.data()?["Admins"].contains("${usermodel["Email"]}")
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
                                        .doc(channel)
                                        .update({
                                      "${email.split("@")[0]}.Mute": true
                                    }).whenComplete(() {
                                      Navigator.pop(context);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                  ),
                                  child: AutoSizeText("Mute $name")),
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
                                        .doc(channel)
                                        .update({
                                      "${email.split("@")[0]}.Mute": false
                                    }).whenComplete(() {
                                      Navigator.pop(context);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                  ),
                                  child: AutoSizeText("Unmute $name")),
                            ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      snapshot.data!.data()?["Admins"].contains(email) && snapshot.data!.data()?["Admins"].contains("${usermodel["Email"]}")
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
                                        .doc(channel)
                                        .update({
                                      "Admins": FieldValue.arrayRemove([email])
                                    }).whenComplete(() {
                                      Navigator.pop(context);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                  ),
                                  child: AutoSizeText("Remove $name from admin")),
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
                                        .doc(channel)
                                        .update({
                                      "Admins": FieldValue.arrayUnion([email])
                                    }).whenComplete(() {
                                      Navigator.pop(context);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                  ),
                                  child: AutoSizeText("Make $name admin")),
                            ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
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
                              final collection = snapshot.data!.data()?[email.split("@")[0]]["Post"];
                              await FirebaseFirestore.instance.collection(collection).doc(email).update({
                                "Message_channels" : FieldValue.arrayUnion(["${usermodel["Email"]}-$email"]),
                              }).whenComplete((){
                                Navigator.push(context, PageTransition(
                                    duration: const Duration(milliseconds: 400),
                                    childCurrent: ChatPage(channel: channel),
                                    child: const loading(text: "Adding subject please wait"),
                                    type: PageTransitionType.bottomToTopJoined));
                              });
                              await FirebaseFirestore.instance.collection("Teachers").doc(usermodel["Email"]).update({
                                "Message_channels" : FieldValue.arrayUnion(["${usermodel["Email"]}-$email"]),
                              });

                              Map<String,dynamic> map2 = {
                                "Active":false,
                                "Read_Count": 1,
                                "Last_Active" : DateTime.now(),
                                "Token": FieldValue.arrayUnion([usermodel["Token"]])
                              };
                              DateTime stamp=DateTime.now();
                              var data=await FirebaseFirestore.instance.collection("Chat_Channels").doc("Channels").get();
                              data.data()==null
                                  ?
                              await FirebaseFirestore.instance.collection("Chat_Channels").doc("Channels").set({
                                "Channels" : FieldValue.arrayUnion([""])
                              })
                                  :
                              null;

                              await FirebaseFirestore.instance.collection("Chat_Channels").doc("Channels").get().then((value) async {
                                List<dynamic> channel=value.data()!["Channels"];
                                channel.contains(
                                    "${usermodel["Email"]}-$email"
                                )
                                    ?
                                null
                                    :
                                await FirebaseFirestore.instance.collection("Messages").doc(
                                    "${usermodel["Email"]}-$email"
                                ).set({
                                  "Type" : "Personal",
                                  "Messages" : [],
                                  usermodel["Email"].toString().split("@")[0] : map2,
                                  "image_URL" : "null",
                                  "CreatedOn": {"Date" : stamp, "Name": usermodel["Name"]},
                                  "Members" : [{"Name": usermodel["Name"], "Post" :"Teachers","Email" : usermodel["Email"]},{"Email" : email,"Name": name, "Post" : snapshot.data!.data()!["${email.split("@")[0]}"]["Post"]}]
                                })
                                    .whenComplete(() async {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                        return ChatPage(channel: "${usermodel["Email"]}-$email");
                                      },));
                                });
                              });


                              await FirebaseFirestore.instance.collection("Chat_Channels").doc("Channels").update({
                                "Channels": FieldValue.arrayUnion([
                                  "${usermodel["Email"]}-$email"
                                ])
                              }).whenComplete((){

                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                            ),
                            child: AutoSizeText("Chat with $name")),
                      )
                    ],
                  ),
                ],
              );
            },
          );
        }
      },
      child: AutoSizeText(
        sender ? "You" : name,
        style: GoogleFonts.poppins(
            color: sender ? Colors.white : Colors.black,
            fontSize: size.width * 0.034,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
