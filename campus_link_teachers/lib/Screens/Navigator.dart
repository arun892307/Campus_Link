import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:page_transition/page_transition.dart';
import '../Database/database.dart';
import 'Assignments.dart';
import 'Attendance.dart';
import 'Filters.dart';
import 'Notes.dart';
import 'Performance.dart';
import 'Sessional.dart';

class Nevi extends StatefulWidget {
  const Nevi({Key? key}) : super(key: key);

  @override
  State<Nevi> createState() => _NeviState();
}

class _NeviState extends State<Nevi> {
  int index = 2;
  final screens = [
    const Assignments_upload(),
    const Notes(),
    const Attendance(),
    const Performance(),
    const Sessional(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                tecloc=await database().getloc();
                active_Student_loc.clear();
                active_student_email.clear();
                await Navigator.push(
                  context,
                  PageTransition(
                    child: const Filters(),
                    type: PageTransitionType.bottomToTopJoined,
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.bottomCenter,
                    childCurrent: const Attendance(),
                  ),
                );
              },
              icon: const Icon(Icons.filter_list_alt))
        ],
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(
            color: const Color.fromRGBO(150, 150, 150, 1),
            fontWeight: FontWeight.w900,
            fontSize: MediaQuery.of(context).size.height * 0.03),
        title: const Text('Campus Link'),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        animationCurve: Curves.linear,
        height: MediaQuery.of(context).size.height * 0.065,
        animationDuration: const Duration(milliseconds: 100),
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
        backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
        buttonBackgroundColor: const Color.fromRGBO(150, 150, 150, 1),
        color: Colors.black,
        index: index,
        items: [
          index == 0
              ? const Icon(
                  Icons.assignment,
                  color: Colors.black,
                )
              : const Icon(
                  Icons.assignment_outlined,
                  color: Colors.white,
                ),
          index == 1
              ? const Icon(
                  Icons.notes,
                  color: Colors.black,
                )
              : const Icon(
                  Icons.notes_outlined,
                  color: Colors.white,
                ),
          index == 2
              ? const Icon(
                  Icons.calendar_month,
                  color: Colors.black,
                )
              : const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.white,
                ),
          index == 3
              ? const Icon(
                  Icons.pie_chart,
                  color: Colors.black,
                )
              : const Icon(
                  Icons.pie_chart_outline_outlined,
                  color: Colors.white,
                ),
          index == 4
              ? const Icon(
                  Icons.grading,
                  color: Colors.black,
                )
              : const Icon(
                  Icons.grading_outlined,
                  color: Colors.white,
                )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () {
            return database().signOut();
          },
          child: screens[index]),
    );
  }
}
