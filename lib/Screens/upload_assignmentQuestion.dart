import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Database/database.dart';
import 'package:campus_link_teachers/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../Constraints.dart';

class AssigmentQuestion extends StatefulWidget {
  const AssigmentQuestion({super.key});

  @override
  State<AssigmentQuestion> createState() => _AssigmentQuestionState();
}

class _AssigmentQuestionState extends State<AssigmentQuestion> {
  TextEditingController videoController = TextEditingController();

  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();

  late final FilePickerResult? filePath;
  bool fileSelected = false;
  int assignmentCount = 0;

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      padding: EdgeInsets.all(size.height * 0.01),
      decoration: BoxDecoration(
        color: Colors.black26.withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: size.height * 0.08,
          ),
          Padding(
            padding: EdgeInsets.all(size.height * 0.009),
            child: Row(
              children: [
                AutoSizeText(
                  "Upload File",
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: size.height * 0.023,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                const Icon(
                  Icons.cloud_upload,
                  color: Colors.white,
                )
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: size.height * 0.1,
                width: size.width,
                child: DottedBorder(
                    color: Colors.white,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          size: size.height * 0.04,
                          Icons.upload_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: size.width * 0.03,
                        ),
                        AutoSizeText(
                          "Drop item here  or",
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontSize: size.height * 0.02,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FilePicker.platform
                                .pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf'],
                                allowMultiple: false)
                                .then((value) {
                              if (value!.files[0].path!.isNotEmpty) {
                                filePath = value;
                                print(
                                    ".......PickedFile${filePath?.files[0].path}");
                                setState(() {
                                  fileSelected = true;
                                });
                              }
                            });
                          },
                          child: AutoSizeText(
                            "Browse File",
                            style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        fileSelected
                            ? Icon(
                          size: size.height * 0.02,
                          Icons.check_circle,
                          color: Colors.green.shade800,
                        )
                            : const SizedBox()
                      ],
                    ))),
          ),
          SizedBox(
            height: size.height * 0.015,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: size.height * 0.07,
              width: size.width,
              child: DottedBorder(
                color: Colors.white,
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: dateInput,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today, color: Colors.white),
                    border: InputBorder.none,
                    hintText: "Enter Date ",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      print(pickedDate);
                      String formattedDate =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                      print(formattedDate);
                      setState(() {
                        dateInput.text = formattedDate;
                      });
                    } else {}
                  },
                  cursorColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: size.height * 0.07,
              width: size.width,
              child: DottedBorder(
                color: Colors.white,
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: timeInput,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.timer, color: Colors.white),
                    border: InputBorder.none,
                    hintText: "Select Time ",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    _selectTime(context);
                  },
                  readOnly: true,
                  cursorColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Center(
            child: Container(
              height: size.height * 0.06,
              width: size.width * 0.466,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue,
                      Colors.purpleAccent,
                    ],
                  ),
                  borderRadius:
                  BorderRadius.all(Radius.circular(size.width * 0.033)),
                  border: Border.all(color: Colors.black, width: 2)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent),
                onPressed: () async {
                  if (fileSelected &&
                      dateInput.text.toString().isNotEmpty &&
                      timeInput.text.toString().isNotEmpty)

                  {
                    const loading(text: "Please Wait data is uploading",);
                    Reference ref = FirebaseStorage.instance
                        .ref("Assignments")
                        .child(
                        "$university_filter $college_filter $branch_filter $year_filter $section_filter $subject_filter");
                    DateTime stamp = DateTime.now();
                    Reference filename = ref.child("$stamp");
                    TaskSnapshot snap = await filename.putFile(File("${filePath!.files[0].path}"));
                    String pdfURL = await snap.ref.getDownloadURL();
                    Directory? directory = await getApplicationSupportDirectory();
                    String additionalPath = "Assignment";
                    directory = Directory("${directory.path}$additionalPath");
                    File file = await File("${directory.path}/$stamp.pdf").create(recursive: true);
                    await File("${filePath?.files[0].path}").copy(file.path).then((value) {


                      print("..........................After copy result will be$value");
                    }).whenComplete(() {
                      FirebaseFirestore.instance
                          .collection("Assignment")
                          .doc(
                          "${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter")
                          .get()
                          .then((value) async {

                        print("...............///.${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter");

                        if (value.data() == null) {
                          assignmentCount = 0;
                          FirebaseFirestore.instance
                              .collection("Assignment")
                              .doc(
                              "${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter")
                              .set({
                            "Total_Assignment": assignmentCount+1,

                            "Assignment-${assignmentCount+1}": {
                              "Assignment": pdfURL,
                              "Document-type":filePath?.files[0].extension,
                              "Size":filePath?.files[0].size,
                              "Assign-Date":stamp,
                              "Last Date": dateInput.text.toString(),
                              "Time": selectedTime.toString(),

                            }

                          }).whenComplete(
                                  () => print("........\n\n\n Created"));
                        } else {
                          assignmentCount =
                          value.data()?["Total_Assignment"];

                          FirebaseFirestore.instance
                              .collection("Assignment")
                              .doc(
                              "${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter")
                              .update({
                            "Assignment-${assignmentCount+1}": {
                              "Assignment": pdfURL,
                              "Document-type":filePath?.files[0].extension,
                              "Size":filePath?.files[0].size,
                              "Assign-Date":stamp,
                              "Last Date": dateInput.text.toString(),
                              "Time": selectedTime.toString(),
                            },
                            "Total_Assignment": FieldValue.increment(1)
                          }
                          );
                        }
                        var studentsDoc =     await FirebaseFirestore.instance.collection("Students")
                            .where("University",isEqualTo: university_filter)
                            .where("College",isEqualTo: college_filter)
                            .where("Branch",isEqualTo: branch_filter)
                            .where("Course",isEqualTo: course_filter)
                            .where("Year",isEqualTo: year_filter)
                            .where("Section",isEqualTo: section_filter)
                            .where("Subject",arrayContains: subject_filter).get();
                        List<String> tokens =[];
                        List<String> emails=[];
                        for(int i=0;i<studentsDoc.docs.length ; i++){
                          tokens.add(studentsDoc.docs[i].data()["Token"]);
                          emails.add(studentsDoc.docs[i].data()["Email"]);
                        }
                        for(int i=0;i<tokens.length;i++ ){
                          database().sendPushMessage(tokens[i], "Assignment ${assignmentCount+1} DeadLine: ${dateInput.value.text}","New $subject_filter Assignment", false, "", stamp);
                          await FirebaseFirestore.instance.collection("Students").doc(emails[i]).update({
                            "Notifications" : FieldValue.arrayUnion([{
                              "title" : "$subject_filter assignment pending.",
                              'body' : 'Your $subject_filter assignment ${assignmentCount+1} is pending. Please complete your assignment as soon as possible.\nDeadline: ${dateInput.value.text}'
                            }])
                          });
                        }
                      }).whenComplete(
                            () => Navigator.pop(context),
                      );
                    });
                  }
                },


                child: AutoSizeText(
                  "Submit",
                  style: GoogleFonts.openSans(
                      fontSize: size.height * 0.025,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        String timer =
            "${timeOfDay.hour} : ${timeOfDay.minute} ${timeOfDay.period.toString().split(".")[1]}";
        timeInput = TextEditingController(text: timer);
      });
    }
  }
}
