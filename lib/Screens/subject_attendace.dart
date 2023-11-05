import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

import '../push_notification/Storage_permission.dart';

class Subject extends StatefulWidget {
  const Subject({super.key, required this.uni, required this.clg, required this.course, required this.branch, required this.year, required this.section, required this.subject});
  final String uni;
  final String clg;
  final String course;
  final String branch;
  final String year;
  final String section;
  final String subject;

  @override
  State<Subject> createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  final FileManagerController controller = FileManagerController();
  DateTime startDate = DateTime.now();
  TextEditingController start_date_controller = TextEditingController();
  var checkALLPermissions = CheckPermission();
  DateTime endDate = DateTime.now();
  TextEditingController end_date_controller = TextEditingController();
  bool isPermission = false;
  bool loading=true;
  Future<void> setpath() async {
    checkPermission();
    Directory? path = Directory("/storage/emulated/0/Campus Link/Attendance Sheet/${widget.uni}/${widget.clg}/${widget.course}/${widget.branch}/${widget.year}/${widget.section}/${widget.subject}");
    if(! ( path.existsSync())){
      await Directory(path.path).create(recursive: true);
    }
    setState(() {
      controller.setCurrentPath=path.path;
      loading=false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setpath();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height*1,
      width: size.width*1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // Colors.black,
            // Colors.deepPurple,
            // Colors.purpleAccent
            const Color.fromRGBO(86, 149, 178, 1),

            const Color.fromRGBO(68, 174, 218, 1),
            //Color.fromRGBO(118, 78, 232, 1),
            Colors.deepPurple.shade300
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          // shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //       bottomRight: Radius.circular(30),
          //       bottomLeft: Radius.circular(30),
          //     )
          // ),
          backgroundColor: Colors.black26,
          centerTitle: true,
          title: AutoSizeText(
            "Download Attendance",
            style: GoogleFonts.gfsDidot(fontSize: size.height*0.03, color: Colors.black),
          ),
        ),
        body: loading?
        const CircularProgressIndicator()
            :
        Stack(
          children: [
            SizedBox(
              height: size.height*0.9,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height*0.85,
                    child: FileManager(
                        controller: controller,
                        builder: (context, snapshot) {
                          final List<FileSystemEntity> entities = snapshot;
                          int filescount=0;
                          if(!(entities.length.isNaN || entities.length.isInfinite)){
                            filescount=entities.length;
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                            itemCount: filescount,
                            itemBuilder: (context, index) {
                              FileSystemEntity entity = entities[index];
                              print(".........Entity: $entity");
                              return Padding(
                                padding:  const EdgeInsets.only(top:8.0),
                                child: Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: FileManager.isFile(entity)
                                            ?
                                        SizedBox(
                                            height: size.height*0.06,
                                            child: const Image(image: AssetImage("assets/images/excel.png"),fit: BoxFit.contain,))
                                            :  Icon(Icons.folder,color: Colors.white,size: size.height*0.042),
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            AutoSizeText(
                                              FileManager.basename(
                                                entity,
                                                showFileExtension: true,
                                              ),
                                              style: GoogleFonts.exo(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500

                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      await Share.shareXFiles(
                                                          [XFile(entity.path)], text: '${widget.course} ${widget.uni} ${widget.year} (${widget.section}) ${widget.subject} Attendance Sheet');
                                                    },
                                                    icon: const Icon(Icons.share,color: Colors.black,)),
                                                IconButton(
                                                    onPressed: () async {
                                                      await File(entity.path).delete();
                                                      setState(() {});
                                                    },
                                                    icon: const Icon(Icons.delete_outline,color: Colors.black,)),
                                              ],
                                            ),

                                          ],
                                        ),
                                        subtitle: subtitle(entity),
                                        onTap: () async {
                                          OpenFile.open(entity.path);
                                          if (FileManager.isDirectory(entity)) {
                                            // open the folder
                                            controller.openDirectory(entity);

                                            // delete a folder
                                            // await entity.delete(recursive: true);

                                            // rename a folder
                                            // await entity.rename("newPath");

                                            // Check weather folder exists
                                            // entity.exists();

                                            // get date of file
                                            // DateTime date = (await entity.stat()).modified;
                                          } else {
                                            // delete a file
                                            // await entity.delete();

                                            // rename a file
                                            // await entity.rename("newPath");

                                            // Check weather file exists
                                            // entity.exists();

                                            // get date of file
                                            // DateTime date = (await entity.stat()).modified;

                                            // get the size of the file
                                            // int size = (await entity.stat()).size;
                                          }
                                        },
                                      ),
                                      const Divider(
                                        height: 2,
                                        color: Colors.black87,
                                        indent: 5,
                                        endIndent: 5,
                                        thickness: 2,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },);}),
                  ),
                  SizedBox(
                    height: size.height*0.03,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple,
                          Colors.purpleAccent
                        ]
                    ),
                    borderRadius:  BorderRadius.all(Radius.circular(15))
                ),
                height: size.height * 0.048,
                width: size.width*0.3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 20,
                      backgroundColor: Colors.black12),
                  onPressed: () {
                    showModalBottomSheet(
                      isDismissible: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                              height: size.height * 0.34,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  SizedBox(
                                    height: size.height*0.2,
                                    width: size.width,
                                    child: Column(
                                      mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "From :",
                                              style: GoogleFonts.exo(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.42,
                                              child: TextField(
                                                controller: start_date_controller,
                                                onTap: () async {
                                                  final startdate = await _selectDate(context);
                                                  setState(() {
                                                    print(startdate.toString());
                                                    start_date_controller.text =
                                                        startdate.toString().substring(0, 10);
                                                  });
                                                },
                                                keyboardType: TextInputType.none,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                    focusedBorder: const OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.all(Radius.circular(15)),
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                        )),
                                                    hintText: "Start Date",
                                                    prefixIcon: Icon(Icons.date_range,
                                                        color: Colors.black54,
                                                        size: size.height * 0.03),
                                                    fillColor: Colors.transparent,
                                                    enabledBorder: const OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.all(Radius.circular(15)),
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                        ))),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "      To :",
                                              style: GoogleFonts.exo(
                                                  fontSize: 18,
                                                  color: Colors.black, fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.42,
                                              child: TextField(
                                                controller: end_date_controller,
                                                cursorColor: Colors.black,
                                                onTap: () async {
                                                  final enddate = await _selectDate(context);
                                                  setState(() {
                                                    print(enddate.toString());
                                                    end_date_controller.text =
                                                        enddate.toString().substring(0, 10);
                                                  });
                                                },
                                                keyboardType: TextInputType.none,
                                                decoration: InputDecoration(
                                                    focusedBorder: const OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.all(Radius.circular(15)),
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                        )),
                                                    hintText: "End Date",
                                                    prefixIcon: Icon(Icons.date_range,
                                                        color: Colors.black54,
                                                        size: size.height * 0.03),
                                                    fillColor: Colors.transparent,
                                                    enabledBorder: const OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.all(Radius.circular(15)),
                                                        borderSide: BorderSide(color: Colors.black))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)),
                                        elevation: 20,
                                        backgroundColor: Colors.black12),
                                    onPressed: () async {
                                      List<dynamic> email=[];
                                      Map<String,String> roll={};
                                      Map<String,String> name={};
                                      var excel = Excel.createExcel();
                                      Sheet sheetObject = excel["${start_date_controller.text.trim().split("-")[2]} ${months[int.parse(start_date_controller.text.trim().split("-")[1])-1]}-${end_date_controller.text.trim().split("-")[2]} ${months[int.parse(end_date_controller.text.trim().split("-")[1])-1]}"];
                                      List<dynamic> initialrow=[];
                                      initialrow.add("Name");
                                      initialrow.add("Roll Number");
                                      print(".................");
                                      print(start_date_controller.text.trim().split("-"));
                                      List<dynamic> startdate= start_date_controller.text.trim().split("-");
                                      List<dynamic> lastdate= end_date_controller.text.trim().split("-");

                                      for(int year= int.parse(startdate[0]); year<= int.parse(lastdate[0]) ; year++){
                                        print(".............year : $year");
                                        int lastmonth;
                                        int startmonth;
                                        if(year != int.parse(lastdate[0])){
                                          lastmonth=12;
                                        }
                                        else{
                                          lastmonth = int.parse(lastdate[1]);
                                        }

                                        if(year != int.parse(startdate[0])){
                                          startmonth=1;
                                        }
                                        else{
                                          startmonth = int.parse(startdate[1]);
                                        }

                                        for(int month = startmonth ; month <=lastmonth ; month++){
                                          int lastday;
                                          int startday;
                                          print(".............month : $month ..............lastmonth $lastmonth");
                                          if(month == int.parse(lastdate[1]) && year == int.parse(lastdate[0])){
                                            lastday =int.parse(lastdate[2]);
                                          }
                                          else{
                                            lastday = database().getDaysInMonth(year, month);
                                          }
                                          if(month == int.parse(startdate[1]) && year == int.parse(startdate[0])){
                                            startday = int.parse(startdate[2]);
                                          }
                                          else{
                                            startday=1;
                                          }

                                          print("..................startday: $startday .....Lastday $lastday");
                                          for(int day=startday ; day<= lastday; day++){
                                            print(".............day : $day");
                                            String monthName=months[month-1];
                                            initialrow.add("$day ${monthName.substring(0,4)} $year");
                                          }


                                        }

                                      }

                                      initialrow.add("Total");
                                      initialrow.add("Out of");
                                      initialrow.add("Percentage");
                                      sheetObject.appendRow(initialrow);




                                      await  FirebaseFirestore
                                          .instance
                                          .collection("Students")
                                          .where("University", isEqualTo: widget.uni)
                                          .where("College", isEqualTo: widget.clg)
                                          .where("Course", isEqualTo: widget.course)
                                          .where("Branch", isEqualTo: widget.branch)
                                          .where("Year", isEqualTo: widget.year)
                                          .where("Section", isEqualTo: widget.section)
                                          .where("Subject", arrayContains: widget.subject)
                                          .where("Name",isNull: false)
                                          .orderBy("Name")
                                          .get()
                                          .then((value) =>
                                          value.docs.forEach((element) {
                                            email.add(element.data()["Email"]);
                                            roll[element.data()["Email"]]=element.data()["Rollnumber"];
                                            name[element.data()["Email"]]=element.data()["Name"];
                                          }));
                                      print(roll);
                                      print(name);
                                      for (var element in email){
                                        print(element);
                                        int outof=0;
                                        int total=0;
                                        List<dynamic> count=[];
                                        count.add(name[element]);
                                        count.add(roll[element]);

                                        for(int year= int.parse(startdate[0]); year<= int.parse(lastdate[0]) ; year++){
                                          print(".............year : $year");
                                          int lastmonth;
                                          int startmonth;
                                          if(year != int.parse(lastdate[0])){
                                            lastmonth=12;
                                          }
                                          else{
                                            lastmonth = int.parse(lastdate[1]);
                                          }

                                          if(year != int.parse(startdate[0])){
                                            startmonth=1;
                                          }
                                          else{
                                            startmonth = int.parse(startdate[1]);
                                          }

                                          for(int month = startmonth ; month <=lastmonth ; month++){
                                            int lastday;
                                            int startday;
                                            print(".............month : $month ..............lastmonth $lastmonth");
                                            if(month == int.parse(lastdate[1]) && year == int.parse(lastdate[0])){
                                              lastday =int.parse(lastdate[2]);
                                            }
                                            else{
                                              lastday = database().getDaysInMonth(year, month);
                                            }
                                            if(month == int.parse(startdate[1]) && year == int.parse(startdate[0])){
                                              startday = int.parse(startdate[2]);
                                            }
                                            else{
                                              startday=1;
                                            }
                                            var doc = await  FirebaseFirestore.instance.collection("Students").doc(element).collection('Attendance').doc("${widget.subject}-$month").get();



                                            print("..................startday: $startday .....Lastday $lastday");
                                            for(int day=startday ; day<= lastday; day++){
                                              int countP=0;
                                              int countl=0;
                                              var temp=doc.data()?["$day"];
                                              if(temp != null){
                                                print("////////////////////////$temp");
                                                for(int j=0;j<doc.data()?["$day"].length;j++){

                                                  outof++;
                                                  countl++;
                                                  print(".....................${doc.data()?["$day"]}");
                                                  if (doc.data()?["$day"][j]["Status"] != "Absent") {
                                                    countP++;
                                                    total++;
                                                  }
                                                }
                                              }
                                              else{
                                                countP=0;
                                                countl=0;
                                              }
                                              count.add("$countP / $countl");
                                              print(countP);
                                              print(total);
                                            }


                                          }

                                        }
                                        count.add(total);
                                        count.add(outof);
                                        count.add("${((total/outof)*100).toStringAsFixed(2)}%");

                                        print(".......$count........");
                                        await sheetObject.appendRow(count);//row++;
                                      }
                                      var fileBytes = excel.save();
                                      print(fileBytes);
                                      print(start_date_controller.text);
                                      var fileName="${start_date_controller.text.trim().split("-")[2]} ${months[int.parse(start_date_controller.text.trim().split("-")[1])-1]}-${end_date_controller.text.trim().split("-")[2]} ${months[int.parse(end_date_controller.text.trim().split("-")[1])-1]}.xls";
                                      Directory? path = Directory("/storage/emulated/0/Campus Link/Attendance Sheet/${widget.uni}/${widget.clg}/${widget.course}/${widget.branch}/${widget.year}/${widget.section}/${widget.subject}");
                                      if(! ( path.existsSync())){
                                        await Directory(path.path).create(recursive: true);
                                      }
                                      File(join('${path.path}/$fileName'))..create(recursive: true)..writeAsBytes(fileBytes!).whenComplete((){ Navigator.pop(context);

                                      setState((){

                                      });
                                      });
                                    },
                                    child: Text(
                                      "Create Attendance Sheet",
                                      style: GoogleFonts.exo(
                                          color: Colors.black, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },);
                      },).whenComplete(() => setState((){}));
                  },
                  child: Text(
                    "Download",
                    style: GoogleFonts.exo(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        )
        ,
      ),
    );
  }
  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;

            return AutoSizeText(
              FileManager.formatBytes(size),
              style: GoogleFonts.exo(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500

              ),
            );
          }
          return AutoSizeText(
            "${snapshot.data!.modified}".substring(0, 10),
            style: GoogleFonts.exo(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500

            ),
          );
        } else {
          return AutoSizeText("",style: GoogleFonts.exo(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500

          ),);
        }
      },
    );
  }
  checkPermission() async {
    var permission = await checkALLPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }
  Future<DateTime> _selectDate(BuildContext context) async {
    DateTime date = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2023, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      date = picked;
      print(date);
    }
    return  date;
  }
}