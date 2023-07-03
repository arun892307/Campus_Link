import 'dart:async';

import 'package:flutter/material.dart';
import '../Database/database.dart';


class AllStudents extends StatefulWidget {
  const AllStudents({Key? key}) : super(key: key);

  @override
  State<AllStudents> createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(milliseconds: 0), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: studentslistview()),
          ],
        ),
      ),
    );
  }
  Widget studentslistview() {

    return ListView.builder(

      itemCount: student_id.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,right: MediaQuery.of(context).size.width*0.03),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromRGBO(12, 12, 12, 1),
              border: Border.all(color: Colors.black,width: 1.5),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 6,
                  blurStyle: BlurStyle.outer,
                  color: Colors.amber,
                  offset: Offset(0, 0),
                )
              ]
          ),
          margin: const EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height * 0.07,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  Text(allstudentsname[student_id[index]]![0],style: const TextStyle(color: Colors.white)),
                  Text(allstudentsname[student_id[index]]![1],style: const TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        distanceList.add(student_id[index]);
                        distanceList=distanceList.toSet().toList();
                      },
                    icon: Icon(Icons.check,color: distanceList.contains(student_id[index])
                        ?
                    const Color.fromRGBO(150, 150, 150, 1)
                        :
                    Colors.green)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.03,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
