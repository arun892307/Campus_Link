import 'dart:async';
import 'package:campus_link_teachers/Database/database.dart';
import 'package:campus_link_teachers/Screens/All%20Students-attendance.dart';
import 'package:flutter/material.dart';
import 'Selected for attendance.dart';
import 'loadingscreen.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);
  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final list = [const AllStudents(), const SelectedStudents()];
  final students = [];
  bool attendanceLoading = false;
  bool listbool = true,all=true,appeared=false;
  int index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(milliseconds: 0), (timer) {
      if (mounted) {
        setState(() {});
        database().distanceFilter();
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return attendanceLoading
        ? const loading()
        : Scaffold(
      backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
              flexibleSpace: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: all ? Colors.amber:const Color.fromRGBO(28, 28, 28, 1),
                            offset: const Offset(0, 0),
                            blurRadius: 20,
                        )
                      ]),
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors.amber,
                          ),
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            index = 0;
                            all=true;
                            appeared=false;
                          });
                        },
                        child: Text("All Students (${student_id.length})"),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: appeared?Colors.amber:const Color.fromRGBO(28, 28, 28, 1),
                                offset: const Offset(0, 0),
                                blurRadius: 20)
                          ]
                      ),
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors.amber,
                          ),
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            index = 1;
                            all=false;
                            appeared=true;
                          });
                        },
                        child: Text(
                            "Appeared Students (${distanceList.length})"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: subject.length<1
                ? const Center(
                    child: Text("Please apply filter to take attendance",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20),),
                  )
                : list[index],
          );
  }
}
