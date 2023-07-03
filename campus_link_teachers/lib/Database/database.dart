import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

List student_id = [];
dynamic instance_of_student_doc = [];
dynamic teacher_data;
String subject = '';
Map<String, GeoPoint> active_Student_loc = {};
List active_student_email = [];
List<String> distanceList = [];
List months = [
  "January",
  "Feburary",
  "March",
  "April",
  "May",
  "June",
  "July",
  'August',
  "September",
  "October",
  "November",
  "December"
];
Map<String,List> allstudentsname = {};
Position tecloc= Position.fromMap({'latitude': 0.0, 'longitude': 0.0});


class database {
  Future signOut() async {
    try {
      return FirebaseAuth.instance.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<String?> email() async {
    return await FirebaseAuth.instance.currentUser?.email;
  }

  Future<void> filter() async {
    try {
      instance_of_student_doc = await FirebaseFirestore.instance
          .collection("Students")
          .where("Subject", isEqualTo: subject)
          .get();
    } on FirebaseException catch (e) {
      InAppNotifications.instance
        ..titleFontSize = 14.0
        ..descriptionFontSize = 14.0
        ..textColor = Colors.black
        ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
        ..shadow = true
        ..animationStyle = InAppNotificationsAnimationStyle.scale;
      InAppNotifications.show(
          title: 'Failed',
          duration: const Duration(seconds: 2),
          description: e.toString(),
          leading: const Icon(
            Icons.error_outline_outlined,
            color: Colors.red,
            size: 55,
          ));
    }
  }

  Future<void> student_locationmap_email() async {
    instance_of_student_doc.docs.forEach((id) async {
      student_id.add(id.data()['Email']);
      allstudentsname.addAll({
        id.data()['Email']:[id.data()['Name'], id.data()['Rollnumber']]
      });
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(id.data()['Email'])
          .update({"Attendance": true});

      if (id.data()['${subject}_${months[DateTime.now().month - 1]}'] == null) {
        for (int i = 0;
            i < getDaysInMonth(DateTime.now().year, DateTime.now().month);
            i = i + 1) {
          await FirebaseFirestore.instance
              .collection('Students')
              .doc(id.data()['Email'])
              .update({
            '${subject}_${months[DateTime.now().month - 1]}':
                FieldValue.arrayUnion([
              {'$i': 0}
            ])
          });
        }
      }
    });

    student_id = student_id.toSet().toList();
    for (var element in student_id) {
      DocumentReference reference =
          FirebaseFirestore.instance.collection('Students').doc(element);
      reference.snapshots().listen(
        (event) async {
          await filter();
          dynamic data = await reference.get();
          print("Active is :${data.data()['Active']}");
          print("Attendance is :${data.data()['Attendance']}");
          bool test = data.data()['Active'];
          if (test) {
            print("I am \n\n\n\n\n\n");
            active_Student_loc.addAll({data.data()["Email"]: data.data()['Location']});
            allstudentsname.addAll({data.data()['Email']:[data.data()["Name"],data.data()["Rollnumber"]]});
            active_student_email.add(data.data()['Email']);
            active_student_email = active_student_email.toSet().toList();
          }
        },
        onError: (error) => print("Listen failed: $error"),
      );
    }
    ;
    return;
  }

  Future<Position> getloc() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      print("enabled permission");
    } else {
      print('not enabled ermission');
    }
    var status = await Permission.location.status;
    if (status.isGranted) {
      print("Granted");
    } else if (status.isDenied) {
      Map<Permission, PermissionStatus> status =
          await [Permission.location].request();
    }
    if (await Permission.location.isPermanentlyDenied ||
        await Permission.location.isRestricted) {
      openAppSettings();
    }

    Position x = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return x;
  }

  Future getUserData() async {
    List userdetail = [];
    User? user = await FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection("Teachers")
          .doc(user!.email)
          .get()
          .then((value) {
        userdetail.add(value.data()!);
      });

      return userdetail;
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchuserdata() async {
    try {
      dynamic result = await getUserData();
      if (result != null) {
        teacher_data = result;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void distanceFilter() {
    for (String email in active_student_email) {
      GeoPoint? stu = active_Student_loc[email];
      int dis = Geolocator.distanceBetween(
          tecloc.latitude, tecloc.longitude, stu!.latitude, stu.longitude).floor();
      if(dis>6){
        distanceList.add(email);
        distanceList=distanceList.toSet().toList();
      }
    }
  }

  void markAttendance() {
    String month = months[DateTime.now().month - 1];
    int day = DateTime.now().day;
    int? store;
    for (var student in distanceList) {
      List attendance;
      instance_of_student_doc.docs.forEach((id) async {
        if (id.data()['Email'] == student) {
          attendance = List.from(
              id.data()['${subject}_${months[DateTime.now().month - 1]}']);
          attendance[DateTime.now().day - 1]['${DateTime.now().day - 1}'] =
              attendance[DateTime.now().day - 1]['${DateTime.now().day - 1}'] +
                  1;
          await FirebaseFirestore.instance
              .collection('Students')
              .doc(student)
              .update({
            '${subject}_${months[DateTime.now().month - 1]}': attendance
          });

          print("$attendance");
        }
      });
    }
  }

  Future<void> attendanceDone() async {
    for (var element in student_id) {
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(element)
          .update({
        'Active': false,
        'Attendance': false,
        'Location': const GeoPoint(0, 0),
      });
    }
    active_student_email.clear();
    distanceList.clear();
  }

  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysInMonth[month - 1];
  }
}
